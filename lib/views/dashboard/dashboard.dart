import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:iconsax/iconsax.dart';

import 'package:intl/intl.dart';

///add constants
import 'package:video_player/video_player.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../models/postModel.dart';
import '../../models/userModel.dart';
import '../message/messagesCenter.dart';
import '../profile/profile.dart';
import '../story/storyScreen.dart';
import '../widget/dialogWidget.dart';
import 'comment.dart';
import 'createPost.dart';
import 'postVideo.dart';

// ignore: camel_case_types
class atDashboardScreen extends StatefulWidget {
  final String uid;
  const atDashboardScreen({Key? key, required this.uid}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _atDashboardScreen createState() => _atDashboardScreen(uid);
}

// ignore: camel_case_types
class _atDashboardScreen extends State<atDashboardScreen>
    with SingleTickerProviderStateMixin {
  String uid = '';
  _atDashboardScreen(uid);

  bool liked = false;
  bool silent = false;
  bool isVideo = false;

  File? videoFile;

  File? imageFile;

  late UserModel user = UserModel(
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
  List y = [];
  Future getUserDetail() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: uid)
        .snapshots()
        .listen((value) {
      user = UserModel.fromDocument(value.docs.first.data());
      // ignore: avoid_print
      print(user.userName);
      y = user.follow;
    });
  }

  List<PostModel> postList = [];
  List<PostModel> postListCheck = [];
  Future getPostList() async {
    FirebaseFirestore.instance
        .collection("posts")
        .orderBy('timeCreate', descending: true)
        .snapshots()
        .listen((value) {
      setState(() {
        postList.clear();
        postListCheck.clear();
        for (var element in value.docs) {
          if (element.data()["state"] == "show") {
            postListCheck.add(PostModel.fromDocument(element.data()));
          }
        }
        for (var element in postListCheck) {
          if (y.contains(element.idUser) || uid == element.idUser) {
            postList.add(element);
          }
        }
      });
    });
  }

  late VideoPlayerController _videoPlayerController;

  // ignore: unused_field
  late final ChewieController _chewieController =
      ChewieController(videoPlayerController: _videoPlayerController);
  bool check = false;
  bool play = false;

  Future<void> controlOnRefresh() async {
    setState(() {});
  }

  late DateTime timeCreate = DateTime.now();

  Future like(String postId, List likes, String ownerId) async {
    if (likes.contains(uid)) {
      FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      }).whenComplete(() {
        if (uid != ownerId) {
          FirebaseFirestore.instance.collection('notifies').add({
            'idSender': uid,
            'idReceiver': ownerId,
            'avatarSender': user.avatar,
            'mode': 'public',
            'idPost': postId,
            'content': 'liked your photo',
            'category': 'like',
            'nameSender': user.userName,
            'timeCreate': DateFormat('y MMMM d, hh:mm a').format(DateTime.now())
          }).then((value) {
            FirebaseFirestore.instance
                .collection('notifies')
                .doc(value.id)
                .update({'id': value.id});
          });
        }
      });
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    getUserDetail();
    getPostList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent),
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () {
              return getPostList();
            },
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(profileBackground),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 32, right: 16, left: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          user.userName,
                          style: const TextStyle(
                            fontFamily: 'Recoleta',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: black,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            atCreatePostScreen(required,
                                                uid: uid)),
                                  );
                                },
                                child: AnimatedContainer(
                                  alignment: Alignment.topRight,
                                  duration: const Duration(milliseconds: 300),
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.5,
                                      )),
                                  child: Container(
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                      child: const Icon(Iconsax.add,
                                          size: 16, color: black)),
                                ),
                              )),
                          const SizedBox(width: 16),
                          Container(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          messsageScreen(required, uid: uid)),
                                );
                              },
                              child: Container(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.topRight,
                                  child: const Icon(Iconsax.message,
                                      size: 24, color: black)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // SizedBox(height: 32),
                Container(
                    margin: const EdgeInsets.only(top: 88, left: 16),
                    height: 78,
                    width: 375,
                    child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(width: 16),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return Container(
                              child: (index == 0)
                                  // ignore: avoid_unnecessary_containers
                                  ? Container(
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                  width: 56,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: black,
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  8)))),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              atStoryScreen(
                                                                required,
                                                                uid: uid,
                                                              ))));
                                                },
                                                child: Container(
                                                  width: 48,
                                                  height: 48,
                                                  margin:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            user.avatar),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 45, left: 45),
                                                child: Container(
                                                    width: 16,
                                                    height: 16,
                                                    decoration: const BoxDecoration(
                                                        color: white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    16))),
                                                    child: const Icon(
                                                        Iconsax.add,
                                                        size: 14,
                                                        color: gray)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          // ignore: avoid_unnecessary_containers
                                          Container(
                                              child: const Text(
                                            'Your Story',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w500,
                                                color: black),
                                          ))
                                        ],
                                      ),
                                    )
                                  // ignore: avoid_unnecessary_containers
                                  : Container(
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                  width: 56,
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: black,
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  8)))),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  child: Image.network(
                                                    'https://i.imgur.com/Bh3CDBU.jpg',
                                                    width: 48,
                                                    height: 48,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          // ignore: avoid_unnecessary_containers
                                          Container(
                                              child: const Text(
                                            'Katty',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w500,
                                                color: black),
                                          ))
                                        ],
                                      ),
                                    ));
                        })),
                Container(
                    margin: const EdgeInsets.only(
                        top: 88 + 16 + 56 + 8 + 12,
                        left: 16,
                        right: 16,
                        bottom: 56),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: postList.length,
                        itemBuilder: (context, index) {
                          var timestamp = postList[index]
                              .timeCreate; // [DateTime] formatted as String.
                          var convertedTimestamp =
                              DateFormat('y MMMM d, hh:mm:ss').parse(
                                  timestamp); // Converting into [DateTime] object
                          var result = GetTimeAgo.parse(convertedTimestamp);
                          return Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                                color: white.withOpacity(0.87),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              children: <Widget>[
                                // ignore: avoid_unnecessary_containers
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      atProfileScreen(
                                                          ownerId:
                                                              postList[index]
                                                                  .idUser)));
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: Image.network(
                                                  postList[index].ownerAvatar,
                                                  fit: BoxFit.cover,
                                                  width: 32,
                                                  height: 32,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // ignore: avoid_unnecessary_containers
                                            Container(
                                                child: Text(
                                              postList[index].ownerUsername,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Urbanist',
                                                  fontWeight: FontWeight.w600,
                                                  color: black),
                                            ))
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          if (uid == postList[index].idUser) {
                                            if (postList[index].state ==
                                                'show') {
                                              hidePostDialog(
                                                  context, postList[index].id);
                                            } else {
                                              showPostDialog(
                                                  context, postList[index].id);
                                            }
                                          } else {
                                            savePostDialog(context,
                                                postList[index].id, uid);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          alignment: Alignment.topRight,
                                          child: const Icon(Iconsax.more,
                                              size: 24, color: black),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                (postList[index].urlImage != '')
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 280,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.network(
                                            postList[index].urlImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : postVideoWidget(context,
                                        src: postList[index].urlVideo),
                                // ignore: avoid_unnecessary_containers
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              liked = !liked;
                                              like(
                                                  postList[index].id,
                                                  postList[index].likes,
                                                  postList[index].idUser);
                                            });
                                          },
                                          icon: (postList[index]
                                                  .likes
                                                  .contains(uid))
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  alignment: Alignment.topRight,
                                                  child: const Icon(
                                                      Iconsax.like_15,
                                                      size: 24,
                                                      color: pink),
                                                )
                                              : Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  alignment: Alignment.topRight,
                                                  child: const Icon(
                                                      Iconsax.like_1,
                                                      size: 24,
                                                      color: black),
                                                )),
                                      GestureDetector(
                                        onTap: () {
                                          //likes post
                                        },
                                        child: Container(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              (postList[index].likes.isEmpty)
                                                  ? '0'
                                                  : postList[index]
                                                      .likes
                                                      .length
                                                      .toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: black,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )),
                                      ),
                                      IconButton(
                                        padding: const EdgeInsets.only(left: 8),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      atCommentScreen(
                                                        required,
                                                        uid: uid,
                                                        postId:
                                                            postList[index].id,
                                                        ownerId: postList[index]
                                                            .idUser,
                                                      ))));
                                        },
                                        // ignore: avoid_unnecessary_containers
                                        icon: Container(
                                          child: const Icon(
                                              Iconsax.message_text,
                                              size: 24,
                                              color: black),
                                        ),
                                      ),
                                      const Spacer(),
                                      (isVideo)
                                          ? IconButton(
                                              onPressed: () {
                                                //save post
                                              },
                                              icon: (silent == true)
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: const Icon(
                                                          Iconsax.volume_slash,
                                                          size: 24,
                                                          color: gray),
                                                    )
                                                  : Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: const Icon(
                                                          Iconsax.volume_high,
                                                          size: 24,
                                                          color: black),
                                                    ))
                                          : Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.transparent),
                                            )
                                    ],
                                  ),
                                ),
                                // SizedBox(height: 12),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        //likes post
                                      },
                                      child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            postList[index].caption,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: black,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w600,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            maxLines: 1,
                                          )),
                                    ),
                                    const Spacer(),
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          result,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: gray,
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }))
              ],
            ),
          ),
        ));
  }
}
