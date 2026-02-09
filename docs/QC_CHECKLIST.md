# Subby QA 체크리스트 (수동 테스트)

> 자동화 테스트(`flutter test`)가 커버하지 못하는 항목만 정리
> 실기기/에뮬레이터에서 직접 확인 필요

## 자동화 테스트로 이미 커버된 항목 (확인 불필요)

| 영역 | 테스트 파일 | 커버 내용 |
|------|-----------|----------|
| 결제일 경계값 | `test/unit/billing_date_calculator_test.dart` | 31일→2월, 윤년/평년, 연도전환, 오늘==결제일 |
| 환율 변환 | `test/unit/exchange_rate_test.dart` | getRate 반올림, convert cross-rate, 동일통화 |
| 통화 포맷 | `test/unit/currency_converter_test.dart` | ₩/$/€/¥ 포맷, formatWithConversion |
| 포맷터 | `test/unit/currency_formatter_test.dart` | KRW 천단위, USD 소수점 |
| Currency enum | `test/unit/currency_test.dart` | fromCode, symbol, decimalDigits |
| DB CRUD | `test/data/database_crud_test.dart` | insert/update/delete, nullable, 소수점 정밀도 |

---

## 수동 QA 항목

### 1. 구독 등록/수정 UI 흐름

| # | 확인 항목 | 확인 방법 | 심각도 |
|---|---------|---------|--------|
| Q-1 | 이름 미입력 시 저장 → "서비스를 선택해주세요" 스낵바 | 이름 비우고 저장 버튼 탭 | High |
| Q-2 | 금액 0원 시 저장 → "금액을 입력해주세요" 스낵바 | 금액 0으로 저장 시도 | High |
| Q-3 | 프리셋 선택 → 이름/통화/금액/주기 자동 반영 | Netflix 등 프리셋 탭 후 확인 | High |
| Q-4 | 수정 화면에서 기존 값 pre-fill | 상세 → 수정하기 → 모든 필드 확인 | High |
| Q-5 | 삭제 → 홈 리스트에서 즉시 사라짐 | 상세 → 휴지통 → 삭제 → 홈 확인 | High |

### 2. 기본 통화 변경

| # | 확인 항목 | 확인 방법 | 심각도 |
|---|---------|---------|--------|
| Q-6 | 설정에서 기본 통화 KRW→USD 변경 후 홈 | 모든 구독 금액이 USD로 변환 표시 | **Critical** |
| Q-7 | 환율 미로드 상태에서 앱 크래시 없음 | 비행기 모드 → 앱 실행 → 홈 화면 | High |

### 3. 알림 (실기기 필수)

| # | 확인 항목 | 확인 방법 | 심각도 |
|---|---------|---------|--------|
| Q-8 | Android 13+ 알림 권한 요청 팝업 | 앱 최초 설치 후 알림 설정 ON | High |
| Q-9 | 알림 OFF → FCM 수신 안 됨 | 설정에서 OFF → 푸시 전송 → 무반응 확인 | High |
| Q-10 | 포그라운드 알림 표시 | 앱 열린 상태에서 FCM 전송 | High |

### 4. 오프라인/동기화

| # | 확인 항목 | 확인 방법 | 심각도 |
|---|---------|---------|--------|
| Q-11 | 오프라인에서 구독 추가 → 온라인 복귀 시 sync | 비행기모드 ON → 구독 추가 → OFF → Firestore 확인 | High |
| Q-12 | 앱 강제 종료 후 데이터 유지 | 구독 추가 → 태스크킬 → 재실행 → 목록 확인 | High |

### 5. 다음 결제일 UI 표시

| # | 확인 항목 | 확인 방법 | 심각도 |
|---|---------|---------|--------|
| Q-13 | 상세 화면 "다음 결제일" 날짜 정확성 | 구독 상세 진입 → 표시된 날짜와 기대값 대조 | High |
| Q-14 | 오늘이 결제일 → "다음 결제일"이 오늘로 표시 | billingDay를 오늘 날짜로 설정 → 상세 확인 | Medium |
