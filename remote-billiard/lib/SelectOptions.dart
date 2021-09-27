import 'package:flutter/material.dart';
import 'package:remote_billiard/FindPlayer.dart';
import './FindPlayer.dart';
import './Toss.dart';

class SelectOptions extends StatelessWidget {
  static const String id = 'SelectOptions';
  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
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
                    "Virtual Billiard Platform",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      fontFamily: "Acme",
                      letterSpacing: 5,
                      color: Colors.blue[100],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: FlatButton(
                    child: Text(
                      'Find a Player',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    color: Colors.blue[200],
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FindPlayer()));
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: FlatButton(
                    child: Text(
                      'Resume Game',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    color: Colors.blue[200],
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Toss()));
                    },
                  ),
                ),
               /* Container(
                  margin: EdgeInsets.all(25),
                  child: FlatButton(
                    child: Text(
                      'Play New Game',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    color: Colors.blue[200],
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ExitPage()));
                    },
                  ),
                )*/
              ]))),
    );
  }
}
