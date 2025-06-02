import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/models/justification_model.dart';
import 'package:frontend_gesabsence/app/data/services/base_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_justification_api_service.dart';
import 'package:http/http.dart' as http;

class JustificationApiServiceImplJson extends BaseApiService
    implements IJustificationApiService {
  JustificationApiServiceImplJson() : super(baseUrl: ApiConfig.baseUrl);

  // Create a new justification
  @override
  Future<JustificationCreateRequestDto> createJustification(
    JustificationCreateRequestDto justification,
  ) async {
    final client = http.Client();
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/justifications'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(justification.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Convert the response body to JustificationCreateRequestDto
        final responseBody = json.decode(response.body);
        if (responseBody['id'] == null) {
          throw Exception('Server did not return an ID for the justification');
        }
        print(
          '✅ Justification created successfully with ID: ${responseBody['id']}',
        );
        print('✅ Justification details: $responseBody');
        return JustificationCreateRequestDto.fromJson(responseBody);
      } else {
        throw Exception(
          'Failed to create justification: Server returned status code ${response.statusCode}',
        );
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timed out. Please try again later.');
    } on SocketException catch (_) {
      throw Exception('Network error: Unable to connect to the server.');
    } catch (e) {
      throw Exception('An error occurred while creating justification: $e');
    } finally {
      client.close();
    }
  }

  // Update an existing justification
  @override
  Future<void> updateJustification(
    int justificationId,
    Map<String, dynamic> data,
  ) async {
    final client = http.Client();
    try {
      final response = await client
          .put(
            Uri.parse('$baseUrl/justifications/$justificationId'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Justification updated successfully
        return;
      } else {
        throw Exception(
          'Failed to update justification: Server returned status code ${response.statusCode}',
        );
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timed out. Please try again later.');
    } on SocketException catch (_) {
      throw Exception('Network error: Unable to connect to the server.');
    } catch (e) {
      throw Exception('An error occurred while updating justification: $e');
    } finally {
      client.close();
    }
  }

  @override
  Future<void> updateAbsence(int absenceId, Map<String, dynamic> data) async {
    final client = http.Client();
    try {
      final response = await client
          .put(
            Uri.parse('$baseUrl/absences/$absenceId'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Absence updated successfully
        return;
      } else {
        throw Exception(
          'Failed to update absence: Server returned status code ${response.statusCode}',
        );
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timed out. Please try again later.');
    } on SocketException catch (_) {
      throw Exception('Network error: Unable to connect to the server.');
    } catch (e) {
      throw Exception('An error occurred while updating absence: $e');
    } finally {
      client.close();
    }
  }

  @override
  Future<List<Justification?>> getJustificationByEtudiantId(
    int etudiantId,
  ) async {
    final response = await http
        .get(
          Uri.parse('$baseUrl/justifications/?etudiantId=$etudiantId'),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Justification.fromJson(item)).toList();
    } else {
      throw Exception(
        'Failed to load justifications for student ID $etudiantId: ${response.statusCode}',
      );
    }
  }

  @override
  Future<Absence> getAbsenceById(String absenceId) async {
    final response = await http
        .get(
          Uri.parse('$baseUrl/absences/$absenceId'),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return Absence.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load absence with ID $absenceId: ${response.statusCode}',
      );
    }
  }

  @override
  Future<Absence> create(
    String absenceId,
    JustificationCreateRequestDto request,
  ) {
    // TODO: implement create
    throw UnimplementedError();
  }
}
