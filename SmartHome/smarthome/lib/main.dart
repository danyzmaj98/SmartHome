import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smarthome/classes.dart';
import 'package:smarthome/constants.dart';
import 'package:smarthome/info_page.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Home',
        home: SplashScreen(
          seconds: 7,
          navigateAfterSeconds: HomePage(),
          loadingText: Text(
            'Loading your Home...',
            style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w100),
          ),
          title: Text(
            'Smart Home',
            style: TextStyle(
                color: Colors.grey.shade200,
                fontSize: 40,
                fontWeight: FontWeight.w100),
          ),
          image: Image.asset('assets/icons/house.png'),
          photoSize: 30,
          loaderColor: Colors.grey.shade700,
          backgroundColor: defaultColor,
        ));
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection connection;

  bool isDisconnecting = false;

  bool get isConnected => connection != null && connection.isConnected;

  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

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
      connection.dispose();
      connection = null;
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Stack(alignment: Alignment.center, children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Hero(
              tag: 'info',
              child: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
            ),
          ),
          InfoPage(),
          Align(
            alignment: Alignment.centerRight,
            child: Switch(
              activeColor: Colors.white,
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) {
                future() async {
                  if (value) {
                    await FlutterBluetoothSerial.instance.requestEnable();
                  } else {
                    await FlutterBluetoothSerial.instance.requestDisable();
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
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Bluetooth',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
            ),
          )
        ]),
      ),
      backgroundColor: defaultColor,
      body: Column(children: [
        ContainerWithIcons(
          connected: _connected,
          size: size,
          onTap: () {
            if (!_connected) {
              setState(() {
                for (var i = 0; i < _devicesList.length; i++) {
                  if (_devicesList[i].name == 'HC-06') {
                    _device = _devicesList[i];
                    _connect();
                  }
                }
              });
            } else if (_connected) {
              _disconnect();
            }
          },
        ),
        SizedBox(
          height: size.height * 0.04,
        ),

//------------------------------------------------------------------------------------------- controler 1

        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: defaultColor,
            boxShadow: [
              BoxShadow(
                color: controllerAC
                    ? Colors.white.withOpacity(0.3)
                    : Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(3, 3),
              ),
            ],
          ),
          height: size.height * 0.15,
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$temperature',
                          style: TextStyle(
                              fontSize: 45,
                              color: controllerAC
                                  ? Colors.lightBlue
                                  : defaultItemsColor),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PowerButton(
                          onTap: _ac,
                          child: Icon(Icons.power_settings_new,
                              size: 50,
                              color:
                                  controllerAC ? Colors.red : powerButtonColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Air Conditioning',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 90,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: controllerAC
                                        ? Colors.grey.shade800
                                        : defaultItemsColor),
                                shape: BoxShape.circle),
                            width: 45,
                            height: 45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: TextButton(
                                  onPressed: _temp,
                                  child: Text(
                                    'Set',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: controllerAC
                                            ? Colors.yellow
                                            : defaultItemsColor),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NormalButton(
                                checkController: controllerAC,
                                onTap: () {
                                  setState(() {
                                    if (temperature < 25) temperature++;
                                  });
                                },
                                icontype: Icons.keyboard_arrow_up,
                              ),
                              Text(
                                'Temp',
                                style: TextStyle(
                                    color: controllerAC
                                        ? Colors.grey
                                        : defaultItemsColor),
                              ),
                              NormalButton(
                                checkController: controllerAC,
                                onTap: () {
                                  setState(() {
                                    if (temperature > 15) temperature--;
                                  });
                                },
                                icontype: Icons.keyboard_arrow_down,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),

//------------------------------------------------------------------------------------------- container 2
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: defaultColor,
            boxShadow: [
              BoxShadow(
                color: controllerTV
                    ? Colors.white.withOpacity(0.3)
                    : Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(3, 3),
              ),
            ],
          ),
          height: size.height * 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'TV',
                        style: TextStyle(
                            fontSize: 40,
                            color:
                                controllerTV ? Colors.blue : defaultItemsColor),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PowerButton(
                            onTap: _tv,
                            child: Icon(
                              Icons.power_settings_new,
                              size: 50,
                              color:
                                  controllerTV ? Colors.red : powerButtonColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Samsung TV',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 90,
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                NormalButton(
                                  onTap: _volUp,
                                  checkController: controllerTV,
                                  icontype: Icons.add,
                                ),
                                Text(
                                  'Vol',
                                  style: TextStyle(
                                      color: controllerTV
                                          ? Colors.grey
                                          : defaultItemsColor),
                                ),
                                NormalButton(
                                  checkController: controllerTV,
                                  icontype: Icons.remove,
                                  onTap: _volDown,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                NormalButton(
                                  onTap: _chUp,
                                  checkController: controllerTV,
                                  icontype: Icons.keyboard_arrow_up,
                                ),
                                Text(
                                  'CH',
                                  style: TextStyle(
                                      color: controllerTV
                                          ? Colors.grey
                                          : defaultItemsColor),
                                ),
                                NormalButton(
                                  onTap: _chDown,
                                  checkController: controllerTV,
                                  icontype: Icons.keyboard_arrow_down,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

//------------------------------------------------------------------------------------------- container 3

        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
          decoration: BoxDecoration(
            color: defaultColor,
            boxShadow: [
              BoxShadow(
                color: controllerLT
                    ? Colors.white.withOpacity(0.3)
                    : Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(3, 3),
              ),
            ],
          ),
          height: size.height * 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PowerButton(
                    onTap: _lt,
                    child: Icon(
                      Icons.power_settings_new,
                      size: 50,
                      color: controllerLT ? Colors.red : powerButtonColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Light',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ],
          ),
        ),
        LoadingIndicator(
            isButtonUnavailable: _isButtonUnavailable,
            connected: _connected,
            bluetoothState: _bluetoothState),
      ]),
    );
  }

  void _lt() {
    setState(() {
      if (_connected) {
        controllerLT = !controllerLT;
      }
    });
  }
  //-----------------------------fj za kodove---------------------------------------------------

  void _upaliKlimu() async {
    connection.output.add(utf8.encode("a"));
    await connection.output.allSent;
  }

  void _ugasiKlimu() async {
    connection.output.add(utf8.encode("b"));
    await connection.output.allSent;
  }

  void _ac() {
    setState(() {
      if (_connected) {
        controllerAC = !controllerAC;
        controllerAC ? _upaliKlimu() : _ugasiKlimu();
      }
    });
  }

  Future<void> _temp() async {
    int temp = temperature % 10;
    connection.output.add(utf8.encode('$temp'));
    await connection.output.allSent;
  }

  void _tv() {
    setState(() {
      if (_connected) {
        controllerTV = !controllerTV;
        controllerTV ? _tvONOFF() : _tvONOFF();
      }
    });
  }

  Future<void> _tvONOFF() async {
    connection.output.add(utf8.encode('t'));
    await connection.output.allSent;
  }

  Future<void> _chUp() async {
    connection.output.add(utf8.encode('u'));
    await connection.output.allSent;
  }

  Future<void> _chDown() async {
    connection.output.add(utf8.encode('d'));
    await connection.output.allSent;
  }

  Future<void> _volUp() async {
    connection.output.add(utf8.encode('p'));
    await connection.output.allSent;
  }

  Future<void> _volDown() async {
    connection.output.add(utf8.encode('m'));
    await connection.output.allSent;
  }

  //-----------------------------------------------------------------

  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device.address)
            .then((_connection) {
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection.input.listen(null).onDone(() {
            if (this.mounted) {
              setState(() {});
            }
          });
        });
        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
    });

    await connection.close();
    if (!connection.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }
}
