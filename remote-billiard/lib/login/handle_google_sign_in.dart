import 'package:google_sign_in/google_sign_in.dart';


GoogleSignInAccount _currentUser;
GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes:[
    'profile',
    'email'
  ]
);

// set GoogleSignIn variable
void set_signIn(GoogleSignIn signIn){
  _googleSignIn = signIn;
}

// set the current user

void set_currentUser(GoogleSignInAccount user){
  _currentUser = user;
}

// disconnect current user
void disconnect_currentUser() async{
  _googleSignIn.disconnect();
}