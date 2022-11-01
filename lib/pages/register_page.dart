import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker_arc/components/login_text_field.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();

  Future signUp() async {
    try {
      if (passwordConfirmed()) {
        // create user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // add user details
        addUserDetails(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          int.parse(_ageController.text.trim()),
          _emailController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      // TODO
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
          });
    }
  }

  Future addUserDetails(
      String firstName, String lastName, int age, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': _firstNameController.text.trim(),
      'last name': _lastNameController.text.trim(),
      'age': _ageController.text.trim(),
      'email': _emailController.text.trim(),
    });
  }

  bool passwordConfirmed() {
    return (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hello There!
                Text('Hello There!',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 52,
                      color: Colors.greenAccent.shade100,
                    )),

                Text(
                  'Register below with your details!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),

                // first-name textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: LoginTextField(
                    textFieldController: _firstNameController,
                    hintText: 'First Name',
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 10),

                // last-name textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: LoginTextField(
                    textFieldController: _lastNameController,
                    hintText: 'Last Name',
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 10),

                // age textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: LoginTextField(
                    textFieldController: _ageController,
                    hintText: 'Age',
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 10),

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
                const SizedBox(height: 10),

                // comfirm password text-field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: LoginTextField(
                    textFieldController: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 25),

                // sign-up button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: (() {
                      HapticFeedback.heavyImpact();
                      signUp();
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
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

                // I'm a member! Login now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'I\'m a member!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
