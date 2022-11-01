import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_arc/pages/home_page.dart';

import 'auth_page.dart';

class MainPage extends StatelessWidget {
  static String routeName = 'main_page';

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
