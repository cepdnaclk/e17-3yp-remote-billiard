import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:remote_billiard/backEnd_conn/game_communication.dart';

class ChatPage extends StatefulWidget {
   static const String id='ChatPage';
    ChatPage({
    Key key,
     this.opponentName,
      this.opponentId,

  }) : super(key: key);
final String opponentName;
final String opponentId;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  SocketIO socketIO;
  List<String> messages=[];
  double height, width;
  TextEditingController textController;
  ScrollController scrollController;

  @override
  void initState() {

   
    //Initializing the TextEditingController and ScrollController
   
    //Creating the socket
       game.addListener(_receivemessage);
        textController = TextEditingController();
    scrollController = ScrollController();
    //Connect to the socket
    //socketIO.connect();
    super.initState();
  }
  _receivemessage(message) {
    print(message);
    switch (message["action"]) {
   
    case 'receiveChat':

      // ignore: deprecated_member_use
   // messages = List<String>();
     var data = message["data"];
    // var chat=data["message"];
     this.setState(() => messages.add("$data;2"));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    /*textController = TextEditingController();
    scrollController = ScrollController();*/
        // split message data
       
        break;
    }
  }

  Widget buildSingleMessage(int index) {
   var chat= messages[index].split(";");
    String number=chat[1];
    return Container(
     alignment: (number == "1")
          ?Alignment.centerRight
          :Alignment.centerLeft , 
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(bottom: 20.0, left: 20.0,right:20),
        decoration: BoxDecoration(
          color: Colors.blue[900],
          borderRadius: BorderRadius.circular(20.0),
        ),
        
        child: Text(
        
           chat[0] ?? "",
          style: TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    );
  }

  Widget buildMessageList() {
    return Container(
      height: height * 0.8,
      width: width,
      child: ListView.builder(
        controller: scrollController,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return buildSingleMessage(index);
        },
      ),
    );
  }

  Widget buildChatInput() {
    return Container(
      width: width * 0.7,
      padding: const EdgeInsets.all(2.0),
      margin: const EdgeInsets.only(left: 40.0),
      child: TextField(
        decoration: InputDecoration.collapsed(
          hintText: 'Send a message...',
        ),
        controller: textController,
      ),
    );
  }

  Widget buildSendButton() {
    return FloatingActionButton(
      backgroundColor: Colors.blue[900],
      onPressed: () {
        //Check if the textfield has text or not
        if (textController.text.isNotEmpty) {
          //Send the message as JSON data to send_message event
           game.send('chatmessage', textController.text);
          //Add the message to the list
         var sendtext=textController.text;
          //Add the message to the list
          this.setState(() => messages.add("$sendtext;1"));
          textController.text = '';
          //Scrolldown the list to show the latest message
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 600),
            curve: Curves.ease,
          );
        }
      },
      child: Icon(
        Icons.send,
        size: 30,
      ),
    );
  }

  Widget buildInputArea() {
    return Container(
      height: height * 0.1,
      width: width,
      child: Row(
        children: <Widget>[
          buildChatInput(),
          buildSendButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
          title: Text(widget.opponentName ?? ""),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: height * 0.1),
            buildMessageList(),
            buildInputArea(),
          ],
        ),
      ),
    );
  }
}
