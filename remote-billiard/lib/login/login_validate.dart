
import 'package:email_validator/email_validator.dart';

// ignore: non_constant_identifier_names
// ignore: missing_return
int validate_login(String email, String password){
  if(validate_email(email) && validate_password(password) ){
    return 4;
  }
  else if (!validate_email(email) && !validate_password(password)){
    return 2;
  }
  else if (!validate_password(password)){
    return 1;
  }
  else if (!validate_email(email)){
    return 0;
  }
}

// ignore: non_constant_identifier_names
bool validate_password(String passwd){
  if(passwd == null) return false;
  else if(passwd.length <4) return false;
  else return true ;
}

// ignore: non_constant_identifier_names
bool validate_email(String email){
  if (email == null) return false;
  else if(!EmailValidator.validate(email)) return false;
  else if(email != null && EmailValidator.validate(email)) return true;

}


