import 'package:flutter/material.dart';
import 'package:smarthome/constants.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ContainerWithIcons extends StatefulWidget {
  const ContainerWithIcons({
    Key key,
    @required this.size,
    @required bool connected,
    this.onTap,
  })  : _connected = connected,
        super(key: key);

  final Size size;
  final _connected;
  final GestureTapCallback onTap;

  @override
  _ContainerWithIconsState createState() => _ContainerWithIconsState();
}

class _ContainerWithIconsState extends State<ContainerWithIcons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      width: widget.size.width,
      height: widget.size.height * 0.25,
      decoration: BoxDecoration(
        color: defaultColor,
        borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(widget.size.width, 100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 15), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: widget.size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [
                  0,
                  0.4,
                  0.6,
                  1
                ],
                    colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.1),
                  Colors.transparent
                ])),
            child: Hero(
              tag: 'ikonica',
              child: Icon(
                Icons.devices_outlined,
                size: 70,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10)),
            child: TextButton(
              onPressed: () {
                widget.onTap();
              },
              child: Text(
                widget._connected
                    ? 'Tap to DISCONNECT from your home'
                    : 'Tap to CONNECT to your home',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.ac_unit,
                size: 30,
                color: controllerAC ? Colors.white : appBarIconColor,
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.tv,
                size: 30,
                color: controllerTV ? Colors.white : appBarIconColor,
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.lightbulb_outline,
                size: 30,
                color: controllerLT ? Colors.white : appBarIconColor,
              )
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

class NormalButton extends StatefulWidget {
  const NormalButton({
    Key key,
    this.icontype,
    this.onTap,
    this.checkController,
  }) : super(key: key);

  final IconData icontype;
  final GestureTapCallback onTap;
  final bool checkController;

  @override
  _NormalButtonState createState() => _NormalButtonState();
}

class _NormalButtonState extends State<NormalButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
          splashColor: Colors.transparent,
          onTap: widget.checkController
              ? () {
                  setState(() {
                    widget.onTap();
                  });
                }
              : null,
          child: Icon(
            widget.icontype,
            color: widget.checkController ? Colors.white : defaultItemsColor,
            size: 40,
          )),
    );
  }
}

class PowerButton extends StatefulWidget {
  const PowerButton({
    Key key,
    this.child,
    this.onTap,
  }) : super(key: key);

  final Widget child;
  final GestureTapCallback onTap;

  @override
  _PowerButtonState createState() => _PowerButtonState();
}

class _PowerButtonState extends State<PowerButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
            onTap: () {
              Future.delayed(const Duration(milliseconds: 500), () {
                setState(() {
                  widget.onTap();
                });
              });
            },
            child: widget.child),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key key,
    @required bool isButtonUnavailable,
    @required bool connected,
    @required BluetoothState bluetoothState,
  })  : _isButtonUnavailable = isButtonUnavailable,
        _connected = connected,
        _bluetoothState = bluetoothState,
        super(key: key);

  final bool _isButtonUnavailable;
  final bool _connected;
  final BluetoothState _bluetoothState;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Visibility(
        visible: _isButtonUnavailable &&
            !_connected &&
            _bluetoothState == BluetoothState.STATE_ON,
        child: LinearProgressIndicator(
          color: Colors.white,
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }
}
