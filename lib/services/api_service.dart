class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Uri getUri(String endpoint) {
    return Uri.parse('$baseUrl/$endpoint');
  }
}
