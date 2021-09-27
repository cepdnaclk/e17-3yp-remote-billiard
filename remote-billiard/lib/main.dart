import 'package:flutter/material.dart';
import './HomePage.dart';
import './SelectOptions.dart';
import './FindPlayer.dart';
import './Toss.dart';
import './PlayerPage.dart';
import './ChoosePocket.dart';
import './ChatPage.dart';
import './ExitPage.dart';
void main() => runApp(MyMaterial());

class MyMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: HomePage.id,
        routes: {
          HomePage.id: (context) => HomePage(),
          SelectOptions.id: (context) => SelectOptions(),
          FindPlayer.id: (context) => FindPlayer(),
          Toss.id:(context)=>Toss(),
          PlayerPage.id:(context)=>PlayerPage(),
          ChoosePocket.id:(context)=>ChoosePocket(),
          ChatPage.id:(context)=>ChatPage(),
          ExitPage.id: (context) => ExitPage(),
          
        });
  }
}
