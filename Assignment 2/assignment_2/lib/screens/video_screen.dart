import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(
              "https://raw.githubusercontent.com/KaiserFahim/Kaiser-Portfolio-Database/main/assets/videos/cover.mp4",
            ),
          )
          ..initialize().then((_) {
            if (!mounted) return;
            setState(() {});
          });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    _controller.value.isPlaying ? _controller.pause() : _controller.play();
  }

  void _seekForward() {
    final nextPosition =
        _controller.value.position + const Duration(seconds: 10);
    final duration = _controller.value.duration;

    _controller.seekTo(nextPosition > duration ? duration : nextPosition);
  }

  void _seekBackward() {
    final nextPosition =
        _controller.value.position - const Duration(seconds: 10);

    _controller.seekTo(nextPosition.isNegative ? Duration.zero : nextPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Player")),
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.space) {
              _togglePlayPause();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              _seekForward();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              _seekBackward();
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay_10),
                  onPressed: _seekBackward,
                ),
                ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    return IconButton(
                      icon: Icon(
                        value.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: _togglePlayPause,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.forward_10),
                  onPressed: _seekForward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
