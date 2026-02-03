# Subby 아키텍처 개요

## 계층 구조

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │    View     │→ │  ViewModel  │→ │      Provider       │  │
│  │  (Widget)   │  │  (Notifier) │  │ (app_state_providers)│  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  ┌─────────────────────┐    ┌───────────────────────────┐   │
│  │       UseCase       │ →  │   Repository (Interface)  │   │
│  │ (비즈니스 로직 캡슐화) │    │    (추상화된 데이터 접근)   │   │
│  └─────────────────────┘    └───────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│  ┌─────────────────────┐    ┌───────────────────────────┐   │
│  │ Repository (Impl)   │ →  │       DataSource          │   │
│  │  (구현체)            │    │ (Local/Remote 데이터 접근) │   │
│  └─────────────────────┘    └───────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                   Infrastructure Layer                       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────────┐  │
│  │  Drift   │  │ Firebase │  │  Shared  │  │  Firebase   │  │
│  │   (DB)   │  │ Firestore│  │   Prefs  │  │  Realtime   │  │
│  └──────────┘  └──────────┘  └──────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 의존성 규칙

- **상위 계층은 하위 계층에만 의존**
- **Domain 계층은 외부 의존성 없음** (순수 Dart)
- **Data 계층만 Infrastructure에 접근**

## 폴더 구조

```
lib/
├── core/
│   └── di/                    # 의존성 주입
│       ├── data/              # DataSource, Service Providers
│       └── domain/            # Repository, UseCase Providers
│
├── data/
│   ├── datasource/            # DataSource 구현체
│   ├── repository/            # Repository 구현체
│   ├── dto/                   # Data Transfer Object
│   ├── mapper/                # DTO ↔ Domain Model 변환
│   └── database/              # Drift 데이터베이스
│
├── domain/
│   ├── model/                 # Domain Model
│   ├── repository/            # Repository 인터페이스
│   └── usecase/               # UseCase
│
└── presentation/
    ├── common/
    │   └── providers/         # 전역 Provider (app_state_providers)
    ├── screen/                # 화면별 View/ViewModel
    └── widget/                # 공용 위젯
```

## 데이터 흐름

### 읽기 (Watch/Get)
```
View → ViewModel → UseCase → Repository(Interface)
                                    ↓
                            Repository(Impl) → DataSource → DB/API
```

### 쓰기 (Create/Update/Delete)
```
View → ViewModel.method() → UseCase.call() → Repository.method()
                                                    ↓
                                            DataSource.method() → DB/API
```

## Provider 계층

```
[View]
   ↓ ref.watch()
[ViewModel Provider] (StateNotifierProvider/NotifierProvider)
   ↓ ref.watch()
[UseCase Provider] (Provider)
   ↓ ref.watch()
[Repository Provider] (Provider)
   ↓ ref.watch()
[DataSource Provider] (Provider)
```
