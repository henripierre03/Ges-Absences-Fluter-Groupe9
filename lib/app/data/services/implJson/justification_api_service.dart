import 'dart:convert';

import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:frontend_gesabsence/app/data/dto/request/justification_create_request.dart';
import 'package:frontend_gesabsence/app/data/dto/response/justification_response.dart';
import 'package:frontend_gesabsence/app/data/services/base_api_service.dart';
import 'package:frontend_gesabsence/app/data/services/i_justification_api_service.dart';
import 'package:http/http.dart' as http;

class JustificationApiServiceImplJson extends BaseApiService implements IJustificationApiService {
  JustificationApiServiceImplJson({http.Client? client})
      : super(baseUrl: ApiConfig.baseUrl);

  @override
  Future<JustificationResponseDto> createJustification(
      JustificationCreateRequestDto justification) async {
    final response = await client.post(
      Uri.parse('$baseUrl/justifications'),
      body: justification.toJson(),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      return JustificationResponseDto.fromJson(jsonData);
    } else {
      throw Exception('Failed to create justification');
    }
  }

  @override
  Future<void> updateAbsence(String absenceId, Map<String, dynamic> absenceData) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/absences/$absenceId'),
      body: absenceData,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update absence');
    }
  }
}