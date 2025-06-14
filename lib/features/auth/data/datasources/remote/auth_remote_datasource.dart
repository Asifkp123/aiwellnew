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
   Future<Either<Failure, http.Response>> verifyOtp(String identifier, String otp) async {
     try {
       final payload = {
         'identifier': identifier,
         'otp': otp,
       };

       final response = await http.post(
         Uri.parse(ApiConfig.verifyOtpEndpoint),
         body: jsonEncode(payload),
         headers: ApiConfig.defaultHeaders,
       );
       print(response.headers);
       print(response.body);
       print("response.body");

       return Right(response); // Always return the raw response
     } catch (e) {
       return Left(Failure("Network error: $e")); // Handle network exceptions only
     }
   }
  }

  extension Response on http.Response {

    VerifyOtpResponse toVerifyOtpResponse() {
      final body = jsonDecode(this.body);
      // Safely handle the response field and token
      final responseValue = body['response']?.toString() ?? 'No response data';
      final token = this.headers['authorization']?.replaceAll('Bearer ', '') ?? '';
      return VerifyOtpResponse(responseValue, token);
    }
  }