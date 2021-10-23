import 'package:flutter/material.dart';
import 'package:remote_billiard/Player_signin/player_signin.dart';

class SignInScreen extends StatelessWidget {
  static const String id = 'SignInScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 7, 40, 90),
      body: BodySignIn(),
    );
  }
}
