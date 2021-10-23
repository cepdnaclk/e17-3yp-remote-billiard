import 'package:google_sign_in/google_sign_in.dart';


GoogleSignInAccount _currentUser;
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes:[
    'profile',
    'email'
  ]
);


void set_signIn(GoogleSignIn signIn){
  _googleSignIn = signIn;
}


void set_currentUser(GoogleSignInAccount user){
  _currentUser = user;
}


void disconnect_currentUser() async{
  _googleSignIn.disconnect();
}