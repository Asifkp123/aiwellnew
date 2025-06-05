  import 'dart:convert';
  import 'package:aiwel/core/network/api_service.dart';
import 'package:aiwel/features/auth/data/models/api/verify_otp_response.dart';
import 'package:dartz/dartz.dart';
  import 'package:http/http.dart' as http;
  
  import '../../../../../core/config/api_config.dart';
import '../../../../../core/network/error/failure.dart';
import '../../../domain/usecases/request_otp_use_case.dart';
import '../../models/api/otp_request_success.dart';
  
  class AuthRemoteDataSource {

   final IApiService apiService;

  AuthRemoteDataSource({required this.apiService});

    // Initiates login by sending OTP to the provided email or phone number
      Future<Either<Failure, OtpRequestSuccess>> requestOtp({String? email, String? phoneNumber}) async {

  final payload = email != null ? {'email': email} : {'phone_number': phoneNumber};


  final response = await http.post(

    Uri.parse(ApiConfig.requestOtpEndpoint),
    body: jsonEncode(payload),
    headers: ApiConfig.defaultHeaders,
  );


  if (response.statusCode != 200) {
    return Left(Failure('Failed to request OTP: ${response.reasonPhrase}'));
  }
  return Right(OtpRequestSuccess(response.body)); // Use response.body instead of toString()
    }

    // Verifies the OTP for the given identifier (email or phone number)
      Future<Either<Failure, VerifyOtpResponse>>  verifyOtp(String identifier, String otp) async {
      final payload = {
        'identifier': identifier,
        'otp': otp,
      };
  
      final response = await http.post(
        Uri.parse(ApiConfig.verifyOtpEndpoint),
        body: jsonEncode(payload),
        headers: ApiConfig.defaultHeaders,
      );
  
      if (response.statusCode == 200) {
        return Right(VerifyOtpResponse(response.body, response.headers['authorization']?.replaceAll('Bearer ', '') ?? ''));
      } else {
        return Left(Failure('Failed to verify OTP: ${response.reasonPhrase}'));
      }
    }
  }