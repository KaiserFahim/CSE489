import 'package:flutter/material.dart';

class CustomBroadcastScreen extends StatefulWidget {
  const CustomBroadcastScreen({super.key});

  @override
  State<CustomBroadcastScreen> createState() => _CustomBroadcastScreenState();
}

class _CustomBroadcastScreenState extends State<CustomBroadcastScreen> {
  final TextEditingController _textController = TextEditingController();

  void _sendBroadcast() {
    final message = _textController.text;
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Broadcast Sent: $message')));
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom Broadcast")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter a message for the broadcast:",
              style: TextStyle(fontSize: 18),
            ),
            TextField(controller: _textController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendBroadcast,
              child: const Text("Send Broadcast"),
            ),
          ],
        ),
      ),
    );
  }
}
