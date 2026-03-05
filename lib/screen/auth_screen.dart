import 'package:eashion2/provider/auth_provider.dart';
import 'package:eashion2/services/auth_service.dart';
import 'package:eashion2/services/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:eashion2/widgets/login_form.dart';
import 'package:eashion2/widgets/signup_form.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                final String? token = await UserSessionService()
                    .getToken(); // await here
                if (token != null) {
                  final success = await AuthService().logout(token);
                  if (success) {
                    // navigate to login or show message
                    print('Logout successful');
                  } else {
                    print('Logout failed');
                  }
                } else {
                  print('No token found');
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged out successfully")),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A237E).withOpacity(0.6),
                    Colors.white.withOpacity(0.3),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'EASHION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 8,
                    ),
                  ),
                  const TabBar(
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    unselectedLabelColor: Colors.white70,
                    tabs: [
                      Tab(text: 'LOGIN'),
                      Tab(text: 'SIGN UP'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: LoginForm(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: SignupForm(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Expanded(child: Divider(color: Colors.white70)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.white70)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            icon: const Icon(
                              Icons.login,
                            ), // You can use a Google icon if you have one
                            label: const Text(
                              'CONTINUE WITH GOOGLE',
                              style: TextStyle(
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              final authProvider = context.read<AuthProvider>();
                              if (authProvider.isLoading) return;

                              final success = await authProvider
                                  .signInWithGoogle();
                              if (success && context.mounted) {
                                QuickAlert.show(
                                  context: context,
                                  text: "Google Login Successful",
                                  type: QuickAlertType.success,
                                  autoCloseDuration: const Duration(seconds: 2),
                                );
                              } else if (!success && context.mounted) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  text: "Google login failed",
                                  autoCloseDuration: const Duration(seconds: 2),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
