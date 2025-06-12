import 'package:http/http.dart' as http;

class BaseApiService {
  final String baseUrl;
  final http.Client _client;

  BaseApiService({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  http.Client get client => _client;
}
