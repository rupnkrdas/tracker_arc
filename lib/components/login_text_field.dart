import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class LoginTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;

  const LoginTextField({
    Key? key,
    required TextEditingController textFieldController,
    required this.hintText,
    required this.obscureText,
  })  : _emailController = textFieldController,
        super(key: key);

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      // decoration: BoxDecoration(
      //   color: Colors.grey.shade200,
      //   border: Border.all(
      //     color: Colors.white,
      //   ),
      //   borderRadius: BorderRadius.circular(12),
      // ),
      width: double.infinity,
      height: 50,
      borderRadius: 10,
      blur: 10,
      alignment: Alignment.bottomCenter,
      border: 0.05,
      linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFffffff).withOpacity(0.1),
            const Color(0xFFFFFFFF).withOpacity(0.05),
          ],
          stops: const [
            0.1,
            1,
          ]),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFffffff).withOpacity(0.5),
          const Color((0xFFFFFFFF)).withOpacity(0.5),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: TextField(
          obscureText: obscureText,
          style: TextStyle(color: Colors.grey.shade200),
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
