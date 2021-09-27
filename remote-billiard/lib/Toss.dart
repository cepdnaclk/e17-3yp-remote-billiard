import 'package:flutter/material.dart';
import './ExitPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toss extends StatelessWidget {
  static const String id = 'Toss';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.black])),
      child: Scaffold(
          // By defaut, Scaffold background is white
          // Set its value to transparent
          backgroundColor: Colors.transparent,
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                Text(
                  "Remote Billiard",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: "Raleway",
                    letterSpacing: 5,
                    color: Colors.blue[200],
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(25),
                    child: Image.asset(
                      "./assets/logo.png",
                      height: 50,
                      width: 100,
                    )),
                Container(
                  margin: EdgeInsets.all(25),
                  child: Text(
                    "Click the TOSS to play",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 5,
                      color: Colors.blue[100],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: FlatButton(
                    minWidth: 200.0,
                    height: 100.0,
                    child: Text(
                      'TOSS',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    color: Colors.blue[200],
                    textColor: Colors.black,
                    shape: CircleBorder(),
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: "You Won the TOSS",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 5,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 20.0);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: FlatButton(
                    child: Text(
                      'PLAY NOW',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    color: Colors.blue[200],
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ExitPage()));
                    },
                  ),
                )
              ]))),
    );
  }
}
