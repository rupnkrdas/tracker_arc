import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/login_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            content: Text(
              'Password reset link sent! Check your email',
              style: TextStyle(color: Colors.grey.shade200),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    } on FirebaseException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            content: Text(
              e.message.toString(),
              style: TextStyle(color: Colors.grey.shade200),
              textAlign: TextAlign.center,
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(25),
            child: Text(
              'Enter your email and we will send you a password reset link!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade200,
              ),
            ),
          ),
          // email textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: LoginTextField(
              textFieldController: _emailController,
              hintText: 'Email',
              obscureText: false,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          MaterialButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              passwordReset();
            },
            elevation: 5,
            hoverElevation: 50,
            highlightElevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 40,
            color: Colors.blueGrey.shade900,
            textColor: Colors.white,
            child: const Text('Reset Password'),
          )
        ],
      ),
    );
  }
}
