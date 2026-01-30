import * as functions from "firebase-functions";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {onDocumentWritten} from "firebase-functions/v2/firestore";
import {defineSecret} from "firebase-functions/params";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const RTDB_URL = "https://subby-91b88-default-rtdb.asia-southeast1.firebasedatabase.app";

const openExchangeRatesAppId = defineSecret("OPENEXCHANGERATES_APP_ID");

interface ExchangeRatesResponse {
  base: string;
  rates: {
    [key: string]: number;
  };
}

export const syncExchangeRates = onSchedule(
  {
    schedule: "0 9 * * *",
    timeZone: "Asia/Seoul",
    secrets: [openExchangeRatesAppId],
  },
  async () => {
    const appId = openExchangeRatesAppId.value();

    const response = await fetch(
      `https://openexchangerates.org/api/latest.json?app_id=${appId}`
    );

    if (!response.ok) {
      console.error("Exchange rate API error:", response.statusText);
      return;
    }

    const data: ExchangeRatesResponse = await response.json();

    const database = admin.database();
    await database.refFromURL(RTDB_URL + "/exchange_rates").set({
      USD: data.rates.USD,
      KRW: data.rates.KRW,
      EUR: data.rates.EUR,
      JPY: data.rates.JPY,
      updatedAt: Date.now(),
    });

    console.log("Exchange rates synced:", {
      USD: data.rates.USD,
      KRW: data.rates.KRW,
      EUR: data.rates.EUR,
      JPY: data.rates.JPY,
    });
  }
);

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

export const joinGroup = functions.https.onCall(
  async (request): Promise<JoinGroupResponse> => {
    const data = request.data as JoinGroupRequest;
    const auth = request.auth;

    // 인증 확인
    if (!auth) {
      return {
        success: false,
        error: "인증이 필요합니다",
      };
    }

    const userId = auth.uid;
    const {groupCode, nickname} = data;

    // 그룹 코드 유효성 검사
    if (!groupCode || typeof groupCode !== "string") {
      return {
        success: false,
        error: "그룹 코드가 필요합니다",
      };
    }

    if (groupCode.length !== 12 || !/^[A-Z0-9]+$/.test(groupCode)) {
      return {
        success: false,
        error: "유효하지 않은 그룹 코드입니다",
      };
    }

    try {
      const groupRef = db.collection("groups").doc(groupCode);
      const groupDoc = await groupRef.get();

      // 그룹 존재 확인
      if (!groupDoc.exists) {
        return {
          success: false,
          error: "존재하지 않는 그룹입니다",
        };
      }

      const groupData = groupDoc.data()!;
      const members = groupData.members || {};

      // 이미 멤버인지 확인
      if (userId in members) {
        return {
          success: true,
          group: {
            code: groupData.code,
            name: groupData.name,
            ownerId: groupData.ownerId,
            members: Object.keys(members),
            createdAt: groupData.createdAt,
            updatedAt: groupData.updatedAt,
          },
        };
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

      // 업데이트된 그룹 정보 반환
      const updatedDoc = await groupRef.get();
      const updatedData = updatedDoc.data()!;
      const updatedMembers = updatedData.members || {};

      return {
        success: true,
        group: {
          code: updatedData.code,
          name: updatedData.name,
          ownerId: updatedData.ownerId,
          members: Object.keys(updatedMembers),
          createdAt: updatedData.createdAt,
          updatedAt: updatedData.updatedAt,
        },
      };
    } catch (error) {
      console.error("joinGroup error:", error);
      return {
        success: false,
        error: "그룹 참여 중 오류가 발생했습니다",
      };
    }
  }
);

interface FcmToken {
  platform: string;
  updatedAt: admin.firestore.Timestamp;
}

interface UserDocument {
  fcmTokens?: { [token: string]: FcmToken };
  groups?: string[];
}

/**
 * subscriptions 컬렉션 변경 감지 → 그룹 멤버들에게 푸시 알림 전송
 */
export const onSubscriptionChange = onDocumentWritten(
  "groups/{groupCode}/subscriptions/{subscriptionId}",
  async (event) => {
    const groupCode = event.params.groupCode;

    const before = event.data?.before?.data();
    const after = event.data?.after?.data();

    // 변경 유형 판단
    let changeType: "created" | "updated" | "deleted";
    let subscriptionName: string;

    if (!before && after) {
      changeType = "created";
      subscriptionName = after.name || "새 구독";
    } else if (before && !after) {
      changeType = "deleted";
      subscriptionName = before.name || "구독";
    } else if (before && after) {
      changeType = "updated";
      subscriptionName = after.name || "구독";
    } else {
      return;
    }

    // 그룹 멤버 조회
    const groupDoc = await db.collection("groups").doc(groupCode).get();

    if (!groupDoc.exists) return;

    const groupData = groupDoc.data()!;
    const members = groupData.members || {};
    const memberIds = Object.keys(members);

    if (memberIds.length === 0) return;

    // 각 멤버의 FCM 토큰 수집
    const tokens: string[] = [];

    for (const memberId of memberIds) {
      const userDoc = await db.collection("users").doc(memberId).get();

      if (!userDoc.exists) continue;

      const userData = userDoc.data() as UserDocument;
      const fcmTokens = userData.fcmTokens || {};

      tokens.push(...Object.keys(fcmTokens));
    }

    if (tokens.length === 0) return;

    // 알림 메시지 구성
    const messages: { [type: string]: { title: string; body: string } } = {
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

    const {title, body} = messages[changeType];

    // FCM 멀티캐스트 전송
    const message: admin.messaging.MulticastMessage = {
      tokens,
      notification: {
        title,
        body,
      },
      data: {
        type: "subscription_change",
        changeType,
        groupCode,
      },
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

      // 실패한 토큰 로그
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
);
