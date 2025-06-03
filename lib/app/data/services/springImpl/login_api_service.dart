import 'dart:convert';
import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_gesabsence/app/data/dto/request/login_request.dart';
import 'package:frontend_gesabsence/app/data/services/i_login_service.dart';
import 'package:hive/hive.dart';

class LoginApiServiceSpring implements ILoginApiService {
  final String baseUrl = ApiConfig.baseUrl;

  @override
  Future<Map<String, dynamic>> login(LoginRequest loginRequest) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    print('URL: $url');
    print('Request body: ${jsonEncode(loginRequest.toJson())}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(loginRequest.toJson()),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Correction: utiliser 'result' au lieu de 'data'
      final data = responseData['result'];

      if (data == null) {
        throw Exception("Données de connexion manquantes dans la réponse");
      }

      final authBox = Hive.box('authBox');

      // Vérifier que les champs existent avant de les utiliser
      if (data['token'] != null) {
        await authBox.put('token', data['token']);
      }
      if (data['email'] != null) {
        await authBox.put('email', data['email']);
      }
      if (data['role'] != null) {
        await authBox.put('role', data['role']);
      }
      if (data['matricule'] != null) {
        await authBox.put('matricule', data['matricule']);
      }

      return data;
    } else {
      throw Exception(
        "Échec de la connexion : ${response.statusCode} - ${response.body}",
      );
    }
  }

  @override
  Future<void> logout(String? token) async {
    if (token == null) return;

    final url = Uri.parse('$baseUrl/api/auth/logout');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final authBox = Hive.box('authBox');
      await authBox.clear();
    } else {
      throw Exception("Échec de la déconnexion");
    }
  }
}
