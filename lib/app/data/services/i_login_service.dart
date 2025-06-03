import 'package:frontend_gesabsence/app/data/dto/request/login_request.dart';

abstract class ILoginApiService {
  Future<Map<String, dynamic>> login(LoginRequest loginRequest);
  Future<void> logout(String token);
}
