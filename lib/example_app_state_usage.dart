// Example: How to use the new App State Management System

import 'core/state/app_state_manager.dart';

// Example usage in your app:

/*
1. **App State Manager Initialization** (in main.dart):
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app state manager
  final appStateManager = AppStateManager.instance;
  await appStateManager.initializeAppState();
  
  runApp(AppWrapper(viewModels: viewModels));
}
```

2. **Navigation Based on App State** (in AppWrapper):
```dart
StreamBuilder<AppStateData>(
  stream: AppStateManager.instance.stateStream,
  builder: (context, snapshot) {
    final appState = snapshot.data;
    
    switch (appState?.state) {
      case AppState.notLoggedIn:
        return SigninSignupScreen();
      case AppState.profileIncomplete:
        return ProfileScreen();
      case AppState.profileCompleted:
        return HomeScreen();
      default:
        return SplashScreen();
    }
  },
)
```

3. **Update State After Login** (in VerifyOtpUseCase):
```dart
// After successful OTP verification
await _appStateManager.onLoginSuccess(
  accessToken: verification.accessToken!,
  accessTokenExpiry: verification.accessTokenExpiry ?? 0,
  refreshToken: verification.refreshToken!,
  refreshTokenExpiry: verification.refreshTokenExpiry ?? 0,
  isApproved: verification.isApproved,
);
```

4. **Update State After Profile Completion** (in SignInViewModel):
```dart
// After successful profile submission
if (response.success) {
  await AppStateManager.instance.onProfileCompleted();
}
```

5. **Logout**:
```dart
await AppStateManager.instance.logout();
```

**App States:**
- `AppState.initializing`: App is starting up
- `AppState.notLoggedIn`: User needs to login
- `AppState.profileIncomplete`: User is logged in but profile not completed
- `AppState.profileCompleted`: User is logged in and profile is completed
- `AppState.tokenExpired`: Token needs refresh
- `AppState.error`: Error occurred

**Benefits:**
- ✅ No more checking API responses for navigation
- ✅ Centralized state management
- ✅ Automatic navigation based on app state
- ✅ Clean separation of concerns
- ✅ Easy to test and maintain
- ✅ Uses streams for reactive updates
*/ 