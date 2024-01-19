import 'package:flutter/material.dart';

import 'auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController loginController;
  late TextEditingController passwordController;
  bool obscurePassword = true;

  @override
  void initState() {
    loginController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Авторизация', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: loginController,
              onChanged: (value) => setState(() {}),
              decoration: const InputDecoration(
                  hintText: 'Логин'
              ).applyDefaults(_inputDecoration),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              onChanged: (value) => setState(() {}),
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Пароль',
                suffixIcon: IconButton(
                  onPressed: () => setState(() {
                    obscurePassword = !obscurePassword;
                  }),
                  icon: Icon(obscurePassword
                      ? Icons.visibility_rounded
                      : Icons.visibility_off),
                ),
              ).applyDefaults(_inputDecoration),
            ),
            const SizedBox(height: 8),
            AuthButton(
              login: loginController.text,
              password: passwordController.text,
            )
          ],
        ),
      ),
    );
  }
}

final _inputDecoration = InputDecorationTheme(
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white, width: 2.0),
      borderRadius: BorderRadius.circular(16)),
);