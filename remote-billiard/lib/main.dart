import 'package:flutter/material.dart';
import './ChatPage.dart';
import './HomePage.dart';
import './ExitPage.dart';
import './SelectOptions.dart';
import './FindPlayer.dart';
import './Toss.dart';

void main() => runApp(MyMaterial());

class MyMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Toss.id,
        routes: {
          HomePage.id: (context) => HomePage(),
          //ChatPage.id:(context)=>ChatPage(),
          ExitPage.id: (context) => ExitPage(),
          SelectOptions.id: (context) => SelectOptions(),
          FindPlayer.id: (context) => FindPlayer(),
          Toss.id: (context) => Toss(),
        });
  }
}
