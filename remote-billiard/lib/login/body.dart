import 'package:google_fonts/google_fonts.dart';
import 'package:remote_billiard/HomePage.dart';
import 'package:remote_billiard/SelectOptions.dart';
import 'package:remote_billiard/backEnd_conn/game_communication.dart';
import 'package:remote_billiard/bconnectdevice.dart';
import 'package:remote_billiard/buttons_login-signIn-forgotPassword/rounded_button.dart';
import 'package:remote_billiard/buttons_login-signIn-forgotPassword/rounded_input_field.dart';
import 'package:remote_billiard/buttons_login-signIn-forgotPassword/rounded_password_field.dart';
import 'package:remote_billiard/login/already_have_an_account_check.dart';
import 'package:remote_billiard/screens/forgotPass_screen.dart';
import 'package:remote_billiard/loginScreen.dart';
import 'package:remote_billiard/signInScreen.dart';
import 'package:flutter/material.dart';
import 'package:remote_billiard/backEnd_conn/websockets.dart';
import 'handle_google_sign_in.dart';
import 'login_validate.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List topics = [
    "Invalid email",
    "Invalid password",
    "Invalid email & password"
  ];
  List msgs = [
    "Enter a valid email",
    "Enter a valid password",
    "Enter valid email & password"
  ];
  static int isValid;
  static String _userName;
  static String _password;
  String playerName;
  List<dynamic> playersList = <dynamic>[];
  bool userCorrect;
  String userError = "";
  List<String> dataMsgLogin = <String>[];
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();

    game.addListener(_onGameDataReceived);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    game.removeListener(_onGameDataReceived);
    super.dispose();
  }

  _onGameDataReceived(message) {
    switch (message["action"]) {
      case 'userValidity':
        userCorrect = message["data"];
        if (userCorrect == false) {
          setState(() {
            userError = 'Username or Password is incorrect!!';
          });
        }
        break;
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Are you sure?',
              style: TextStyle(color: Colors.grey[100]),
            ),
            content: new Text(
              'Do you want to log out?',
              style: TextStyle(color: Colors.grey[100]),
            ),
            backgroundColor: Colors.indigo[900],
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "NO",
                  style: TextStyle(color: Colors.grey[100]),
                ),
              ),
              SizedBox(height: 16),
              new FlatButton(
                onPressed: () async {
                  if (_currentUser != null) {
                    _googleSignIn.disconnect();
                    Navigator.of(context).pop(true);

                    game.send('LOGOUT', "");
                    Navigator.pushNamed(context, LoginScreen.id);
                  } else {
                    Navigator.of(context).pop(true);

                    game.send('LOGOUT', "");

                    Navigator.pushNamed(context, HomePage.id);
                  }
                },
                child: Text(
                  "YES",
                  style: TextStyle(color: Colors.grey[100]),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser != null) {
      set_signIn(_googleSignIn);
      set_currentUser(_currentUser);
      return getPassword(context);
    } else {
      return getUser(context);
    }
  }

  Widget getUser(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.grey[900], Colors.blue[900]])),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                    child: Image.asset(
                  "assets/logo.png",
                  height: 75,
                  width: 125,
                )),
                Text(
                  "Remote Billiard",
                  style: GoogleFonts.bowlbyOneSc(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 5,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Text(
                    "Login",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    child: sockets.socketStatus()
                        ? null
                        : Text(
                            "Server not connected",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: Colors.red),
                          )),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  alignment: Alignment.center,
                  child: Text(
                    userError,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      fontFamily: "Acme",
                      letterSpacing: 5,
                      color: Colors.red,
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  child: TextField(
                    style: TextStyle(color: Colors.indigo[900]),
                    obscureText: false,
                    onChanged: (value) {
                      _userName = value;
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.blue[200],
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue[200], width: 2.0),
                            borderRadius: BorderRadius.circular(22.0))),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Container(
                  width: 300,
                  child: TextField(
                      style: TextStyle(color: Colors.indigo[900]),
                      obscureText: true,
                      onChanged: (value) {
                        _password = value;
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.blue[200],
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          hintText: "password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ))),
                ),

                SizedBox(
                  height: size.height * 0.03,
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 110),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.amber[700],
                          width: 3,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.amberAccent[200],
                  child: Text(
                    'LOGIN',
                    style: GoogleFonts.raleway(
                      textStyle: TextStyle(fontSize: 17.0),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  textColor: Colors.blue[900],
                  onPressed: sockets.socketStatus()
                      // ignore: sdk_version_set_literal
                      ? () => {
                            isValid = validate_login(_userName, _password),
                            if (isValid == 4)
                              {
                                dataMsgLogin = [_userName, _password],
                                game.send('LOGIN', dataMsgLogin.join(':')),
                              }
                            else
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: new Text(
                                          topics[isValid],
                                          style: TextStyle(
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                        content: new Text(
                                          msgs[isValid],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.indigo[900],
                                        actions: <Widget>[
                                          new FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: new Text(
                                                "ok",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ))
                                        ],
                                      );
                                    }),
                              },
                            game.send('LOGIN', _userName),
                            Navigator.pushNamed(context, bconnectdevice.id)
                          }
                      : null,
                ),
                Text(
                  'Or login with',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.blue[100],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width - 270,
                      child: InkWell(
                        onTap: () async {
                          try {
                            _googleSignIn.signIn();
                          } catch (error) {
                            print(error);
                          }
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            child: Wrap(
                              children: [
                                Image.asset(
                                  "assets/google.png",
                                  height: 40,
                                  width: 40,
                                ),

                                /*Text(
                  "Googe Login",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),*/
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width - 270,
                      child: InkWell(
                        onTap: () async {
                          try {
                            _googleSignIn.signIn();
                          } catch (error) {
                            print(error);
                          }
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            child: Wrap(
                              direction: Axis
                                  .horizontal, // main axis (rows or columns)
                              children: [
                                Image.asset(
                                  "assets/facebook.png",
                                  height: 40,
                                  width: 40,
                                ),
                                // SizedBox(width: 3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ForgotPassScreen.id);
                      },
                      child: Text(
                        'Forgot Password ? ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.blue[100],
                          //decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.pushNamed(context, SignInScreen.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getPassword(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/logo.png",
                  height: size.height * 0.2,
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  "LOGIN AS",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: "Acme",
                      letterSpacing: 3),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Text(
                  _currentUser.displayName,
                  style: TextStyle(
                      color: Colors.blue[200],
                      fontSize: 25,
                      fontFamily: "Acme"),
                ),
                Text(
                  _currentUser.email,
                  style: TextStyle(
                      color: Colors.blue[100],
                      fontSize: 20,
                      fontFamily: "Acme"),
                ),
                Text(
                  userError,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: "Acme",
                    letterSpacing: 5,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                RoundedPasswordField(
                  onChanged: (value) {
                    _password = value;
                  },
                  text: "Password",
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                RoundedButton(
                  text: "LOGIN",
                  press: sockets.socketStatus()
                      ? () => {
                            isValid =
                                validate_login(_currentUser.email, _password),
                            if (isValid == 4)
                              {
                                dataMsgLogin = [_currentUser.email, _password],
                                game.send('LOGIN', dataMsgLogin.join(':')),
                              }
                            else
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: new Text(
                                          topics[isValid],
                                          style: TextStyle(
                                            color: Colors.grey[100],
                                          ),
                                        ),
                                        content: new Text(
                                          msgs[isValid],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.indigo[900],
                                        actions: <Widget>[
                                          new FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: new Text(
                                                "ok",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ))
                                        ],
                                      );
                                    }),
                              }
                          }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
