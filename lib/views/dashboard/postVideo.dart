// ignore_for_file: file_names

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable, camel_case_types
class postVideoWidget extends StatefulWidget {
  final String? src;

  postVideoWidget(BuildContext context, {Key? key, this.src}) : super(key: key);

  bool liked = false;
  @override
  // ignore: library_private_types_in_public_api
  _postVideoWidgetState createState() => _postVideoWidgetState();
}

// ignore: camel_case_types
class _postVideoWidgetState extends State<postVideoWidget> {
  late VideoPlayerController _videoPlayerController;

  late ChewieController _chewieController =
      ChewieController(videoPlayerController: _videoPlayerController);
  bool check = false;
  bool play = false;
  void initializePlayer() async {
    // _videoPlayerController = VideoPlayerController.network(widget.src);

    await Future.wait([_videoPlayerController.initialize()]);

    _chewieController = ChewieController(
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      showControls: false,
      looping: true,
    );
    _chewieController.addListener(() {
      if (_chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            if (_videoPlayerController.value.isPlaying) {
              _videoPlayerController.pause();
            } else {
              _videoPlayerController.play();
            }
          });
        },
        child: Container(
          width: 360,
          height: 340,
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Chewie(
                  controller: _chewieController,
                ),
              )),
        ));
  }
}
