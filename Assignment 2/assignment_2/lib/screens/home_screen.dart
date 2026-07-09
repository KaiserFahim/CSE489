import 'package:flutter/material.dart';
import '../screens/broadcast_screen.dart';
import '../screens/image_scale_screen.dart';
import '../screens/video_screen.dart';
import '../screens/audio_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CSE 489 Assignment')),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('Broadcast Receiver'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BroadcastScreen(),
                ),
              ),
            ),
            ListTile(
              title: const Text('Image Scale'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImageScaleScreen(),
                ),
              ),
            ),
            ListTile(
              title: const Text('Video Player'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VideoScreen()),
              ),
            ),
            ListTile(
              title: const Text('Audio Player'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AudioScreen()),
              ),
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Select an option from the drawer.')),
    );
  }
}
