// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/colors.dart';
import '../../models/UserModel.dart';
import '../../models/commentReelModel.dart';
import '../../models/reelModel.dart';
import 'commentReel.dart';

class OptionScreen extends StatefulWidget {
  final String? uid;
  final String? reelId;
  const OptionScreen({Key? key, this.uid, this.reelId}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _OptionScreenState createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  bool liked = false;
  String userId = '';
  Future like(String reelId, List likes) async {
    if (likes.contains(userId)) {
      FirebaseFirestore.instance.collection('reels').doc(reelId).update({
        'likes': FieldValue.arrayRemove([userId])
      });
    } else {
      FirebaseFirestore.instance.collection('reels').doc(reelId).update({
        'likes': FieldValue.arrayUnion([userId])
      });
    }
  }

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
      owner = UserModel.fromDocument(value.docs.first.data());
    });
  }

  Future getUserDetail() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .listen((value) {
      user = UserModel.fromDocument(value.docs.first.data());
    });
  }

  late reelModel reel = reelModel(
      id: '',
      idUser: '',
      caption: '',
      urlVideo: '',
      mode: '',
      timeCreate: '',
      state: '',
      ownerAvatar: '',
      likes: [],
      ownerUsername: '');

  Future getReelDetail() async {
    FirebaseFirestore.instance
        .collection("reels")
        .where("id", isEqualTo: widget.reelId)
        .snapshots()
        .listen((value) {
      reel = reelModel.fromDocument(value.docs.first.data());
    });
  }

  List<commentReelModel> listCMR = [];
  Future getNumbdercomment() async {
    FirebaseFirestore.instance
        .collection('reels')
        .doc(widget.reelId)
        .collection('comments')
        .snapshots()
        .listen((value) {
      for (var element in value.docs) {
        listCMR.add(commentReelModel.fromDocument(element.data()));
      }
    });
  }

  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    userId = userid!;
    // ignore: avoid_print
    print(userId);
    getReelDetail();
    getOwnerDetail();
    getUserDetail();
    getNumbdercomment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        children: [
          const SizedBox(),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 56 + 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              (owner.avatar != '')
                                  ? owner.avatar
                                  : 'https://i.imgur.com/RUgPziD.jpg',
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                            alignment: Alignment.center,
                            child: Text(
                              owner.userName,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w600,
                                  color: white),
                            ))
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                        width: 283,
                        child: Text(
                          reel.caption,
                          style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              color: white),
                          maxLines: 1,
                        )),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {},
                            child: const Icon(Iconsax.music_square5,
                                color: white, size: 24)),
                        const SizedBox(width: 8),
                        Container(
                            alignment: Alignment.center,
                            width: 128,
                            child: const Text(
                              'turmoilisme • Original sound',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                  color: white),
                              maxLines: 1,
                            )),
                        const SizedBox(width: 8),
                        GestureDetector(
                            onTap: () {},
                            child: const Icon(Iconsax.map5,
                                color: white, size: 24)),
                        const SizedBox(width: 8),
                        Container(
                            alignment: Alignment.center,
                            width: 90,
                            child: const Text(
                              'Thu Duc city',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                  color: white),
                              maxLines: 1,
                            )),
                      ],
                    )
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.only(bottom: 56 + 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            liked = !liked;
                            // ignore: avoid_print
                            print(' Like r ne');
                            // ignore: avoid_print
                            print(liked);
                            like(reel.id, reel.likes);
                          });
                        },
                        icon: (reel.likes.contains(userId))
                            ? Container(
                                padding: const EdgeInsets.only(left: 16),
                                alignment: Alignment.topRight,
                                child: const Icon(Iconsax.like_15,
                                    size: 24, color: pink),
                              )
                            : Container(
                                padding: const EdgeInsets.only(left: 16),
                                alignment: Alignment.topRight,
                                child: const Icon(Iconsax.like_1,
                                    size: 24, color: white),
                              )),
                    Container(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        (reel.likes.isEmpty)
                            ? '0'
                            : reel.likes.length.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontFamily: "Urbanist",
                            fontSize: 24.0,
                            color: white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => atCommentReelScreen(
                                        required,
                                        uid: userId,
                                        reelId: reel.id,
                                      ))));
                        },
                        child: const Icon(Iconsax.message_text,
                            color: white, size: 24)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        listCMR.length.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontFamily: "Urbanist",
                            fontSize: 24.0,
                            color: white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                        onTap: () {},
                        child:
                            const Icon(Iconsax.send_2, color: white, size: 24)),
                    const SizedBox(height: 24),
                    GestureDetector(
                        onTap: () {},
                        child:
                            const Icon(Iconsax.more, color: white, size: 24)),
                    const SizedBox(height: 24),
                    GestureDetector(
                        onTap: () {},
                        child: const Icon(Iconsax.voice_square,
                            color: white, size: 24)),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
