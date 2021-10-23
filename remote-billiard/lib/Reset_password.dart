import 'package:remote_billiard/Reset_password/Reset_password.dart';
import 'package:flutter/material.dart';

class ForgotPassScreen extends StatelessWidget {
  static const String id = 'ForgotPassScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 90),
      body: BodyForgotPass(),
    );
  }
}
