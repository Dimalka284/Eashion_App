import 'dart:convert';
import 'package:eashion2/services/api_service.dart';
import 'package:eashion2/services/user_session_service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final _session = UserSessionService();
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      ApiService.getUri('login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      // Save token and user id
      final userId = data['user']['id'];
      final token = data['token'];
      await _session.saveAuth(userId: userId, token: token);
    }

    return data;
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final response = await http.post(
      ApiService.getUri('register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == true) {
      // Save token and user id
      final userId = data['user']['id'];
      final token = data['token'];
      await _session.saveAuth(userId: userId, token: token);
    }

    return data;
  }

  //Logout
  Future<bool> logout(String token) async {
    final _session = UserSessionService();
    final response = await http.post(
      ApiService.getUri('logout'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      // Remove token and user id
      await _session.clearAuth();
      return true;
    }else{
      print('Logout failed: ${response.body}');
      return false;
    }
    
  }
}
