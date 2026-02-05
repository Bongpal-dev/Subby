import * as functions from "firebase-functions";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {onDocumentWritten} from "firebase-functions/v2/firestore";
import {defineSecret} from "firebase-functions/params";
import * as admin from "firebase-admin";

admin.initializeApp();

// ============================================================
// Constants
// ============================================================

const db = admin.firestore();
const RTDB_URL = "https://subby-91b88-default-rtdb.asia-southeast1.firebasedatabase.app";
const openExchangeRatesAppId = defineSecret("OPENEXCHANGERATES_APP_ID");

// ============================================================
// Types
// ============================================================

interface ExchangeRatesResponse {
  base: string;
  rates: {
    [key: string]: number;
  };
}

interface JoinGroupRequest {
  groupCode: string;
  nickname?: string;
}

interface JoinGroupResponse {
  success: boolean;
  error?: string;
  group?: {
    code: string;
    name: string;
    ownerId: string;
    members: string[];
    createdAt: number;
    updatedAt?: number;
  };
}

interface FcmToken {
  platform: string;
  updatedAt: admin.firestore.Timestamp;
}

interface UserDocument {
  fcmTokens?: { [token: string]: FcmToken };
  groups?: string[];
}

type ChangeType = "created" | "updated" | "deleted";

interface SubscriptionChangeInfo {
  changeType: ChangeType;
  subscriptionName: string;
  updatedBy: string | null;
}

interface NotificationContent {
  title: string;
  body: string;
}

// ============================================================
// Helper Functions
// ============================================================

/**
 * 구독 변경 유형을 판단
 */
function detectSubscriptionChange(
  before: FirebaseFirestore.DocumentData | undefined,
  after: FirebaseFirestore.DocumentData | undefined
): SubscriptionChangeInfo | null {
  if (!before && after) {
    return {
      changeType: "created",
      subscriptionName: after.name || "새 구독",
      updatedBy: after.updatedBy || null,
    };
  }

  if (before && !after) {
    return {
      changeType: "deleted",
      subscriptionName: before.name || "구독",
      updatedBy: before.updatedBy || null,
    };
  }

  if (before && after) {
    return {
      changeType: "updated",
      subscriptionName: after.name || "구독",
      updatedBy: after.updatedBy || null,
    };
  }

  return null;
}

/**
 * 그룹 멤버들의 FCM 토큰 수집 (특정 사용자 제외)
 */
async function collectMemberFcmTokens(
  memberIds: string[],
  excludeUserId: string | null
): Promise<string[]> {
  const tokens: string[] = [];

  for (const memberId of memberIds) {
    if (memberId === excludeUserId) continue;

    const userDoc = await db.collection("users").doc(memberId).get();

    if (!userDoc.exists) continue;

    const userData = userDoc.data() as UserDocument;
    const fcmTokens = userData.fcmTokens || {};

    tokens.push(...Object.keys(fcmTokens));
  }

  return tokens;
}

/**
 * 변경 유형에 따른 알림 내용 생성
 */
function buildNotificationContent(
  changeType: ChangeType,
  subscriptionName: string
): NotificationContent {
  const messages: Record<ChangeType, NotificationContent> = {
    created: {
      title: "새 구독 추가",
      body: `"${subscriptionName}"이(가) 추가되었습니다`,
    },
    updated: {
      title: "구독 수정",
      body: `"${subscriptionName}"이(가) 수정되었습니다`,
    },
    deleted: {
      title: "구독 삭제",
      body: `"${subscriptionName}"이(가) 삭제되었습니다`,
    },
  };

  return messages[changeType];
}

/**
 * FCM 멀티캐스트 메시지 전송
 */
async function sendFcmMulticast(
  tokens: string[],
  notification: NotificationContent,
  data: Record<string, string>
): Promise<void> {
  const message: admin.messaging.MulticastMessage = {
    tokens,
    notification,
    data,
    android: {
      notification: {
        channelId: "subby_sync_channel",
        priority: "high",
      },
    },
  };

  try {
    const response = await admin.messaging().sendEachForMulticast(message);

    console.log(
      `[FCM] Sent to ${response.successCount}/${tokens.length} devices`
    );

    if (response.failureCount > 0) {
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          console.error(`[FCM] Failed for token ${tokens[idx]}:`, resp.error);
        }
      });
    }
  } catch (error) {
    console.error("[FCM] Error sending messages:", error);
  }
}

/**
 * 그룹 데이터를 응답 형식으로 변환
 */
function formatGroupResponse(
  groupData: FirebaseFirestore.DocumentData
): JoinGroupResponse["group"] {
  const members = groupData.members || {};

  return {
    code: groupData.code,
    name: groupData.name,
    ownerId: groupData.ownerId,
    members: Object.keys(members),
    createdAt: groupData.createdAt,
    updatedAt: groupData.updatedAt,
  };
}

/**
 * 그룹 코드 유효성 검사
 */
function validateGroupCode(groupCode: unknown): string | null {
  if (!groupCode || typeof groupCode !== "string") {
    return "그룹 코드가 필요합니다";
  }

  if (groupCode.length !== 12 || !/^[A-Z0-9]+$/.test(groupCode)) {
    return "유효하지 않은 그룹 코드입니다";
  }

  return null;
}

// ============================================================
// Cloud Functions
// ============================================================

/**
 * 환율 정보 동기화 (매일 오전 9시)
 */
export const syncExchangeRates = onSchedule(
  {
    schedule: "0 9 * * *",
    timeZone: "Asia/Seoul",
    secrets: [openExchangeRatesAppId],
  },
  async () => {
    const appId = openExchangeRatesAppId.value();
    const apiUrl = `https://openexchangerates.org/api/latest.json?app_id=${appId}`;

    const response = await fetch(apiUrl);

    if (!response.ok) {
      console.error("Exchange rate API error:", response.statusText);
      return;
    }

    const data: ExchangeRatesResponse = await response.json();
    const rates = {
      USD: data.rates.USD,
      KRW: data.rates.KRW,
      EUR: data.rates.EUR,
      JPY: data.rates.JPY,
      updatedAt: Date.now(),
    };

    const database = admin.database();

    await database.refFromURL(RTDB_URL + "/exchange_rates").set(rates);

    console.log("Exchange rates synced:", rates);
  }
);

/**
 * 그룹 참여
 */
export const joinGroup = functions.https.onCall(
  async (request): Promise<JoinGroupResponse> => {
    const data = request.data as JoinGroupRequest;
    const auth = request.auth;
    const {groupCode, nickname} = data;

    if (!auth) {
      return {success: false, error: "인증이 필요합니다"};
    }

    const userId = auth.uid;
    const validationError = validateGroupCode(groupCode);

    if (validationError) {
      return {success: false, error: validationError};
    }

    try {
      const groupRef = db.collection("groups").doc(groupCode);
      const groupDoc = await groupRef.get();

      if (!groupDoc.exists) {
        return {success: false, error: "존재하지 않는 그룹입니다"};
      }

      const groupData = groupDoc.data()!;
      const members = groupData.members || {};

      // 이미 멤버인 경우
      if (userId in members) {
        return {success: true, group: formatGroupResponse(groupData)};
      }

      // 멤버 추가
      const memberData: { joinedAt: number; nickname?: string } = {
        joinedAt: Date.now(),
      };

      if (nickname) {
        memberData.nickname = nickname;
      }

      await groupRef.update({
        [`members.${userId}`]: memberData,
        memberUids: admin.firestore.FieldValue.arrayUnion(userId),
      });

      const updatedDoc = await groupRef.get();
      const updatedData = updatedDoc.data()!;

      return {success: true, group: formatGroupResponse(updatedData)};
    } catch (error) {
      console.error("joinGroup error:", error);
      return {success: false, error: "그룹 참여 중 오류가 발생했습니다"};
    }
  }
);

/**
 * 구독 변경 감지 → 그룹 멤버들에게 푸시 알림 전송
 */
export const onSubscriptionChange = onDocumentWritten(
  "groups/{groupCode}/subscriptions/{subscriptionId}",
  async (event) => {
    const groupCode = event.params.groupCode;
    const before = event.data?.before?.data();
    const after = event.data?.after?.data();

    // 변경 유형 판단
    const changeInfo = detectSubscriptionChange(before, after);

    if (!changeInfo) return;

    const {changeType, subscriptionName, updatedBy} = changeInfo;

    // 그룹 멤버 조회
    const groupDoc = await db.collection("groups").doc(groupCode).get();

    if (!groupDoc.exists) return;

    const groupData = groupDoc.data()!;
    const members = groupData.members || {};
    const memberIds = Object.keys(members);

    if (memberIds.length === 0) return;

    // FCM 토큰 수집 (변경한 사람 제외)
    const tokens = await collectMemberFcmTokens(memberIds, updatedBy);

    if (tokens.length === 0) return;

    // 알림 전송
    const notification = buildNotificationContent(changeType, subscriptionName);

    await sendFcmMulticast(tokens, notification, {
      type: "subscription_change",
      changeType,
      groupCode,
    });
  }
);
