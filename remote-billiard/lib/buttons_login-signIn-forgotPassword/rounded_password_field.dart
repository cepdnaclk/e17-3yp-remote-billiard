import 'package:remote_billiard/buttons_login-signIn-forgotPassword/text_field_container.dart';
import 'package:flutter/material.dart';


class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String text;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: text,
          icon: Icon(Icons.lock,
            color: Colors.lightBlue[900],
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Colors.lightBlue[900],
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}