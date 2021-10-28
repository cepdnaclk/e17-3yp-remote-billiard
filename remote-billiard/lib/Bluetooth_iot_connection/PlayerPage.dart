import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

String pop = "";

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({required this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = messages.map((_message) {
      //pop = _message.text;

      Container(
        alignment: Alignment.center,
        child: Text(
          (text) {
            //Sprint(text);
            pop = text;
            //_onFoul(text);
            return text;
          }(_message.text.trim()),
        ),
      );

      /* return Container(
        // ignore: deprecated_member_use
      
          _onFoul(_message.text);
      );*/

/*return Row(
        children: <Widget>[
          Container(
            child: Text(
              (text) {
                //Sprint(text);
                pop = text;

                return text;
              }(_message.text.trim()),
            ),
          ),
        ],
      );*/
    }).toString();
    final serverName = widget.server.name ?? "Unknown";
    //return Scaffold(body: (Text(pop)));
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Colors.blue])),
      child: Scaffold(

          // By defaut, Scaffold background is white
          // Set its value to transparent
          backgroundColor: Colors.transparent,
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                Container(
                  child: FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Center(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                          ),
                        );
                      } else {
                        return Center(
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 40),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(0)),
                            color: Colors.red,
                            child: Text(
                              pop,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 2,
                                color: Colors.blue[100],
                              ),
                            ),
                            textColor: Colors.blue,
                            onPressed: () {
                              //game.send("CallForFoul",widget.opponentId);
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow), onPressed: () {},
                      //_controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                ),
                /* Expanded(
              flex: 3,
              child: YoYoPlayer(
                aspectRatio: 16 / 9,
                url: widget.streamUrl ?? "",
                videoStyle: VideoStyle(),
                videoLoadingStyle: VideoLoadingStyle(),
              ),
            ),*/
                Container(
                  child: Text(
                    "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      fontFamily: "Open sans",
                      letterSpacing: 5,
                      color: Colors.blue[100],
                    ),
                  ),
                ),
                Container(
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.amber,
                            width: 3,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.amberAccent[200],
                    child: Text(
                      'CALL FOR FOUL',
                    ),
                    textColor: Colors.blue[900],
                    onPressed: () {
                      //game.send("CallForFoul",widget.opponentId);
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Material(
                          //Wrap with Material
                          shape: CircleBorder(
                            side: BorderSide(
                                color: Colors.amber,
                                width: 3,
                                style: BorderStyle.solid),
                          ),
                          child: MaterialButton(
                            onPressed: () {},
                            color: Colors.amberAccent[200],
                            textColor: Colors.blue[900],
                            child: Text('CHOOSE\nPOCKET'),
                            padding: EdgeInsets.all(25),
                            shape: CircleBorder(),
                          ),
                        ),
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.amberAccent,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.chat_outlined),
                            iconSize: 70,
                            color: Colors.blue[900],
                            onPressed: () {},
                          ),
                        ),
                      ],
                    )),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: FlatButton(
                        minWidth: 190.0,
                        height: 90.0,
                        child: Text(
                          'TOSS',
                          style: TextStyle(fontSize: 17.0),
                        ),
                        color: Colors.amberAccent[200],
                        textColor: Colors.blue[900],
                        shape: CircleBorder(
                          side: BorderSide(
                              color: Colors.amber,
                              width: 3,
                              style: BorderStyle.solid),
                        ),
                        onPressed: () {
                          //game.send('toss',widget.opponentId);
                        },
                      ),
                    )
                  ],
                )),
              ]))),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

  _onFoul(String chat) {
    // First ask the favor to the accept the game
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("Call For Foul",
                  style: TextStyle(
                    color: Colors.grey[100],
                  )),
              content: new Text(
                chat,
                style: TextStyle(color: Colors.grey[100]),
              ),
              backgroundColor: Colors.indigo[900]);
        });
  }
}
