import 'package:eashion2/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AuthProvider with ChangeNotifier {
  //Without isLoading if the User click the login btn 10times the api is called 10times(Bad UX)
  bool isLoading = false;
  String? token;

  //Login
  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService().login(email, password);
      isLoading = false;
      notifyListeners();

      if (response['status'] == true) {
        token = response['token'];
        print('Login Successful! Token: $token');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  //Register
  Future<bool> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await AuthService().register(
        name,
        email,
        password,
        passwordConfirmation,
      );
      isLoading = false;
      notifyListeners();

      if (response['status'] == true) {
        token = response['token']; // Save token after successful registration
        print('Registration Successful! Token: $token');
        return true;
      } else {
        print('Registration failed: ${response['message']}');
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

}
