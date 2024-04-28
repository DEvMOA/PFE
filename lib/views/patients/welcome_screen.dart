import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/image-removebg-preview.png',
        color: Colors.green,
        height: 400,
        width: 400,
      ),
    );
  }
}
