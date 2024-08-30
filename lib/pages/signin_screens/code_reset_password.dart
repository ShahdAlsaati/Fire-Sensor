import 'package:flutter/material.dart';
import 'package:googlemap/constants/theme_and_color/color.dart';

class CodeResetPassword extends StatelessWidget {
  const CodeResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,

      body: Center(
        child: Text(
          "Reset password",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
