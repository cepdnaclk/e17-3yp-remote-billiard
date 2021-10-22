import 'package:remote_billiard/forgot_password/body_forgotPass.dart';
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
