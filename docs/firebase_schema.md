# Firebase Realtime Database 스키마

## 전체 구조

```
root/
├── presets/                    # 구독 서비스 프리셋 (기존)
│   └── {brandKey}/
├── version                     # 프리셋 버전 (기존)
└── shareGroups/                # 공유 그룹 (신규)
    └── {code}/                 # 12자리 고유 코드
        ├── code                # string
        ├── name                # string
        ├── ownerId             # string (Firebase UID)
        ├── members/            # 멤버 목록
        │   └── {uid}: true     # map 형태로 저장
        ├── createdAt           # timestamp (ms)
        └── subscriptions/      # 공유 구독 목록
            └── {id}/           # UUID
                ├── id
                ├── groupCode
                ├── name
                ├── amount
                ├── currency
                ├── billingDay
                ├── period
                ├── category
                ├── memo
                ├── createdBy
                ├── lastModifiedBy
                ├── createdAt
                └── updatedAt
```

## /shareGroups/{code} 구조 (#10)

| 필드 | 타입 | 설명 |
|-----|------|------|
| code | string | 12자리 고유 코드 (PK) |
| name | string | 그룹 이름 |
| ownerId | string | 그룹장 Firebase UID |
| members | map | `{uid: true}` 형태의 멤버 목록 |
| createdAt | number | 생성 시간 (milliseconds) |

### 예시 데이터
```json
{
  "code": "ABC123XYZ789",
  "name": "우리집 구독",
  "ownerId": "firebase-uid-12345",
  "members": {
    "firebase-uid-12345": true,
    "firebase-uid-67890": true
  },
  "createdAt": 1704614400000
}
```

## /shareGroups/{code}/subscriptions/{id} 구조 (#11)

> **구현 참고**: `Subscription` 모델 하나로 개인/공유 구독 모두 처리
> - `groupCode == null` → 개인 구독 (로컬 DB만 사용)
> - `groupCode != null` → 공유 구독 (Firebase 동기화)

| 필드 | 타입 | 설명 |
|-----|------|------|
| id | string | UUID |
| groupCode | string | 소속 그룹 코드 |
| name | string | 구독 서비스명 |
| amount | number | 금액 |
| currency | string | 통화 (KRW, USD) |
| billingDay | number | 결제일 (1-31) |
| period | string | 주기 (MONTHLY, YEARLY) |
| category | string? | 카테고리 |
| memo | string? | 메모 |
| createdBy | string | 생성자 UID |
| lastModifiedBy | string? | 마지막 수정자 UID |
| createdAt | number | 생성 시간 (ms) |
| updatedAt | number? | 수정 시간 (ms) |

### 예시 데이터
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "groupCode": "ABC123XYZ789",
  "name": "넷플릭스",
  "amount": 17000,
  "currency": "KRW",
  "billingDay": 15,
  "period": "MONTHLY",
  "category": "영상",
  "memo": "프리미엄 요금제",
  "createdBy": "firebase-uid-12345",
  "lastModifiedBy": "firebase-uid-67890",
  "createdAt": 1704614400000,
  "updatedAt": 1704700800000
}
```

## 참고: members를 map으로 저장하는 이유

Firebase Realtime DB에서 배열보다 map이 유리:
- 멤버 존재 여부 O(1) 조회: `members/{uid}` 직접 접근
- Security Rules에서 `data.child('members').child(auth.uid).exists()` 활용
- 동시 수정 시 충돌 방지
