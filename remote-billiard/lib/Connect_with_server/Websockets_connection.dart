import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketsNotifications sockets = new WebSocketsNotifications();

class WebSocketsNotifications {
  static final WebSocketsNotifications _sockets =
      new WebSocketsNotifications._internal();

  factory WebSocketsNotifications() {
    return _sockets;
  }

  WebSocketsNotifications._internal();
  WebSocketChannel _channel;

  bool _isOn = false;

  ObserverList<Function> _listeners = new ObserverList<Function>();

  initCommunication() async {
    reset();
    try {
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

  send(String message) {
    if (_channel != null) {
      if (_channel.sink != null && _isOn) {
        _channel.sink.add(message);
      }
    }
  }

  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }

  _onReceptionOfMessageFromServer(message) {
    _isOn = true;
    _listeners.forEach((Function callback) {
      callback(message);
    });
  }
}
