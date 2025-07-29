# Clean Architecture Flow Diagram (Updated)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                VIEW LAYER                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐    ┌─────────────────────────────────────────────────┐    │
│  │   BUTTON    │───▶│  CALL (e.g., submitOtp, submitProfile)        │    │
│  └─────────────┘    └─────────────────────────────────────────────────┘    │
│                              │                                            │
│                              ▼                                            │
│  ┌─────────────────────────────────────────────────────────────────┐      │
│  │  Stream-based Values (messages, state updates)                │      │
│  │  • Navigation (HomeScreen vs ProfileScreen)                   │      │
│  │  • Snackbar messages                                         │      │
│  │  • Loading states                                            │      │
│  │  • Approval status handling                                  │      │
│  └─────────────────────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            VIEW MODEL LAYER                                │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────┐        │
│  │  SUBMIT OTP / SUBMIT PROFILE Function                         │        │
│  │  ┌─────────────────────────────────────────────────────────┐   │        │
│  │  │  CHECKS UI VALIDATION                                  │   │        │
│  │  │  • Email format validation                             │   │        │
│  │  │  • Phone number validation                             │   │        │
│  │  │  • OTP length validation (6 digits)                   │   │        │
│  │  │  • Required field checks                               │   │        │
│  │  └─────────────────────────────────────────────────────────┘   │        │
│  │                              │                               │        │
│  │                              ▼                               │        │
│  │  ┌─────────────────────────────────────────────────────────┐   │        │
│  │  │  CALL USECASE                                          │   │        │
│  │  │  • submitProfileUseCase.execute(...)                   │   │        │
│  │  │  • verifyOtpUseCase.execute(VerifyOtpParams)          │   │        │
│  │  └─────────────────────────────────────────────────────────┘   │        │
│  └─────────────────────────────────────────────────────────────────┘        │
│                              │                                            │
│                              ▼                                            │
│  ┌─────────────────────────────────────────────────────────────────┐        │
│  │  ADD STREAM CLASS + EMIT VALUES TO STREAM                    │        │
│  │  • Loading state updates                                     │        │
│  │  • Success/error messages                                    │        │
│  │  • Navigation triggers (based on approval status)            │        │
│  │  • State management (SignInStatus enum)                      │        │
│  └─────────────────────────────────────────────────────────────────┘        │
└─────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                             USE CASE LAYER                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────┐        │
│  │  IMPLEMENTS REPOSITORY                                        │        │
│  │  ┌─────────────────────────────────────────────────────────┐   │        │
│  │  │  Business Logic Orchestration                          │   │        │
│  │  │  • Call repository methods                             │   │        │
│  │  │  • Handle domain-specific validation                   │   │        │
│  │  │  • Transform data between layers                       │   │        │
│  │  │  • Token management (save tokens via TokenManager)    │   │        │
│  │  │  • Domain validation (identifier, OTP format)         │   │        │
│  │  └─────────────────────────────────────────────────────────┘   │        │
│  └─────────────────────────────────────────────────────────────────┘        │
│                              │                                            │
│                              ▼                                            │
└─────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           REPOSITORY LAYER                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────┐        │
│  │  ABSTRACT REPOSITORY INTERFACE                                │        │
│  │  • AuthRepository                                             │        │
│  │  • PalRepository                                             │        │
│  └─────────────────────────────────────────────────────────────────┘        │
│                              │                                            │
│                              ▼                                            │
│  ┌─────────────────────────────────────────────────────────────────┐        │
│  │  IMPLEMENTATOR OF REPOSITORY                                  │        │
│  │  • AuthRepositoryImpl                                        │        │
│  │  • PalRepositoryImpl                                         │        │
│  │  ┌─────────────────────────────────────────────────────────┐   │        │
│  │  │  Repository Implementation                              │   │        │
│  │  │  • Call data sources                                    │   │        │
│  │  │  • Handle data transformation                           │   │        │
│  │  │  • Manage local/remote data coordination               │   │        │
│  │  │  • Transform API response to domain entities           │   │        │
│  │  │  • Handle Either<Failure, Success> pattern             │   │        │
│  │  └─────────────────────────────────────────────────────────┘   │        │
│  └─────────────────────────────────────────────────────────────────┘        │
│                              │                                            │
│                              ▼                                            │
└─────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          DATA SOURCE LAYER                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────┐        │
│  │  API CALL                                                      │        │
│  │  ┌─────────────────────────────────────────────────────────┐   │        │
│  │  │  HTTP Requests                                         │   │        │
│  │  │  • POST /auth/login_with_otp                          │   │        │
│  │  │  • POST /auth/verify_otp                              │   │        │
│  │  │  • POST /auth/profile                                  │   │        │
│  │  │  • POST /pal/create                                    │   │        │
│  │  └─────────────────────────────────────────────────────────┘   │        │
│  └─────────────────────────────────────────────────────────────────┘        │
│                              │                                            │
│                              ▼                                            │
│  ┌─────────────────────────────────────────────────────────────────┐        │
│  │  RETURN MODEL OF API CALL                                    │        │
│  │  ┌─────────────────────────────────────────────────────────┐   │        │
│  │  │  Response Models                                       │   │        │
│  │  │  • OtpRequestSuccess                                   │   │        │
│  │  │  • VerifyOtpResponse (with headers)                    │   │        │
│  │  │  • SubmitProfileResponse                               │   │        │
│  │  │  • CreatePalResponse                                   │   │        │
│  │  │  • ApiResponse wrapper                                 │   │        │
│  │  └─────────────────────────────────────────────────────────┘   │        │
│  └─────────────────────────────────────────────────────────────────┘        │
└─────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              DATA FLOW BACK                               │
│  ┌─────────────────────────────────────────────────────────────────┐        │
│  │  Response Models flow back up through layers:                 │        │
│  │  Data Source → Repository → Use Case → ViewModel → View       │        │
│  │                                                               │        │
│  │  • Update UI state                                           │        │
│  │  • Show success/error messages                               │        │
│  │  • Trigger navigation (HomeScreen vs ProfileScreen)          │        │
│  │  • Update loading states                                     │        │
│  │  • Handle approval status (isApproved field)                 │        │
│  │  • Save tokens via TokenManager                              │        │
│  └─────────────────────────────────────────────────────────────────┘        │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Key Components Explained (Updated):

### View Layer
- **Button**: User interaction triggers (submit OTP, submit profile)
- **Stream-based Values**: Receives state updates, messages, navigation triggers
- **Navigation**: Handles screen transitions based on API responses and approval status
- **Approval Status Handling**: Routes to HomeScreen if approved, ProfileScreen if not

### ViewModel Layer
- **UI Validation**: Checks email format, phone numbers, OTP length (6 digits), required fields
- **Call UseCase**: Delegates business logic to use case layer with proper parameters
- **Stream Management**: Emits state changes to view using SignInStatus enum
- **State Management**: Manages loading states, error states, and success states

### Use Case Layer
- **Implements Repository**: Depends on repository interfaces
- **Business Logic**: Orchestrates data operations and domain rules
- **Token Management**: Saves access and refresh tokens via TokenManager
- **Domain Validation**: Validates identifier format and OTP format
- **Business Rules**: Handles OTP expiration logic (placeholder)

### Repository Layer
- **Abstract Interface**: Defines contract for data operations
- **Implementation**: Concrete classes that handle data coordination
- **Data Transformation**: Converts API responses to domain entities
- **Error Handling**: Uses Either<Failure, Success> pattern

### Data Source Layer
- **API Calls**: Makes HTTP requests to backend services
- **Response Models**: Returns structured data objects with headers
- **Header Processing**: Extracts tokens from response headers

## Data Flow (Updated):
1. **Downward Flow**: View → ViewModel → UseCase → Repository → DataSource
2. **Upward Flow**: Response Models flow back up to update UI
3. **Token Management**: Tokens are saved in UseCase layer via TokenManager
4. **Approval Status**: Determines navigation flow (HomeScreen vs ProfileScreen)
5. **Error Handling**: Consistent Either<Failure, Success> pattern throughout
6. **Separation**: Each layer has specific responsibilities
7. **Dependency Inversion**: Higher layers depend on abstractions, not concretions

## Key Differences from Original:
- **Token Management**: Added explicit token saving in UseCase layer
- **Approval Status**: Added handling for user approval status
- **Header Processing**: Added extraction of tokens from response headers
- **Navigation Logic**: Added conditional navigation based on approval status
- **Domain Validation**: Added specific validation for OTP format and identifier
- **State Management**: Added SignInStatus enum for better state tracking 