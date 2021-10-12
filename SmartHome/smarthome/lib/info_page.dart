import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smarthome/constants.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blueGrey.shade900,
                  shadowColor: Colors.white,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_new)),
                ),
                backgroundColor: defaultColor,
                body: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            'Before trying to turn on devices, tap on the text "Tap to connect to your home" firstly.',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            'If you are having problems with connection, open bluetooth settings and pair with the HC-06 device',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Hero(
                          tag: 'info',
                          child: Icon(
                            Icons.info_outline,
                            size: 150,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            FlutterBluetoothSerial.instance.openSettings();
                          },
                          child: Text(
                            'Bluetooth postavke',
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
          },
          child: Text('')),
    );
  }
}
