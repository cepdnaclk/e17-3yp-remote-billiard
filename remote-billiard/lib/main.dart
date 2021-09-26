import 'package:flutter/material.dart';
import './ChatPage.dart';
import './HomePage.dart';
import'./ExitPage.dart';
import'./ChoosePocket.dart';

void main() => runApp(MyMaterial());

class MyMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:HomePage.id,
      routes:{
        HomePage.id:(context)=>HomePage(),
         //ChatPage.id:(context)=>ChatPage(),
         ChoosePocket.id:(context)=>ChoosePocket(),
       ExitPage.id:(context)=>ExitPage(),

      }
     
    );
  }
}
