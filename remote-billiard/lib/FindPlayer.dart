import 'package:flutter/material.dart';

class FindPlayer extends StatelessWidget {
  static const String id = 'FindPlayer';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.black])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Find Players",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: "Raleway",
              letterSpacing: 5,
              color: Colors.white70,
            ),
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        ),
      ),
    );
  }
}
