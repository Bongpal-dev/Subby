# Subby QC 리포트

> 작성일: 2025-02-09
> 버전: v0.2.2+6
> 실행 명령: `flutter test test/unit/ test/data/`

---

## 1. 자동화 테스트 결과

**51 passed, 0 failed**

### 1-1. 결제일 계산 (14 tests)

> `test/unit/billing_date_calculator_test.dart`
> 대상: `lib/core/util/billing_date_calculator.dart`

| # | 테스트 | 결과 |
|---|-------|------|
| 1 | 31일 결제 → 2월 평년: 28일 | PASS |
| 2 | 31일 결제 → 2월 윤년: 29일 | PASS |
| 3 | 29일 결제 → 2월 평년: 28일 | PASS |
| 4 | 29일 결제 → 2월 윤년: 29일 | PASS |
| 5 | 31일 결제 → 4월(30일): 30일 | PASS |
| 6 | 12월 → 1월 연도 전환 | PASS |
| 7 | 오늘 == 결제일: 이번 달 반환 | PASS |
| 8 | 오늘 > 결제일: 다음 달 반환 | PASS |
| 9 | 연간 2월 29일 → 평년: 28일 | PASS |
| 10 | 연간 2월 29일 → 윤년: 29일 | PASS |
| 11 | 올해 결제일 안 지남: 올해 반환 | PASS |
| 12 | 올해 결제일 지남: 내년 반환 | PASS |
| 13 | format: 한 자리 월/일 0 패딩 | PASS |
| 14 | format: 두 자리 월/일 그대로 | PASS |

### 1-2. 환율 변환 (10 tests)

> `test/unit/exchange_rate_test.dart`
> 대상: `lib/domain/model/exchange_rate.dart`

| # | 테스트 | 결과 |
|---|-------|------|
| 1 | USD: 반올림 없이 1.0 반환 | PASS |
| 2 | KRW: rate >= 1 → 10단위 반올림 (1345.5 → 1350) | PASS |
| 3 | EUR: rate < 1 → 소수점 2자리 (0.92) | PASS |
| 4 | JPY: rate >= 1 → 10단위 반올림 (149.8 → 150) | PASS |
| 5 | 미지원 통화 코드 → 1.0 | PASS |
| 6 | 대소문자 무관 | PASS |
| 7 | USD → KRW 변환 | PASS |
| 8 | KRW → USD 변환 | PASS |
| 9 | 동일 통화 변환 → 금액 유지 | PASS |
| 10 | EUR → JPY cross-rate | PASS |

### 1-3. 통화 포맷/변환 (6 tests)

> `test/unit/currency_converter_test.dart`
> 대상: `lib/core/utils/currency_converter.dart`

| # | 테스트 | 결과 |
|---|-------|------|
| 1 | convert: USD → KRW | PASS |
| 2 | convert: 동일 통화 | PASS |
| 3 | format: KRW ₩ + 천 단위 구분자 | PASS |
| 4 | format: USD $ + 소수점 2자리 | PASS |
| 5 | formatWithConversion: 동일 통화 → 변환 없음 | PASS |
| 6 | formatWithConversion: 다른 통화 → "원래 (≈ 변환)" | PASS |

### 1-4. 포맷터 (6 tests)

> `test/unit/currency_formatter_test.dart`
> 대상: `lib/core/util/currency_formatter.dart`

| # | 테스트 | 결과 |
|---|-------|------|
| 1 | formatKrw: 천 단위 구분자 (1,000,000) | PASS |
| 2 | formatKrw: 1000 미만 구분자 없음 | PASS |
| 3 | formatKrw: 0 | PASS |
| 4 | formatUsd: 소수점 2자리 고정 | PASS |
| 5 | formatUsd: 정수도 소수점 2자리 | PASS |
| 6 | formatUsd: 0 → "0.00" | PASS |

### 1-5. Currency enum (7 tests)

> `test/unit/currency_test.dart`
> 대상: `lib/domain/model/currency.dart`

| # | 테스트 | 결과 |
|---|-------|------|
| 1 | KRW: symbol ₩, decimalDigits 0 | PASS |
| 2 | USD: symbol $, decimalDigits 2 | PASS |
| 3 | EUR: symbol €, decimalDigits 2 | PASS |
| 4 | JPY: symbol ¥, decimalDigits 0 | PASS |
| 5 | fromCode: 유효한 코드 → Currency 반환 | PASS |
| 6 | fromCode: 대소문자 무관 | PASS |
| 7 | fromCode: 잘못된 코드 → null | PASS |

### 1-6. DB CRUD (8 tests)

> `test/data/database_crud_test.dart`
> 대상: `lib/data/database/database.dart`, `lib/data/datasource/subscription_local_datasource.dart`

| # | 테스트 | 결과 |
|---|-------|------|
| 1 | insert 후 getById: 모든 필드 일치 | PASS |
| 2 | billingMonth null 저장 (월간 결제) | PASS |
| 3 | getAll: 여러 건 저장 후 전체 조회 | PASS |
| 4 | update: 금액 수정 후 반영 | PASS |
| 5 | update: 수정 안 한 필드 유지 | PASS |
| 6 | delete: 삭제 후 조회 시 null | PASS |
| 7 | deleteByGroupCode: 해당 그룹만 삭제 | PASS |
| 8 | 소수점 정밀도: 9.99 저장 → 9.99 조회 | PASS |

---

## 2. 수동 QA 체크리스트

> 자동화 테스트가 커버하지 못하는 항목 (실기기/에뮬레이터 확인 필요)

### 2-1. 구독 등록/수정 UI 흐름

| # | 확인 항목 | 확인 방법 | 결과 |
|---|---------|---------|------|
| Q-1 | 이름 미입력 시 저장 → 스낵바 표시 | 이름 비우고 저장 탭 | |
| Q-2 | 금액 0원 시 저장 → 스낵바 표시 | 금액 0으로 저장 시도 | |
| Q-3 | 프리셋 선택 → 자동 입력 반영 | Netflix 프리셋 탭 후 필드 확인 | |
| Q-4 | 수정 화면 기존 값 pre-fill | 상세 → 수정하기 → 필드 확인 | |
| Q-5 | 삭제 → 홈 리스트 즉시 반영 | 상세 → 삭제 → 홈 확인 | |

### 2-2. 기본 통화 변경

| # | 확인 항목 | 확인 방법 | 결과 |
|---|---------|---------|------|
| Q-6 | 기본 통화 변경 후 홈 금액 변환 | 설정 → KRW→USD → 홈 확인 | |
| Q-7 | 환율 미로드 시 크래시 없음 | 비행기 모드 → 앱 실행 | |

### 2-3. 알림 (실기기 필수)

| # | 확인 항목 | 확인 방법 | 결과 |
|---|---------|---------|------|
| Q-8 | Android 13+ 알림 권한 요청 | 앱 설치 후 알림 ON | |
| Q-9 | 알림 OFF → 수신 차단 | OFF → 푸시 전송 → 무반응 | |
| Q-10 | 포그라운드 알림 표시 | 앱 열린 상태에서 FCM 전송 | |

### 2-4. 오프라인/동기화

| # | 확인 항목 | 확인 방법 | 결과 |
|---|---------|---------|------|
| Q-11 | 오프라인 구독 추가 → 온라인 sync | 비행기모드 → 추가 → 복귀 → Firestore 확인 | |
| Q-12 | 앱 강제 종료 후 데이터 유지 | 추가 → 태스크킬 → 재실행 | |

### 2-5. 다음 결제일 UI 표시

| # | 확인 항목 | 확인 방법 | 결과 |
|---|---------|---------|------|
| Q-13 | 상세 "다음 결제일" 정확성 | 구독 상세 → 날짜 대조 | |
| Q-14 | 오늘 == 결제일 표시 | billingDay를 오늘로 설정 → 상세 | |
