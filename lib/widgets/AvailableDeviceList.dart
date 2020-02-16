import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:polthen_pahana_app/utils/routeUtil.dart';

class AvailableDeviceList extends StatefulWidget {
  final bool start;

  const AvailableDeviceList({Key key, this.start = true}) : super(key: key);

  @override
  _AvailableDeviceListState createState() => _AvailableDeviceListState();
}

class _AvailableDeviceListState extends State<AvailableDeviceList> {
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool isDiscovering;

  @override
  void initState() {
    super.initState();
    isDiscovering = widget.start;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        results.add(r);
      });
    });

    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  void _removeBondedDevices() {
    results.forEach((result) async {
      if (result.device.isBonded) {
        bool unBonded = await FlutterBluetoothSerial.instance
            .removeDeviceBondWithAddress(result.device.address);
        setState(() {
          results[results.indexOf(result)] = BluetoothDiscoveryResult(
              device: BluetoothDevice(
                name: result.device.name ?? '',
                address: result.device.address,
                type: result.device.type,
                bondState: unBonded
                    ? BluetoothBondState.none
                    : BluetoothBondState.bonded,
              ),
              rssi: result.rssi);
        });
      }
    });
  }

  void _bondDevice(BluetoothDiscoveryResult result) async {
    try {
      bool bonded = false;
      if (result.device.isBonded) {
        print('Unbonding from ${result.device.address}...');
        await FlutterBluetoothSerial.instance
            .removeDeviceBondWithAddress(result.device.address);
        print('Unbonding from ${result.device.address} has succeed');
      } else {
        print('Bonding with ${result.device.address}...');
        _removeBondedDevices();
        bonded = await FlutterBluetoothSerial.instance
            .bondDeviceAtAddress(result.device.address);
        print(
            'Bonding with ${result.device.address} has ${bonded ? 'succeed' : 'failed'}.');
      }
      BluetoothDevice tempDevice = BluetoothDevice(
        name: result.device.name ?? '',
        address: result.device.address,
        type: result.device.type,
        bondState: bonded ? BluetoothBondState.bonded : BluetoothBondState.none,
      );
      setState(() {
        results[results.indexOf(result)] =
            BluetoothDiscoveryResult(device: tempDevice, rssi: result.rssi);
      });
      if (bonded)
        Future.delayed(Duration(seconds: 1))
            .then((_) => RouteUtil.mainPage(context, tempDevice));
    } catch (ex) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Error occured while bonding'),
              content: Text("${ex.toString()}"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (BuildContext context, index) {
              BluetoothDiscoveryResult result = results[index];
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(result.device.name ?? "Unknown Device"),
                    subtitle: Text("${result.rssi.toString()} dBm"),
                    onLongPress: () => _bondDevice(result),
                    trailing:
                        result.device.bondState == BluetoothBondState.bonded
                            ? Icon(Icons.compare_arrows)
                            : null,
                  ),
                  Divider(thickness: 2),
                ],
              );
            },
          ),
        ),
      ),
      ListTile(
        title: Container(
          color: Colors.green,
          child: Row(children: <Widget>[
            Text("Available Devices"),
            (isDiscovering
                ? FittedBox(
                    child: Container(
                      margin: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.replay), onPressed: _restartDiscovery))
          ]),
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
