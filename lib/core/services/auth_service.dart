// import 'package:dartz/dartz.dart';
// import '../network/error/failure.dart';
// import 'token_manager.dart';
//
// class AuthService {
//   static AuthService? _instance;
//   static AuthService get instance => _instance ??= AuthService._();
//
//   AuthService._();
//
//   // Check if user should be authenticated on app startup
//   Future<bool> shouldAuthenticateUser() async {
//     final isLoggedIn = await TokenManager.instance.isLoggedIn();
//     if (!isLoggedIn) return false;
//
//     // Check if access token is valid
//     final isAccessTokenValid = await TokenManager.instance.isAccessTokenValid();
//     if (isAccessTokenValid) return true;
//
//     // If access token is expired, check if refresh token is valid
//     final isRefreshTokenValid = await TokenManager.instance.isRefreshTokenValid();
//     return isRefreshTokenValid;
//   }
//
//   // Validate user authentication
//   Future<Either<Failure, bool>> validateUserAuthentication() async {
//     try {
//       final isLoggedIn = await TokenManager.instance.isLoggedIn();
//       if (!isLoggedIn) {
//         return Left(Failure('User not logged in'));
//       }
//
//       final isAccessTokenValid = await TokenManager.instance.isAccessTokenValid();
//       if (isAccessTokenValid) {
//         return Right(true);
//       }
//
//       final isRefreshTokenValid = await TokenManager.instance.isRefreshTokenValid();
//       if (isRefreshTokenValid) {
//         // Token needs refresh - this will be handled by HTTP service
//         return Right(true);
//       }
//
//       // Both tokens are invalid, user needs to login again
//       await TokenManager.instance.clearTokens();
//       return Left(Failure('Session expired, please login again'));
//     } catch (e) {
//       return Left(Failure('Authentication validation failed: $e'));
//     }
//   }
//
//   // Logout user
//   Future<void> logout() async {
//     await TokenManager.instance.clearTokens();
//   }
//
//   // Get user authentication status
//   Future<AuthStatus> getAuthStatus() async {
//     final isLoggedIn = await TokenManager.instance.isLoggedIn();
//     if (!isLoggedIn) return AuthStatus.notLoggedIn;
//
//     final isAccessTokenValid = await TokenManager.instance.isAccessTokenValid();
//     if (isAccessTokenValid) return AuthStatus.authenticated;
//
//     final isRefreshTokenValid = await TokenManager.instance.isRefreshTokenValid();
//     if (isRefreshTokenValid) return AuthStatus.tokenExpired;
//
//     return AuthStatus.sessionExpired;
//   }
// }
//
// enum AuthStatus {
//   notLoggedIn,
//   authenticated,
//   tokenExpired,
//   sessionExpired,
// }