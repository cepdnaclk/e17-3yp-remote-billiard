import 'package:flutter/material.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccountCheck({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Text(
          login ? "Don't have an Account ? ": "Already have an Account ? ",
          style: TextStyle(color: Colors.lightBlue,fontSize: 15),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Sign Up": "Sign In",
            style: TextStyle(color: Colors.blue[100], fontWeight: FontWeight.bold,decoration: TextDecoration.underline,fontSize: 16,),
          ),
        ),
      ],
    );
  }
}