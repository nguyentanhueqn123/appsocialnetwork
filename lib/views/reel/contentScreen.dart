// ignore_for_file: file_names

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'likeDoubleTap.dart';
import 'optionScreen.dart';

// ignore: must_be_immutable
class ContentScreen extends StatefulWidget {
  final String? src;
  final String? uid;
  final String? reelId;

  ContentScreen({Key? key, this.src, this.uid, this.reelId}) : super(key: key);

  bool liked = false;
  @override
  // ignore: library_private_types_in_public_api
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController =
      ChewieController(videoPlayerController: _videoPlayerController);

  Future initializePlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.src!));
    // VideoPlayerController.network(widget.src!);
    await Future.wait([_videoPlayerController.initialize()]);

    _chewieController = ChewieController(
      allowedScreenSleep: false,
      allowFullScreen: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
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

  bool _liked = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ignore: unnecessary_null_comparison
        _chewieController != null &&
                _chewieController.videoPlayerController.value.isInitialized
            ? GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    _liked = !_liked;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 24 + 24),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                ),
              )
            : Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Loading...')
                  ],
                ),
              ),
        if (_liked)
          Center(
            child: LikeIcon(),
          ),
        OptionScreen(uid: widget.uid, reelId: widget.reelId)
      ],
    );
  }
}
