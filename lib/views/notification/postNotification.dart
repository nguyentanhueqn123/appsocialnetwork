// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_network_app/views/profile/profile.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../models/postModel.dart';
import '../../models/userModel.dart';
import '../dashboard/comment.dart';
import '../dashboard/postVideo.dart';
import '../widget/dialogWidget.dart';

// ignore: camel_case_types, must_be_immutable
class postNotification extends StatefulWidget {
  String uid;
  String postId;
  postNotification(BuildContext context,
      {Key? key, required this.uid, required this.postId})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _postNotificationState createState() =>
      // ignore: no_logic_in_create_state, unnecessary_this
      _postNotificationState(this.uid, this.postId);
}

// ignore: camel_case_types
class _postNotificationState extends State<postNotification> {
  bool liked = false;
  bool silent = false;
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
  String uid = '';
  String postId = '';

  _postNotificationState(this.uid, this.postId);

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

  PostModel post = PostModel(
      id: '',
      idUser: '',
      caption: '',
      urlImage: '',
      urlVideo: '',
      mode: '',
      timeCreate: '',
      state: '',
      ownerAvatar: '',
      likes: [],
      ownerUsername: '');
  Future getPost() async {
    FirebaseFirestore.instance
        .collection("posts")
        .where('id', isEqualTo: postId)
        .snapshots()
        .listen((value) {
      setState(() {
        post = PostModel.fromDocument(value.docs.first.data());
      });
    });
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
    getUserDetail();
    getPost();
    super.initState();
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
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: white,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 32),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.only(left: 28),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Iconsax.arrow_square_left,
                                size: 28, color: black),
                          ),
                          const Spacer(),
                          Container()
                        ]),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        atProfileScreen(ownerId: post.idUser)));
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    (post.ownerAvatar != '')
                                        ? post.ownerAvatar
                                        : 'https://i.imgur.com/RUgPziD.jpg',
                                    width: 32,
                                    height: 32,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                post.ownerUsername,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    color: black),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (uid == post.idUser) {
                              if (post.state == 'show') {
                                hidePostDialog(context, post.id);
                              } else {
                                showPostDialog(context, post.id);
                              }
                            } else {
                              savePostDialog(context, post.id, uid);
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
                    (post.urlImage != '')
                        ? Container(
                            width: 360,
                            height: 340,
                            padding: const EdgeInsets.only(top: 8, bottom: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                post.urlImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : (post.urlVideo != '')
                            ? postVideoWidget(context, src: post.urlVideo)
                            : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                liked = !liked;
                                like(post.id, post.likes, post.idUser);
                              });
                            },
                            icon: (post.likes.contains(uid))
                                ? Container(
                                    padding: const EdgeInsets.only(left: 8),
                                    alignment: Alignment.topRight,
                                    child: const Icon(Iconsax.like_15,
                                        size: 24, color: pink),
                                  )
                                : Container(
                                    padding: const EdgeInsets.only(left: 8),
                                    alignment: Alignment.topRight,
                                    child: const Icon(Iconsax.like_1,
                                        size: 24, color: black),
                                  )),
                        GestureDetector(
                          onTap: () {
                            //likes post
                          },
                          child: Container(
                              padding: const EdgeInsets.only(left: 8),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                (post.likes.isEmpty)
                                    ? '0'
                                    : post.likes.length.toString(),
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
                                    builder: ((context) => atCommentScreen(
                                          required,
                                          uid: uid,
                                          postId: post.id,
                                          ownerId: post.idUser,
                                        ))));
                          },
                          icon: const Icon(Iconsax.message_text,
                              size: 24, color: black),
                        ),
                        // Container(
                        //     margin: EdgeInsets.only(left: 8),
                        //     alignment: Alignment.centerLeft,
                        //     child: Text(
                        //       '24',
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         color: black,
                        //         fontFamily: 'Urbanist',
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     )),
                        const Spacer(),
                        Container(
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                        )
                      ],
                    ),
                    // SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        //likes post
                      },
                      child: Container(
                          width: 327 + 24,
                          margin: const EdgeInsets.only(left: 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            post.caption,
                            style: const TextStyle(
                                fontSize: 16,
                                color: black,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 1,
                          )),
                    ),
                    const SizedBox(height: 8),
                    Container(
                        margin: const EdgeInsets.only(left: 8),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          post.timeCreate,
                          style: const TextStyle(
                            fontSize: 16,
                            color: gray,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
