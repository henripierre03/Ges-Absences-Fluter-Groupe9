import 'dart:typed_data';

abstract class IQRCodeService {
  Future<Uint8List> getQrCode(String matricule);
}
