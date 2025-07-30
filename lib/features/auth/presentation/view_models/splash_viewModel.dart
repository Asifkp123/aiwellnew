import 'package:aiwel/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network/error/failure.dart';
import '../../../../core/state/app_state_manager.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_access_token_use_case.dart';
import '../../domain/usecases/get_access_token_expiry_use_case.dart';
import '../../domain/usecases/get_refresh_token_use_case.dart';
import '../../domain/usecases/get_refresh_token_expiry_use_case.dart';
import '../../domain/usecases/refresh_token_use_case.dart';
import '../../domain/usecases/check_auth_status_use_case.dart';
import 'package:aiwel/features/auth/presentation/screens/profile_screens/profile_screen.dart';
import 'package:aiwel/features/auth/presentation/screens/signin_signup_screen.dart';
import 'package:aiwel/features/home/home_screen.dart';

class SplashViewModel {
  final AuthRepositoryImpl authRepository;
  final GetAccessTokenUseCase getAccessTokenUseCase;
  final GetAccessTokenExpiryUseCase getAccessTokenExpiryUseCase;
  final GetRefreshTokenUseCase getRefreshTokenUseCase;
  final GetRefreshTokenExpiryUseCase getRefreshTokenExpiryUseCase;
  final RefreshTokenUseCase refreshTokenUseCase;
  // final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final Map<String, dynamic> viewModels;

  SplashViewModel({
    required this.authRepository,
    required this.getAccessTokenUseCase,
    required this.getAccessTokenExpiryUseCase,
    required this.getRefreshTokenUseCase,
    required this.getRefreshTokenExpiryUseCase,
    required this.refreshTokenUseCase,
    // required this.checkAuthStatusUseCase,
    required this.viewModels,
  });

  Future<AppState> handleLetsGetStarted() async {
    await AppStateManager.instance.restoreAppState();
    return AppStateManager.instance.appStateNotifier.value;
  }

  Future<void> handleLetsGetStartedNavigation(BuildContext context) async {
    try {
      print("🚀 Starting handleLetsGetStartedNavigation");
      print(viewModels);
      print("viewModels");

      final appState = await handleLetsGetStarted();
      print("📱 AppState: $appState");

      // Get access token and expiry using use cases
      final accessTokenResult = await getAccessTokenUseCase.execute();
      final accessTokenExpiryResult =
          await getAccessTokenExpiryUseCase.execute();

      String? accessToken;
      int? accessTokenExpiry;
      accessTokenResult.fold((l) => null, (r) => accessToken = r.$1);
      accessTokenExpiryResult.fold((l) => null, (r) => accessTokenExpiry = r);

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      // bool isAccessTokenValid = accessToken != null && accessToken!.isNotEmpty && accessTokenExpiry != null && 1713524930! > now;
      bool isAccessTokenValid = accessToken != null &&
          accessToken!.isNotEmpty &&
          accessTokenExpiry != null &&
          accessTokenExpiry! > now;
      print(accessToken);
      print(accessTokenExpiry.toString());
      print("accesstoken.toString()");
      if (!isAccessTokenValid) {
        // Try to refresh the access token
        final refreshTokenResult = await getRefreshTokenUseCase.execute();
        final refreshTokenExpiryResult =
            await getRefreshTokenExpiryUseCase.execute();

        String? refreshToken;
        int? refreshTokenExpiry;
        refreshTokenResult.fold((l) => null, (r) => refreshToken = r);
        refreshTokenExpiryResult.fold(
            (l) => null, (r) => refreshTokenExpiry = r);

        bool isRefreshTokenValid = refreshToken != null &&
            refreshToken!.isNotEmpty &&
            refreshTokenExpiry != null &&
            refreshTokenExpiry! > now;
        // bool isRefreshTokenValid = refreshToken != null && refreshToken!.isNotEmpty && refreshTokenExpiry != null && refreshTokenExpiry! > now;
        print("accesstokencalled.toString()");

        if (isRefreshTokenValid) {
          print("accesstokencalledvalid.toString()");

          // Call refresh token use case to get new access token
          final refreshResult = await refreshTokenUseCase.execute();
          refreshResult.fold(
            (failure) {
              // Refresh failed, go to sign in
              print("→ Refresh token failed: ${failure.message}");
              Navigator.pushReplacementNamed(
                context,
                SigninSignupScreen.routeName,
                arguments: {
                  'viewModelBase': viewModels[SigninSignupScreen.routeName]
                },
              );
              return;
            },
            (success) async {
              // Refresh successful - new tokens are already stored by RefreshTokenUseCase
              // Now get the updated access token and expiry
              final newAccessTokenResult =
                  await getAccessTokenUseCase.execute();
              final newAccessTokenExpiryResult =
                  await getAccessTokenExpiryUseCase.execute();
              final newRefreshTokenResult =
                  await getRefreshTokenUseCase.execute();
              final newRefreshTokenExpiryResult =
                  await getRefreshTokenExpiryUseCase.execute();

              String? newAccessToken;
              int? newAccessTokenExpiry;
              String? newRefreshToken;
              int? newRefreshTokenExpiry;
              newAccessTokenResult.fold(
                  (l) => null, (r) => newAccessToken = r.$1);
              newAccessTokenExpiryResult.fold(
                  (l) => null, (r) => newAccessTokenExpiry = r);
              newRefreshTokenResult.fold(
                  (l) => null, (r) => newRefreshToken = r);
              newRefreshTokenExpiryResult.fold(
                  (l) => null, (r) => newRefreshTokenExpiry = r);

              print("new access token fetch4444444444");
              // Update our local variables with the new values
              accessToken = newAccessToken;
              accessTokenExpiry = newAccessTokenExpiry;
              isAccessTokenValid = accessToken != null &&
                  accessToken!.isNotEmpty &&
                  accessTokenExpiry != null &&
                  accessTokenExpiry! > now;

              print(accessToken);
              print(newAccessTokenExpiry);
              print(newRefreshTokenExpiry);
              print("new refresh token expiry: $refreshTokenExpiry");
              print("→ Access token refreshed successfully");
            },
          );
        } else {
          // Both tokens are invalid, go to sign in
          print("→ Refresh token expired, navigating to sign in");
          Navigator.pushReplacementNamed(
            context,
            SigninSignupScreen.routeName,
            arguments: {
              'viewModelBase': viewModels[SigninSignupScreen.routeName]
            },
          );
          return;
        }
      }

      print(appState);
      print("appState");

      if (appState is HomeState && isAccessTokenValid) {
        print("→ Navigating to HomeScreen");
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else if (appState is ProfileState && isAccessTokenValid) {
        print("→ Navigating to ProfileScreen");
        Navigator.pushReplacementNamed(
          context,
          ProfileScreen.routeName,
          arguments: {'viewModelBase': viewModels[ProfileScreen.routeName]},
        );
      } else {
        print("→ Navigating to SigninSignupScreen");
        Navigator.pushReplacementNamed(
          context,
          SigninSignupScreen.routeName,
          arguments: {
            'viewModelBase': viewModels[SigninSignupScreen.routeName]
          },
        );
      }
    } catch (e, stackTrace) {
      print("❌ Error in handleLetsGetStartedNavigation: $e");
      print("📍 StackTrace: $stackTrace");

      // Fallback navigation to signin screen
      Navigator.pushReplacementNamed(
        context,
        SigninSignupScreen.routeName,
        arguments: {'viewModelBase': viewModels[SigninSignupScreen.routeName]},
      );
    }
  }
}
