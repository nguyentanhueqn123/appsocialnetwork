// ignore_for_file: file_names

import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:story_view/story_view.dart';
import 'package:video_player/video_player.dart';

import '../../constants/colors.dart';
import '../../models/storyModel.dart';
import '../../models/userModel.dart';

// ignore: must_be_immutable
class ContentStoryScreen extends StatefulWidget {
  final String? src;
  final String? uid;
  final String? storyId;

  ContentStoryScreen({Key? key, this.src, this.uid, this.storyId})
      : super(key: key);

  bool liked = false;
  @override
  // ignore: library_private_types_in_public_api
  _ContentStoryScreenState createState() => _ContentStoryScreenState();
}

class _ContentStoryScreenState extends State<ContentStoryScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController =
      ChewieController(videoPlayerController: _videoPlayerController);

  late UserModel owner = UserModel(
      avatar: '',
      background: '',
      email: '',
      favoriteList: [],
      fullName: '',
      id: '',
      phoneNumber: '',
      saveList: [],
      state: '',
      userName: '',
      follow: [],
      role: '',
      gender: '',
      dob: '');
  Future getOwnerDetail() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: widget.uid)
        .snapshots()
        .listen((value) {
      setState(() {
        owner = UserModel.fromDocument(value.docs.first.data());
        // ignore: avoid_print
        print(owner.userName);
        // ignore: avoid_print
        print("owner.background");
        // ignore: avoid_print
        print(owner.background);
      });
    });
  }

  Future initializePlayer() async {
    // if (story.urlVideo == '') {
    // ignore: deprecated_member_use
    _videoPlayerController = VideoPlayerController.network(widget.src!);
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
    // }
  }

  late StoryController storyController;
  late Timer _timer;
  Future startTime() async {
    _timer = Timer.periodic(const Duration(microseconds: 10), ((timer) {
      setState(() {
        percent += 0.01;
        if (percent > 1) {
          _timer.cancel();
          Navigator.pop(context);
        }
      });
    }));
  }

  storyModel story = storyModel(
      id: '',
      idUser: '',
      urlImage: '',
      urlVideo: '',
      mode: '',
      timeCreate: '',
      state: '',
      ownerAvatar: '',
      likes: [],
      ownerUsername: '');
  Future getstoriesList() async {
    FirebaseFirestore.instance
        .collection("stories")
        .where('id', isEqualTo: widget.storyId)
        .snapshots()
        .listen((value) {
      setState(() {
        story = storyModel.fromDocument(value.docs.first.data());
        // ignore: avoid_print
        print(story.urlVideo);
      });
    });
  }

  @override
  void initState() {
    getOwnerDetail();
    getstoriesList();
    startTime();
    initializePlayer();
    storyController = StoryController();
    super.initState();
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
    storyController.dispose();

    super.dispose();
  }

  // ignore: unused_field
  final bool _liked = false;
  double percent = 0.0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ignore: unnecessary_null_comparison
        _chewieController != null &&
                _chewieController.videoPlayerController.value.isInitialized
            ? GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.only(top: 24 + 24),
                  child: Chewie(
                    controller: _chewieController,
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: percent,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: black,
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: (owner.avatar != '')
                              ? Image.network(
                                  owner.avatar,
                                )
                              : Image.network(
                                  'https://i.imgur.com/RUgPziD.jpg',
                                ))),
                  const SizedBox(width: 16),
                  Text(
                    owner.userName,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontFamily: "Urbanist",
                        fontSize: 16,
                        color: white,
                        fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child:
                        const Icon(Iconsax.back_square, size: 24, color: white),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
    //     Material(
    //   child: StoryView(
    //     controller: storyController,
    //     progressPosition: ProgressPosition.top,
    //     repeat: false,
    //     inline: false,
    //     onComplete: () {
    //       Navigator.pop(context);
    //     },
    //     onVerticalSwipeComplete: (direction) {
    //       if (direction == Direction.down) {
    //         Navigator.pop(context);
    //       }
    //     }, // To disable vertical s,
    //     storyItems: [
    //       // StoryItem.pageVideo(widget.src!, controller: storyController),
    //       StoryItem.pageImage(
    //           url: 'https://i.imgur.com/eYOEUb7.jpg',
    //           controller: storyController)
    //     ],
    //   ),
    // );
  }
}
