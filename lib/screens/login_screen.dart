import 'package:flutter/material.dart';
import '../constants.dart';
import 'welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();

  final String fixedUser = "admin";
  final String fixedPass = "admin";

  void login() {
    if (userController.text == fixedUser &&
        passController.text == fixedPass) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WelcomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.get(context, 'invalid'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(context, 'login')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: userController,
              decoration: InputDecoration(
                labelText: AppStrings.get(context, 'userId'),
              ),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: AppStrings.get(context, 'password'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text(AppStrings.get(context, 'login')),
            ),
          ],
        ),
      ),
    );
  }
}