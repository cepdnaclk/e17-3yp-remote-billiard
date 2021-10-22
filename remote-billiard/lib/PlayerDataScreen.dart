
import 'package:flutter/material.dart';
import 'package:remote_billiard/details_of_players/body_playerDetails.dart';

class PlayerDataScreen extends StatelessWidget {
  static const String id = 'PlayerDataScreen';

  @override
  Widget build(BuildContext context) {
   return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[900],Colors.blue[900]])),
       child: Scaffold(
          backgroundColor: Colors.transparent,
      body: PlayerDataBody(),
    ),
   );
  }
}
