import 'dart:async';

import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/dto/request/login_request.dart';
import 'package:frontend_gesabsence/app/data/services/base_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_login_service.dart';

class LoginApiServiceImplJson extends BaseApiService
    implements ILoginApiService {
  LoginApiServiceImplJson() : super(baseUrl: ApiConfig.baseUrl);

  @override
  Future<void> logout(String token) {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> login(LoginRequest loginRequest) {
    // TODO: implement login
    throw UnimplementedError();
  }
}
