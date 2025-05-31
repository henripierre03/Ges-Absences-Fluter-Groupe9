import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/models/etudiant_model.dart';
import 'package:frontend_gesabsence/app/data/models/vigile_model.dart';
import 'package:frontend_gesabsence/app/data/services/base_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_login_service.dart';
import 'package:http/http.dart' as http;

class LoginApiServiceImplJson extends BaseApiService
    implements ILoginApiService {
  LoginApiServiceImplJson() : super(baseUrl: ApiConfig.baseUrl);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // First, try to find the user as an etudiant
      final etudiants = await getAllEtudiants();
      final etudiant = etudiants.where(
        (e) => e.email == email && e.password == password,
      ).firstOrNull;

      if (etudiant != null) {
        return {
          'userType': 'etudiant',
          'user': etudiant,
        };
      }

      // If not found as etudiant, try vigile
      print('Fetching vigiles...');
      final vigiles = await getAllVigiles();
      print('Found ${vigiles.length} vigiles');
      final vigile = vigiles.where(
        (v) => v.email == email && v.password == password,
      ).firstOrNull;

      if (vigile != null) {
        print('✅User found as vigile: ${vigile.nom}');
        return {
          'userType': 'vigile',
          'user': vigile,
        };
      }

      // If no user found with these credentials
      throw Exception('Email ou mot de passe incorrect');
    } catch (e) {
      if (e.toString().contains('Email ou mot de passe incorrect')) {
        rethrow;
      }
      throw Exception('Erreur de connexion: ${e.toString()}');
    }
  }

  @override
  Future<List<Etudiant>> getAllEtudiants() async {
    final client = http.Client();
    try {
      final response = await client
          .get(Uri.parse('$baseUrl/etudiants'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((item) => Etudiant.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to load students: Server returned status code ${response.statusCode}',
        );
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timed out. Please try again later.');
    } on SocketException catch (_) {
      throw Exception('Network error: Unable to connect to the server.');
    } catch (e) {
      throw Exception('An error occurred: $e');
    } finally {
      client.close();
    }
  }

  @override
  Future<List<Vigile>> getAllVigiles() async {
    final client = http.Client();
    try {
      final response = await client
          .get(Uri.parse('$baseUrl/vigiles'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((item) => Vigile.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to load vigiles: Server returned status code ${response.statusCode}',
        );
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timed out. Please try again later.');
    } on SocketException catch (_) {
      throw Exception('Network error: Unable to connect to the server.');
    } catch (e) {
      throw Exception('An error occurred: $e');
    } finally {
      client.close();
    }
  }
}