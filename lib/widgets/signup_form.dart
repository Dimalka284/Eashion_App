import 'package:eashion2/provider/auth_provider.dart';
import 'package:eashion2/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final authProvider = context.watch<AuthProvider>();

    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                lable: 'FULL NAME',
                controller: _nameController,
                isPassword: false,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'PLEASE ENTER YOUR NAME';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                lable: 'EMAIL ADDRESS',
                controller: _emailController,
                isPassword: false,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'EMAIL IS REQUIRED';
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'ENTER A VALID EMAIL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                lable: 'PASSWORD',
                controller: _passwordController,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'ENTER A PASSWORD';
                  if (value.length < 6) return 'MINIMUM 6 CHARACTERS';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                lable: 'CONFIRM PASSWORD',
                controller: _confirmPasswordController,
                isPassword: true,
                validator: (value) {
                  if (value != _passwordController.text)
                    return 'PASSWORDS DO NOT MATCH';
                  return null;
                },
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await authProvider.register(
                              _nameController.text.trim(),
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              _confirmPasswordController.text.trim(),
                            );

                            if (!context.mounted) return;

                            if (success == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Registration successful'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: authProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'CREATE ACCOUNT',
                          style: TextStyle(
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
