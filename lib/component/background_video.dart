import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BackgroundVideo extends StatefulWidget {
  final String videoPath;
  final BoxFit fit;
  final double playbackSpeed; // Playback speed parameter with default value

  const BackgroundVideo({
    Key? key,
    required this.videoPath,
    this.fit = BoxFit.cover,
    this.playbackSpeed = 1.0, // Default playback speed is normal (1x)
  }) : super(key: key);

  @override
  _BackgroundVideoState createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.asset(widget.videoPath);
    _controller.setVolume(1.0);
    _controller.setLooping(true);

    // Check if playbackSpeed is provided before setting it
    if (widget.playbackSpeed != null) {
      _controller.setPlaybackSpeed(widget.playbackSpeed);
    }

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the video starts playing when initialized
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox.expand(
            child: FittedBox(
              fit: widget.fit,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
