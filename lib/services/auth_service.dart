import 'dart:convert';
import 'package:eashion2/services/api_service.dart';
import 'package:eashion2/services/user_session_service.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _session = UserSessionService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {'status': false, 'message': 'Google Sign-In cancelled'};
      }

      final response = await http.post(
        ApiService.getUri('google-login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': googleUser.email,
          'name': googleUser.displayName ?? '',
          'google_id': googleUser.id,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == true) {
        final userId = data['user']['id'];
        final token = data['token'];
        await _session.saveAuth(userId: userId, token: token);
      }

      return data;
    } catch (error) {
      print('Google Sign-In Error: $error');
      return {'status': false, 'message': error.toString()};
    }
  }

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
    } else {
      print('Logout failed: ${response.body}');
      return false;
    }
  }
}

