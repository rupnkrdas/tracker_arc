import 'package:flutter/material.dart';
import 'package:tracker_arc/auth/auth_page.dart';
import 'package:tracker_arc/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tracker_arc/auth/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // initialize hive
  await Hive.initFlutter();
  // open a box
  await Hive.openBox("Habit_Database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      initialRoute: MainPage.routeName,
      routes: {
        MainPage.routeName: (context) => const MainPage(),
        HomePage.routeName: (context) => const HomePage(),
        AuthPage.routeName: (context) => const AuthPage(),
      },
    );
  }
}
