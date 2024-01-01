// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/storyModel.dart';

// ignore: camel_case_types, must_be_immutable
class atStoryScreen extends StatefulWidget {
  String uid;
  atStoryScreen(required, {Key? key, required this.uid}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _atStoryScreen createState() => _atStoryScreen();
}

// ignore: camel_case_types
class _atStoryScreen extends State<atStoryScreen>
    with SingleTickerProviderStateMixin {
  String userId = '';

  List<storyModel> storiesList = [];
  List videoList = [];
  List imageList = [];
  List ownerId = [];
  List storiesId = [];
  Future getstoriesList() async {
    FirebaseFirestore.instance
        .collection("stories")
        .orderBy('timeCreate', descending: true)
        .snapshots()
        .listen((value) {
      setState(() {
        storiesList.clear();
        videoList.clear();
        ownerId.clear();
        for (var element in value.docs) {
          storiesList.add(storyModel.fromDocument(element.data()));
          if (element.data()['urlVideo'] != '') {
            videoList.add(element.data()['urlVideo']);
            // ignore: avoid_print
            print("videoList");
            // ignore: avoid_print
            print(videoList);
          }
          ownerId.add(element.data()['userId']);
          storiesId.add(element.data()['id']);
        }
        // ignore: avoid_print
        print("videoList");
        // ignore: avoid_print
        print(videoList);
      });
    });
  }

  //late SwiperController swiperController;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    userId = userid!;
    // ignore: avoid_print
    print(userId);
    getstoriesList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container()
        // Swiper(
        //   itemBuilder: (BuildContext context, int index) {
        //     return ContentStoryScreen(
        //       src: videoList[index],
        //       uid: ownerId[index],
        //       storyId: storiesId[index],
        //     );
        //   },
        //   itemCount: videoList.length,
        //   scrollDirection: Axis.horizontal,
        // ),
        );
  }
}
