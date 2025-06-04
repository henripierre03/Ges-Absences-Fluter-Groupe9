import 'dart:typed_data';
import 'package:frontend_gesabsence/app/core/utils/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_gesabsence/app/data/services/qr_code_service.dart';

class QrCodeApiServiceSpring implements IQRCodeService {
  final String baseUrl = ApiConfig.baseUrl;

  @override
  Future<Uint8List> getQrCode(String matricule) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/qrcode/$matricule'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception(
          'Erreur lors du chargement du QR code (code ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Erreur réseau ou serveur : $e');
    }
  }
}
