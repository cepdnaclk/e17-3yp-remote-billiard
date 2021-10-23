import 'package:email_validator/email_validator.dart';

// ignore: non_constant_identifier_names
int validate_sign_in(String username, email, pwd1, pwd2) {
  bool validEmail = validate_email(email);
  bool validUsername = validate_username(username);
  bool validpwd = validate_password(pwd1);
  bool confirmpwd = confirmPwd(pwd1, pwd2);

  if (validEmail && validUsername && validpwd && confirmpwd) return 100;

  if (!validUsername)
    return 0;
  else if (!validEmail)
    return 1;
  else if (!validpwd)
    return 2;
  else if (!confirmpwd) return 4;
}

bool validate_username(String name) {
  if (name == null)
    return false;
  else
    return true;
}

// ignore: non_constant_identifier_names
bool validate_email(String email) {
  if (email == null)
    return false;
  else if (!EmailValidator.validate(email))
    return false;
  else if (email != null && EmailValidator.validate(email)) return true;
}

// ignore: non_constant_identifier_names
bool validate_password(String passwd) {
  if (passwd == null)
    return false;
  else if (passwd.length < 4)
    return false;
  else
    return true;
}

// ignore: non_constant_identifier_names
// ignore: missing_return
bool confirmPwd(String p1, p2) {
  if (p2 == null || p1 == null)
    return false;
  else if (p2 != p1)
    return false;
  else if (p2 == p1) return true;
}

// ignore: non_constant_identifier_names

