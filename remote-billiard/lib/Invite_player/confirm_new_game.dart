import 'package:google_fonts/google_fonts.dart';
import 'package:remote_billiard/backEnd_conn/game_communication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../PlayerPage.dart';
import 'confirm_button.dart';

class ConfirmNewGame extends StatefulWidget {
  ConfirmNewGame({
    Key key,
    this.opponentName,
    this.opponentId,
    this.willStream,
  }) : super(key: key);

  // Name of the opponent
  final String opponentName;

  // Yes or No
  final String willStream;

  // ID of the opponent
  final String opponentId;

  @override
  _ConfirmNewGameState createState() => _ConfirmNewGameState();
}

class _ConfirmNewGameState extends State<ConfirmNewGame> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]); // fix the orientation up for this game interface

    // Ask to be notified when a message from the server comes in.
    game.addListener(_onAction);
  }

  @override
  void dispose() {
    game.removeListener(_onAction);
    super.dispose();
  }

  _onAction(message) {}

  _getOpponentName() {
    return widget.opponentName;
  }

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
                  decoration: TextDecoration.none,
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
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  _getOpponentName() +
                      " Invites You To a New Game.Would you like to play ? ",
                  style: TextStyle(
                    fontFamily: "Acme",
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConfirmButton(
                      text: "REJECT",
                      press: () {
                        // if the player does not want to play pop the screen and notify the invitor
                        Navigator.pop(context);
                        game.send("exit_game", widget.opponentId);
                      },
                      color: Colors.blue[200],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ConfirmButton(
                      text: "ACCEPT",
                      press: () {
                        // remove new game confirm screen
                        Navigator.pop(context);
                        // if the player wants to play direct him to the game screen
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (BuildContext context) => new PlayerPage(
                                opponentName:
                                    widget.opponentName, // Name of the opponent
                                opponentId:
                                    widget.opponentId, // Id of the opponent
                                character: '2',
                              ),
                            ));
                      },
                      color: Colors.blue[200],
                    ),
                  ),
                ),
              ],
            )),
            SizedBox(
              height: size.height * 0.01,
            ),
          ],
        ),
      ),
    );
  }
}
