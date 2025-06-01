class ApiConfig {
  static const bool useMock = true; // Change à false pour Spring

  static String get baseUrl {
    return useMock
        // ? 'http://192.168.1.2:3000' // JSON Server
        ? 'http://192.168.68.219:3000' // JSON Server school
        : 'http://192.168.1.5:8080/api'; // Backend Spring (exemple IP locale)
  }
}
