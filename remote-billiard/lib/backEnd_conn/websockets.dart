import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

// Application-level global variable to access the WebSockets
WebSocketsNotifications sockets = new WebSocketsNotifications();
// The WebSocket "open" channel
//WebSocketChannel _channel;
// substitute your server's IP and port
const YOUR_SERVER_IP = 'localhost';
const YOUR_SERVER_PORT = '3000';
const String _SERVER_ADDRESS = 'ws://$YOUR_SERVER_IP:$YOUR_SERVER_PORT';

class WebSocketsNotifications {
  static final WebSocketsNotifications _sockets =
      new WebSocketsNotifications._internal();

  factory WebSocketsNotifications() {
    return _sockets;
  }

  WebSocketsNotifications._internal();
  WebSocketChannel _channel;

  // Is the connection established?
  bool _isOn = false;

  // Listeners
  // List of methods to be called when a new message comes in.
  ObserverList<Function> _listeners = new ObserverList<Function>();

  // ----------------------------------------------------------
  // Initialization the WebSockets connection with the server
  // ----------------------------------------------------------
  initCommunication() async {
    //Just in case, close any previous communication
    reset();
    try {
      // Open a new WebSocket communication
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:3000'),
        
        //Uri.parse('ws://54.90.101.77:3000'),
      );
      _channel.stream.listen(_onReceptionOfMessageFromServer);
    } catch (e) {}
    /*
    StreamBuilder(
      stream: _channel.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var jsondata = snapshot.data();
          return Text('${snapshot.data}');
        }
        print(jsondata);
        return null;
      },
    );*/
    // _channel.sink.add('Connection initialised!');
  }

  // -----------------------------------
  // Closes the WebSocket communication
  // -----------------------------------
  reset() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
        _isOn = false;
      }
    }
  }

  socketStatus() {
    return _isOn;
  }

  // -----------------------------
  // Sends a message to the server
  // -----------------------------
  send(String message) {
    if (_channel != null) {
      if (_channel.sink != null && _isOn) {
        _channel.sink.add(message);
      }
    }
  }
  //}

  // --------------------------------------------------------------
  // Adds a callback to be invoked in case of incoming notification
  // --------------------------------------------------------------
  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }

  // -----------------------------------------------------------------------------------
  // Callback which is invoked each time that we are receiving a message from the server
  // -----------------------------------------------------------------------------------
  _onReceptionOfMessageFromServer(message) {
    _isOn = true;
    _listeners.forEach((Function callback) {
      callback(message);
    });
  }

  /*receivemsg() {
    var jsonobj;
    _channel.stream.listen((data) {
      Map message = json.decode(data);
      jsonobj = (message['users']);

     _listeners.forEach((Function callback){
          callback(message);
        });
     // print(jsonobj);
      /*
      message.forEach((key, value) {
        print('Key: $key');
        print('Value: $value');
        print('------------------------------');
      });*/
    });
    //return (message['users']);
    return jsonobj;
  }*/
}
