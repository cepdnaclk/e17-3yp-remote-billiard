import 'dart:async'; 
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remote_billiard/SelectOptions.dart';


BluetoothConnection btConnection;

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
 
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
 
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
 
  int _deviceState;

  bool isDisconnecting = false;

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green[700],
    'offTextColor': Colors.red[700],
    'neutralTextColor': Colors.blue,
  };

  
  bool get isConnected => btConnection != null && btConnection.isConnected;

  
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();

   
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    
    enableBluetooth();

  
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
  
    if (isConnected) {
      isDisconnecting = true;
      btConnection.dispose();
      btConnection = null;
    }

    super.dispose();
  }

 
  Future<void> enableBluetooth() async {
   
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

  
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

  
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    
    if (!mounted) {
      return;
    }

    
    setState(() {
      _devicesList = devices;
    });
  }

 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[900], Colors.blue[900]])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Connect device",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              label: Text(
                "Refresh",
                style: TextStyle(
                  fontFamily: "Acme",
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 14,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              splashColor: Colors.white,
              onPressed: () async {
              
                await getPairedDevices().then((_) {
                  show('Device list refreshed');
                });
              },
            ),
          ],
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Visibility(
                visible: _isButtonUnavailable &&
                    _bluetoothState == BluetoothState.STATE_ON,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.yellow,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Enable Bluetooth',
                        style: TextStyle(
                          fontFamily: "Acme",
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Switch(
                      value: _bluetoothState.isEnabled,
                      onChanged: (bool value) {
                        future() async {
                          if (value) {
                            await FlutterBluetoothSerial.instance
                                .requestEnable();
                          } else {
                            await FlutterBluetoothSerial.instance
                                .requestDisable();
                          }

                          await getPairedDevices();
                          _isButtonUnavailable = false;

                          if (_connected) {
                            _disconnect();
                          }
                        }

                        future().then((_) {
                          setState(() {});
                        });
                      },
                    )
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Paired Devices",
                          style: TextStyle(
                            fontFamily: "Acme",
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Device:',
                              style: TextStyle(
                                fontFamily: "Acme",
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: 20,
                              ),
                            ),
                            DropdownButton(
                              items: _getDeviceItems(),
                              onChanged: (value) =>
                                  setState(() => _device = value),
                              value: _devicesList.isNotEmpty ? _device : null,
                            ),
                            ElevatedButton(
                              onPressed: _isButtonUnavailable
                                  ? null
                                  : _connected
                                      ? _disconnect
                                      : _connect,
                              child:
                                  Text(_connected ? 'Disconnect' : 'Connect'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: new BorderSide(
                              color: _deviceState == 0
                                  ? colors['neutralBorderColor']
                                  : _deviceState == 1
                                      ? colors['onBorderColor']
                                      : colors['offBorderColor'],
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          elevation: _deviceState == 0 ? 4 : 0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.amber[700],
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "NOTE: Pair the devices manually using bluetooth settings if the devices do not appear in the list.",
                          style: TextStyle(
                            fontFamily: "Acme",
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 15),
                        RaisedButton(
                          color: Colors.amberAccent[200],
                          elevation: 2,
                          child: Text(
                            'NEXT',
                            style: GoogleFonts.raleway(
                              textStyle: TextStyle(fontSize: 19.0),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                          textColor: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.amber[700],
                                  width: 3,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            // FlutterBluetoothSerial.instance.openSettings();
                            Navigator.pushNamed(context, SelectOptions.id);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text(
          'NONE',
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }


  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          print('Connected to the device');
          btConnection = _connection;
          setState(() {
            _connected = true;
          });

          btConnection.input.listen(null).onDone(() {
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
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }


  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await btConnection.close();
    show('Device disconnected');
    if (!btConnection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }


  void sendgameMessage(String message) async {
    btConnection.output.add(utf8.encode(message + "\r\n"));
    await btConnection.output.allSent;

    setState(() {
   
    });
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}