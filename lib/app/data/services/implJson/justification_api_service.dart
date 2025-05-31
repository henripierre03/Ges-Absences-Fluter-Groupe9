import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
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
        // Handle the case where the server does not assign an ID
        throw Exception('Server did not return an ID for the justification');
      }
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
    String justificationId,
    Map<String, dynamic> data,
  ) async {
    final client = http.Client();
    try {
      // Fetch all justifications using the existing method
      List<Justification?> justifications = await getAllJustifications();

      // Find and update the specific justification
      bool justificationFound = false;
      for (var i = 0; i < justifications.length; i++) {
        if (justifications[i]!.id == justificationId) {
          // Update the justification data
          justifications[i] = Justification.fromJson({
            ...justifications[i]!.toJson(),
            ...data,
          });
          justificationFound = true;
          break;
        }
      }

      if (!justificationFound) {
        throw Exception('Justification with ID $justificationId not found');
      }

      // Send the updated list back to the server
      final updateResponse = await client
          .put(
            Uri.parse('$baseUrl/justifications'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(
              justifications
                  .map((justification) => justification!.toJson())
                  .toList(),
            ),
          )
          .timeout(const Duration(seconds: 10));

      if (updateResponse.statusCode != 200) {
        throw Exception(
          'Failed to update justifications: Server returned status code ${updateResponse.statusCode}',
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
Future<void> updateAbsence(String absenceId, Map<String, dynamic> data) async {
  final client = http.Client();
  try {
    // Fetch all absences using the existing method
    List<Absence?> absences = await getAllAbsences();

    // Find and update the specific absence
    bool absenceFound = false;
    for (var i = 0; i < absences.length; i++) {
      if (absences[i]!.id == absenceId) {
        print('✅Found absence with ID: $absenceId');
        print('✅Current absence data: ${absences[i]!.toJson()}');
        
        // Update the absence data
        absences[i] = Absence.fromJson({...absences[i]!.toJson(), ...data});
        absenceFound = true;
        print('✅Data to update: $data');
        break;
      }
    }

    if (!absenceFound) {
      throw Exception('Absence with ID $absenceId not found');
    }

    // Log the URL and the data being sent
    print('✅Updating absence with URL: $baseUrl/absences');
    print('✅Data being sent: ${json.encode(absences.map((absence) => absence!.toJson()).toList())}');

    // Send the updated list back to the server
    final updateResponse = await client.put(
      Uri.parse('$baseUrl/absences'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(absences.map((absence) => absence!.toJson()).toList()),
    ).timeout(const Duration(seconds: 10));

    if (updateResponse.statusCode != 200) {
      print('Server response: ${updateResponse.body}');
      throw Exception(
        'Failed to update absences: Server returned status code ${updateResponse.statusCode}',
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



  // Get all justifications (optional - for admin or comprehensive views)
  @override
  Future<List<Justification?>> getAllJustifications() async {
    final client = http.Client();
    try {
      final response = await client
          .get(Uri.parse('$baseUrl/justifications'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((item) => Justification.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to load justifications: Server returned status code ${response.statusCode}',
        );
      }
    } on TimeoutException catch (_) {
      throw Exception('Connection timed out. Please try again later.');
    } on SocketException catch (_) {
      throw Exception('Network error: Unable to connect to the server.');
    } catch (e) {
      throw Exception('An error occurred while loading justifications: $e');
    } finally {
      client.close();
    }
  }

  // Get justifications by student ID (optional - if needed)
  @override
  Future<List<Justification?>> getJustificationByEtudiantId(
    String etudiantId,
  ) async {
    final allJustifications = await getAllJustifications();
    return allJustifications
        .where((justification) => justification!.etudiantId == etudiantId)
        .toList();
  }

  @override
  Future<List<Absence?>> getAllAbsences() async {
    final response = await http
        .get(
          Uri.parse('$baseUrl/absences'),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Absence.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load absences: ${response.statusCode}');
    }
  }
}
