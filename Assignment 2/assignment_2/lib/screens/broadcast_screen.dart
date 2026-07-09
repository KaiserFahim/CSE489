import 'package:flutter/material.dart';
import 'custom_broadcast_screen.dart';
import 'battery_broadcast_screen.dart';

class BroadcastScreen extends StatefulWidget {
  const BroadcastScreen({super.key});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  String _selectedOption = "Custom Broadcast Receiver";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Broadcast Receiver')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select a Broadcast Type:",
              style: TextStyle(fontSize: 18),
            ),
            DropdownButton<String>(
              value: _selectedOption,
              items:
                  [
                    "Custom Broadcast Receiver",
                    "System Battery Notification Receiver",
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedOption = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedOption == "Custom Broadcast Receiver") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomBroadcastScreen(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BatteryBroadcastScreen(),
                    ),
                  );
                }
              },
              child: const Text("Proceed"),
            ),
          ],
        ),
      ),
    );
  }
}
