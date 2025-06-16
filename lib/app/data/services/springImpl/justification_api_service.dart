import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/dto/response/justification_response.dart';
import 'package:frontend_gesabsence/app/data/models/absence_model.dart';
import 'package:frontend_gesabsence/app/data/services/i_justification_api_service.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class JustificationApiService implements IJustificationApiService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, String>> getAuthHeaders() async {
    final authBox = Hive.box('authBox');
    final token = authBox.get('token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<Absence> getAbsenceById(String absenceId) {
    // TODO: implement getAbsenceById
    throw UnimplementedError();
  }

  @override
  Future<JustificationSimpleResponse> create({
    required String absenceId,
    required List<File> files,
    required String etudiantId,
    required String message,
    bool validation = false,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/mobile/justification/absence/$absenceId',
    );

    final headers = await getAuthHeaders();
    headers.remove('Content-Type');

    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);

    for (var file in files) {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final multipartFile = await http.MultipartFile.fromPath(
        'files',
        file.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);
    }

    request.fields['etudiantId'] = etudiantId;
    request.fields['message'] = message;
    request.fields['validation'] = validation.toString();

    final streamedResponse = await request.send();  
    final response = await http.Response.fromStream(streamedResponse);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      print('Parsed JSON: $json');

      if (json == null) {
        throw Exception('Réponse JSON null');
      }

      final data = json['result'];
      if (data == null) {
        throw Exception('Champ result null dans la réponse');
      }

      if (data is! Map<String, dynamic>) {
        throw Exception(
          'Le champ result n\'est pas un Map<String, dynamic>: ${data.runtimeType}',
        );
      }

      return JustificationSimpleResponse.fromJson(data);
    } else {
      throw Exception('Erreur: ${response.statusCode} ${response.body}');
    }
  }
}
