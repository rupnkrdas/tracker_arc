import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:tracker_arc/components/login_text_field.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  static String routeName = 'login_page';

  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Returns true if email address is in use.
  Future<bool> checkIfEmailInUse(String emailAddress) async {
    try {
      // Fetch sign-in methods for the email address
      final list =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);

      // In case list is not empty
      if (list.isNotEmpty) {
        // Return true because there is an existing
        // user using the email address
        return true;
      } else {
        // Return false because email adress is not in use
        return false;
      }
    } catch (error) {
      // Handle error
      // ...
      return true;
    }
  }

  Future signIn() async {
    HapticFeedback.heavyImpact();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              backgroundColor: Colors.grey[800],
              content: Text(
                // 'This email is not yet registered, Kindly Register first!',
                e.message.toString(),
                style: TextStyle(color: Colors.grey.shade200),
                textAlign: TextAlign.center,
              ),
            );
          }));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          BottomAppBar(
            color: Colors.transparent,
            elevation: 10,
            child: GlowText(
              '21DAYS.INC',
              blurRadius: 10,
              glowColor: Colors.blueGrey,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    ' Tracker Arc',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 60,
                      color: Colors.greenAccent,
                    ),
                  ),

                  Text(
                    'Welcome back, you\'ve been missed!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
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
                  const SizedBox(height: 10),

                  // password text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: LoginTextField(
                      textFieldController: _passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return ForgotPasswordPage();
                            })));
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign-in button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signIn,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          // color: Colors.blueGrey.shade900,
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade200,
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: widget.showRegisterPage,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
