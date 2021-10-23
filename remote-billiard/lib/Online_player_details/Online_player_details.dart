import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remote_billiard/Invite_player/send_invitation.dart';
import 'package:remote_billiard/Connect_with_server/Game_connection.dart';

import '../PlayerPage.dart';

const String profile_Img = 'assets/user.jpg';

class Player {
  final String profileImg;
  final String username;

  Player({this.profileImg, this.username});
}

class PlayerDataBody extends StatefulWidget {
  @override
  _PlayerDataBodyState createState() => _PlayerDataBodyState();
}

class _PlayerDataBodyState extends State<PlayerDataBody> {
  String playerName;
  List<dynamic> playersList = <dynamic>[];

  @override
  void initState() {
    super.initState();

    game.addListener(_onServerResponse);
  }

  @override
  void dispose() {
    game.removeListener(_onServerResponse);
    super.dispose();
  }

  _onServerResponse(message) {
    switch (message["action"]) {
      case 'players_list':
        playersList = message["data"];

        setState(() {});
        break;

      case 'new_game':
        // split message data
        var data = message["data"].split(";");
        Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (BuildContext context) => new SendInvitation(
                opponentName: data[0],
                opponentId: data[1],
                Accept: data[2],
              ),
            ));
        break;
    }
  }

  // ignore: non_constant_identifier_names
  Widget personDetailCard(Player, String id, bool availability) {
    var playername = Player.username;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        splashColor: Colors.red,
        onTap: () {
          if (availability == true) {
           _onSendInvitation(Player.username, id);
          } else {
            print(availability);

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text("$playername is currently unavailable",
                        style: TextStyle(
                          color: Colors.grey[100],
                        )),
                    content: new Text(
                      "Please select another Player",
                      style: TextStyle(color: Colors.grey[100]),
                    ),
                    backgroundColor: Colors.indigo[900],
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: new Text(
                          "OK",
                          style: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  );
                });
          }
        },
        child: Card(
          color: Colors.blue[300],
          elevation: 20,
          shape: RoundedRectangleBorder(
              side: new BorderSide(color: Colors.white, width: 3.0),
              borderRadius: BorderRadius.circular(0)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(Player.profileImg)))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Player.username,
                      style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: 20,
                        fontFamily: "Acme",
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
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

 _onSendInvitation(String opponentName, String opponentId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Player Invitation",
                style: TextStyle(
                  color: Colors.grey[100],
                )),
            content: new Text(
              "Do you want to send an invitation to $opponentName ?",
              style: TextStyle(color: Colors.grey[100]),
            ),
            backgroundColor: Colors.indigo[900],
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text(
                  "NO",
                  style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 15,
                  ),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  _onPlayNewGame(opponentName, opponentId, "Yes");
                },
                child: new Text(
                  "YES",
                  style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          );
        });
  }

  _onPlayNewGame(String opponentName, String opponentId, String accept) {
    game.send('new_game', "$opponentId;$opponentName;$accept");

    Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new PlayerPage(
            opponentName: opponentName,
            character: '1',
            opponentId: opponentId,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: size.height * 0.05,
                  ),
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
                  Text(
                    "Find Players",
                    style: GoogleFonts.alikeAngular(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                        letterSpacing: 5,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                  children: playersList.map((playerInfo) {
                Player player = new Player(
                    profileImg: profile_Img, username: playerInfo["name"]);
                return personDetailCard(
                    player, playerInfo["id"], playerInfo["availability"]);
              }).toList()),
            ],
          ),
        ),
      ),
    );
  }
}
