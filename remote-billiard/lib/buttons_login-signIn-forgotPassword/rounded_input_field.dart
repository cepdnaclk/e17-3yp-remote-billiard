import 'package:remote_billiard/buttons_login-signIn-forgotPassword/text_field_container.dart';
import 'package:flutter/material.dart';


class RoudedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoudedInputField({
    Key key,
    this.hintText,
    this.icon ,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.lightBlue[900],),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}