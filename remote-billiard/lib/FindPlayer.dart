import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'backEnd_conn/game_communication.dart';
import 'customcard.dart';

class FindPlayer extends StatefulWidget {
  static const String id = 'FindPlayer';
  @override
  _FindPlayerState createState() => _FindPlayerState();
}

class _FindPlayerState extends State<FindPlayer> {
  List allUsers = [];

  fetchdata(message) {
    print(message);
    switch (message["action"]) {
      case 'returnAllUsers':
        var jsonobj = message['data'];
        //print(jsonobj);
        setState(() {
          for (var ma in jsonobj) {
            var m = (ma["name"]);
            allUsers.add(m);
          }
          // print(allUsers);
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    game.addListener(fetchdata);
  }

  @override
  void dispose() {
    game.removeListener(fetchdata);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[900], Colors.blue[900]])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Registered Players",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white,
                letterSpacing: 5,
              ),
            ),
          ),
          /* actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],*/
        ),
        body: ListView.builder(
          itemCount: allUsers.length,
          itemBuilder: (context, index) {
            return customcard(name: allUsers[index]);
          },
        ),
      ),
    );
  }
}
