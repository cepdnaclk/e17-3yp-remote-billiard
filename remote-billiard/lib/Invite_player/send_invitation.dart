import 'package:google_fonts/google_fonts.dart';
import 'package:remote_billiard/Connect_with_server/Game_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../PlayerPage.dart';
import 'Invitation_button.dart';

class SendInvitation extends StatefulWidget {
  SendInvitation({
    Key key,
    this.opponentName,
    this.opponentId,
    this.Accept,
  }) : super(key: key);

  final String opponentName;

  final String Accept;

  final String opponentId;

  @override
  _SendInvitationState createState() => _SendInvitationState();
}

class _SendInvitationState extends State<SendInvitation> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    game.addListener(_onAccept);
  }

  @override
  void dispose() {
    game.removeListener(_onAccept);
    super.dispose();
  }

  _onAccept(message) {}

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
                        Navigator.pop(context);

                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (BuildContext context) => new PlayerPage(
                                opponentName: widget.opponentName,
                                opponentId: widget.opponentId,
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
