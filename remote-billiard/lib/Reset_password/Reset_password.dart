import 'package:google_fonts/google_fonts.dart';
import 'package:remote_billiard/LoginPage.dart';
import 'package:flutter/material.dart';



class BodyForgotPass extends StatelessWidget {
  const BodyForgotPass({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[900], Colors.blue[900]])),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  child: Image.asset(
                "assets/logo.png",
                height: 75,
                width: 125,
              )),
              Text(
                "Remote Billiard",
                style: GoogleFonts.bowlbyOne(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 5,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Container(
                margin: EdgeInsets.only(left: 40),
                alignment: Alignment.topLeft,
                child: Text(
                  "Reset Password",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                width: 300,
                child: TextField(
                  style: TextStyle(color: Colors.indigo[900]),
                  obscureText: false,
                  onChanged: (value) {},
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
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        fillColor: Colors.blue[200],
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        hintText: "New Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ))),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Container(
                width: 300,
                child: TextField(
                    style: TextStyle(color: Colors.indigo[900]),
                    obscureText: true,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        fillColor: Colors.blue[200],
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        hintText: "Confirm New Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ))),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
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
                  'RESET',
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(fontSize: 17.0),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
                textColor: Colors.blue[900],
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
