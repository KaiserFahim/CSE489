import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryBroadcastScreen extends StatefulWidget {
  const BatteryBroadcastScreen({super.key});

  @override
  State<BatteryBroadcastScreen> createState() => _BatteryBroadcastScreenState();
}

class _BatteryBroadcastScreenState extends State<BatteryBroadcastScreen> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      _getBatteryLevel();
    });
  }

  Future<void> _getBatteryLevel() async {
    int level = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Battery Broadcast")),
      body: Center(
        child: Text(
          "Battery Level: $_batteryLevel%",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
