import 'package:flutter/material.dart';
import 'package:remote_billiard/PlayerDataScreen.dart';
import 'package:remote_billiard/bconnectdevice.dart';
import 'package:remote_billiard/loginScreen.dart';
import 'package:remote_billiard/screens/forgotPass_screen.dart';
import 'package:remote_billiard/signInScreen.dart';
//import 'package:web_socket_channel/web_socket_channel.dart';
import './HomePage.dart';
import './SelectOptions.dart';
import './FindPlayer.dart';
import './PlayerPage.dart';
import './ChoosePocket.dart';
import './ChatPage.dart';
import './ExitPage.dart';
import './backEnd_conn/websockets.dart';

void main() => runApp(MyMaterial());

class MyMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    sockets.initCommunication(); //client socket is initialised

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: HomePage.id,
        routes: {
          HomePage.id: (context) => HomePage(),
          LoginScreen.id: (context) => LoginScreen(),
          SignInScreen.id: (context) => SignInScreen(),
          ForgotPassScreen.id: (context) => ForgotPassScreen(),
          SelectOptions.id: (context) => SelectOptions(),
          FindPlayer.id: (context) => FindPlayer(),
          PlayerDataScreen.id: (context) => PlayerDataScreen(),
          bconnectdevice.id: (context) => bconnectdevice(),
          PlayerPage.id: (context) => PlayerPage(
                streamUrl: '',
              ),
          ChoosePocket.id: (context) => ChoosePocket(),
          ChatPage.id: (context) => ChatPage(),
          ExitPage.id: (context) => ExitPage(),
        });
  }
}
