import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController videoPlayerController;
ChewieController chewieController;
bool isInitialized;

class VideoPlayer extends StatefulWidget {
  final String url;

  const VideoPlayer({Key key, @required this.url}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();

  void play() {
    if (isInitialized) {
      chewieController.enterFullScreen();
      chewieController.play();
    } else {
      videoPlayerController.initialize().whenComplete(() {
        isInitialized = true;
        play();
      });
    }
  }
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  void initState() {
    videoPlayerController = VideoPlayerController.network(widget.url);

    chewieController = ChewieController(
      allowedScreenSleep: false,
      videoPlayerController: videoPlayerController,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
      ],
    );

    chewieController.addListener(() {
      if (!chewieController.isFullScreen) chewieController.pause();
    });

    isInitialized = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(controller: chewieController);
  }
}
