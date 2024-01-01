// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:social_network_app/models/userModel.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../models/commentReelModel.dart';

// ignore: camel_case_types, must_be_immutable
class atCommentReelScreen extends StatefulWidget {
  String uid;
  String reelId;
  atCommentReelScreen(required,
      {Key? key, required this.uid, required this.reelId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _atCommentReelScreen createState() => _atCommentReelScreen(uid, reelId);
}

// ignore: camel_case_types
class _atCommentReelScreen extends State<atCommentReelScreen>
    with SingleTickerProviderStateMixin {
  String uid = '';
  String reelId = '';
  _atCommentReelScreen(this.uid, this.reelId);

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
  Future getUserDetail() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: uid)
        .snapshots()
        .listen((value) {
      setState(() {
        user = UserModel.fromDocument(value.docs.first.data());
        // ignore: avoid_print
        print(user.userName);
      });
    });
  }

  TextEditingController commentController = TextEditingController();
  GlobalKey<FormState> commentFormKey = GlobalKey<FormState>();

  List<commentReelModel> commentList = [];

  Future getCommentList() async {
    FirebaseFirestore.instance
        .collection('reels')
        .doc(reelId)
        .collection('comments')
        .snapshots()
        .listen((value) {
      setState(() {
        commentList.clear();
        for (var element in value.docs) {
          commentList.add(commentReelModel.fromDocument(element.data()));
        }
      });
    });
  }

  Future comment(String reelId) async {
    FirebaseFirestore.instance
        .collection('reels')
        .doc(reelId)
        .collection('comments')
        .add({
      'userId': uid,
      'ownerUsername': user.userName,
      'ownerAvatar': user.avatar,
      'reelId': reelId,
      'content': commentController.text,
      'state': 'show',
      'time': DateFormat('yMMMMd').format(DateTime.now()).toString()
    }).then((value) => FirebaseFirestore.instance
            .collection('reels')
            .doc(reelId)
            .collection('comments')
            .doc(value.id)
            .update({'id': value.id}));
  }

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    getUserDetail();
    // ignore: avoid_print
    print('Day la :$reelId');
    getCommentList();
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
            body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(profileBackground), fit: BoxFit.cover),
            ),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 24, right: 24, top: 20 + 20),
                      child: Column(children: [
                        Row(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Iconsax.back_square, size: 28),
                          ),
                          const SizedBox(width: 32),
                          Container(
                            alignment: Alignment.topCenter,
                            child: const Text(
                              'Comment',
                              style: TextStyle(
                                  fontFamily: 'Recoleta',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: black),
                            ),
                          ),
                        ]),
                        SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                              const SizedBox(height: 32),
                              SizedBox(
                                height: 640,
                                child: ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const SizedBox(height: 0),
                                    itemCount: commentList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.only(top: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      child: Image.network(
                                                        commentList[index]
                                                            .ownerAvatar,
                                                        width: 32,
                                                        height: 32,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    commentList[index]
                                                        .ownerUsername,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'Urbanist',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: black),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 327 + 24),
                                                margin: const EdgeInsets.only(
                                                    top: 16,
                                                    left: 8,
                                                    bottom: 16,
                                                    right: 24),
                                                // height: 73,
                                                // width: 236 - 12,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(16.0),
                                                  ),
                                                  color: Colors.transparent,
                                                ),
                                                child: RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                    text: commentList[index]
                                                        .content,
                                                    style: const TextStyle(
                                                        fontFamily: "Urbanist",
                                                        fontSize: 16.0,
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ]))),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              alignment: Alignment.topRight,
                                              child: const Icon(Iconsax.like_15,
                                                  size: 16, color: black),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                height: 54,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.only(left: 24, right: 24),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24.0)),
                                  color: gray,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    // SizedBox(width: 16),
                                    Expanded(
                                        child: Form(
                                      key: commentFormKey,
                                      child: TextField(
                                          controller: commentController,
                                          // onChanged: (value) => setState(() {
                                          //       comment = value;
                                          //     }),
                                          onEditingComplete: () {
                                            setState(() {
                                              commentController.clear();
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 14,
                                              color: black,
                                            ),
                                            hintText: "Type your comment...",
                                          )),
                                    )),
                                    const SizedBox(width: 20),
                                    AnimatedContainer(
                                      alignment: Alignment.center,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(24),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: black.withOpacity(0.25),
                                        //     spreadRadius: 0,
                                        //     blurRadius: 64,
                                        //     offset: Offset(8, 8),
                                        //   ),
                                        //   BoxShadow(
                                        //     color: black.withOpacity(0.2),
                                        //     spreadRadius: 0,
                                        //     blurRadius: 4,
                                        //     offset: Offset(0, 4),
                                        //   ),
                                        // ],
                                      ),
                                      child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          // padding: EdgeInsets.zero,
                                          alignment: Alignment.center,
                                          child: IconButton(
                                              icon: const Icon(Iconsax.send1),
                                              iconSize: 18,
                                              color: white,
                                              onPressed: () {
                                                setState(() {
                                                  comment(reelId);
                                                  commentController.clear();
                                                });
                                                setState(() {});
                                              })),
                                    ),
                                  ],
                                ),
                              ),
                            ]))
                      ]))))
        ])));
    // ])));
  }
}
