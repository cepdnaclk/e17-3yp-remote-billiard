import 'package:flutter/material.dart';
import 'package:remote_billiard/login/body.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'LoginScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 90),
      body: LoginPage(),
    );
  }
}
