import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/services/base_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_login_service.dart';
import 'package:http/http.dart' as http;

class LoginApiServiceImplJson extends BaseApiService
    implements ILoginApiService {
  LoginApiServiceImplJson() : super(baseUrl: ApiConfig.baseUrl);

  @override
  Future<Etudiant> login(String email, String password) async {
    final etudiants = await getAllEtudiants();
    if (etudiants.isEmpty) {
      throw Exception('No students found');
    }
    final etudiant = etudiants.firstWhere(
      (e) => e.email == email && e.password == password,
      orElse: () => throw Exception('Invalid email or password'),
    );
    return etudiant;
  }

  @override
Future<List<Etudiant>> getAllEtudiants() async {
  final client = http.Client();
  try {
    final response = await client
        .get(Uri.parse('$baseUrl/etudiants'))
        .timeout(const Duration(seconds: 10));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Etudiant.fromJson(item)).toList();
    } else {
      throw Exception(
        'Failed to load students: Server returned status code ${response.statusCode}',
      );
    }
  } on TimeoutException catch (_) {
    print('Connection timed out');
    throw Exception('Connection timed out. Please try again later.');
  } on SocketException catch (_) {
    print('Network error: Unable to connect to the server');
    throw Exception('Network error: Unable to connect to the server.');
  } catch (e) {
    print('An error occurred: $e');
    throw Exception('An error occurred: $e');
  } finally {
    client.close();
  }
}

}
