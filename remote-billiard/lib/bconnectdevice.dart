import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remote_billiard/Connect_with_device/Bluetooth_connection.dart';


class bconnectdevice extends StatelessWidget {
  static const String id = 'bconnectdevice';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[900], Colors.blue[900]])),
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
                  style: GoogleFonts.bowlbyOne(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      letterSpacing: 5,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(25),
                    child: Image.asset(
                      "./assets/logo.png",
                      height: 75,
                      width: 125,
                    )),
                Container(
                  margin: EdgeInsets.all(25),
                  child: Text(
                    "Experince the Excitement of live game",
                    style: GoogleFonts.alikeAngular(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                        letterSpacing: 4,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.amber[700],
                            width: 3,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.amberAccent[200],
                    child: Text(
                      'CONNECT DEVICE',
                      style: GoogleFonts.raleway(
                        textStyle: TextStyle(fontSize: 19.0),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    textColor: Colors.blue[900],
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BluetoothPage()));
                    },
                  ),
                ),
              ]))),
    );
  }
}
