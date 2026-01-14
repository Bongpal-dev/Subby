import * as functions from "firebase-functions";
import {onSchedule} from "firebase-functions/v2/scheduler";
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
    const {groupCode} = data;

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
      await groupRef.update({
        [`members.${userId}`]: true,
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
