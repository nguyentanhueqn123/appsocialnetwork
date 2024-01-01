import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../models/postModel.dart';
import '../../models/userModel.dart';
import '../../repository/authen_repository.dart';
import '../../repository/storage_method.dart';
import '../widget/image.dart';
import '../widget/video.dart';
import 'personalInformation.dart';
import 'seeAllFollower.dart';

// ignore: camel_case_types, must_be_immutable
class atProfileScreen extends StatefulWidget {
  String ownerId;
  atProfileScreen({Key? key, required this.ownerId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _atProfileScreen createState() => _atProfileScreen(ownerId);
}

// ignore: camel_case_types
class _atProfileScreen extends State<atProfileScreen>
    with SingleTickerProviderStateMixin {
  String userId = '';
  String ownerId = '';
  _atProfileScreen(this.ownerId);
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
        .where("userId", isEqualTo: ownerId)
        .snapshots()
        .listen((value) {
      setState(() {
        idFollowers.clear();
        owner = UserModel.fromDocument(value.docs.first.data());
        photoUrl = owner.avatar;
        idFollowers = owner.favoriteList;
        // ignore: avoid_print
        print(idFollowers.length);
      });
    });
  }

  List idFollowers = [];
  Future getUserDetail() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .listen((value) {
      user = UserModel.fromDocument(value.docs.first.data());
    });
  }

  Future followEvent(List follow) async {
    if (follow.contains(ownerId)) {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'follow': FieldValue.arrayRemove([ownerId]),
      });
      FirebaseFirestore.instance.collection('users').doc(ownerId).update({
        'favoriteList': FieldValue.arrayRemove([userId])
      });
    } else {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'follow': FieldValue.arrayUnion([ownerId])
      });
      FirebaseFirestore.instance.collection('users').doc(ownerId).update({
        'favoriteList': FieldValue.arrayUnion([userId])
      });
      if (userId != ownerId) {
        FirebaseFirestore.instance.collection('notifies').add({
          'idSender': userId,
          'idReceiver': ownerId,
          'avatarSender': user.avatar,
          'mode': 'public',
          'idPost': '',
          'content': 'just follow to you',
          'category': 'follow',
          'nameSender': user.userName,
          'timeCreate': DateFormat('y MMMM d, hh:mm a').format(DateTime.now())
        }).then((value) {
          FirebaseFirestore.instance
              .collection('notifies')
              .doc(value.id)
              .update({'id': value.id});
        });
      }
    }
  }

  late List<PostModel> postList = [];
  late List<PostModel> postListImage = [];
  Future getPostList() async {
    FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: ownerId)
        .snapshots()
        .listen((value) {
      setState(() {
        postList.clear();
        postVideoList.clear();
        postListImage.clear();
        for (var element in value.docs) {
          postList.add(PostModel.fromDocument(element.data()));
        }
        for (var element in postList) {
          if (element.urlVideo != '') {
            postVideoList.add(element);
          } else {
            postListImage.add(element);
          }
        }
      });
    });
  }

  late List<PostModel> postSaveList = [];
  List saveIdList = [];
  Future getSavePostList() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(ownerId)
        .snapshots()
        .listen((value1) {
      FirebaseFirestore.instance
          .collection('posts')
          .snapshots()
          .listen((value2) {
        setState(() {
          saveIdList = value1.data()!["saveList"];
          postSaveList.clear();
          for (var element in value2.docs) {
            if (saveIdList.contains(element.data()['id'] as String)) {
              postSaveList.add(PostModel.fromDocument(element.data()));
            }
          }
        });
      });
    });
  }

  late List<PostModel> postVideoList = [];

  bool followed = false;
  final pageViewcontroller =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);

  TabController? _tabController;

  Future storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({'token': token}, SetOptions(merge: true));
  }

  String photoUrl = '';

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: false,
    );
    // ignore: avoid_print
    print('result');
    // ignore: avoid_print
    print(result);
    if (result != null) {
      photoUrl = await StorageMethods().uploadImageToStorage(
          'profilePics', File(result.files.first.path.toString()), false);

      await FirebaseFirestore.instance.collection("users").doc(ownerId).update({
        'avatar': photoUrl,
      });
      return File(result.files.first.path.toString());
    }
  }

  String backgroundUrl = '';
  pickImageBackground() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: false,
    );
    // ignore: avoid_print
    print('result');
    // ignore: avoid_print
    print(result);
    if (result != null) {
      backgroundUrl = await StorageMethods().uploadImageToStorage(
          'uploads', File(result.files.first.path.toString()), false);

      await FirebaseFirestore.instance.collection("users").doc(ownerId).update({
        'background': backgroundUrl,
      });
      return File(result.files.first.path.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    userId = userid!;
    getOwnerDetail();
    getUserDetail();
    getPostList();
    getSavePostList();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent),
        child: Scaffold(
          body: PageView(
            scrollDirection: Axis.vertical,
            controller: pageViewcontroller,
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(profileBackground), fit: BoxFit.cover),
                ),
                child: Stack(children: [
                  GestureDetector(
                    onTap: () {
                      if (userId == ownerId) {
                        pickImageBackground();
                      }
                    },
                    child: Container(
                        height: 186,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: white,
                        ),
                        child: Image.network(
                            (owner.background != '')
                                ? owner.background
                                : 'https://i.imgur.com/RUgPziD.jpg',
                            fit: BoxFit.cover)),
                  ),
                  (ownerId != userId)
                      ? IconButton(
                          padding: const EdgeInsets.only(left: 28),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Iconsax.arrow_square_left,
                              size: 28, color: black),
                        )
                      : Container(),
                  Container(
                    margin: const EdgeInsets.only(left: 24, right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20 + 186),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            (ownerId != userId)
                                ? (Row(
                                    children: [
                                      (user.follow.contains(ownerId))
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  followed = !followed;
                                                  followEvent(user.follow);
                                                });
                                              },
                                              child: Container(
                                                width: 72 + 24,
                                                height: 24,
                                                decoration: const BoxDecoration(
                                                  color: black,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                ),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: const Text('Following',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: white)),
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  followed = !followed;
                                                  followEvent(user.follow);
                                                });
                                              },
                                              child: Container(
                                                width: 72,
                                                height: 24,
                                                decoration: const BoxDecoration(
                                                  color: gray,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                ),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: const Text('Follow',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: black)),
                                                ),
                                              ),
                                            ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: ((context) =>
                                            //             atPersonalInformationScreen(
                                            //                 required,
                                            //                 uid: ownerId))));
                                          },
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  right: 16),
                                              child: const Icon(Iconsax.message,
                                                  size: 24, color: black)),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // ignore: avoid_print
                                          print('tap option');
                                        },
                                        child: const Icon(Iconsax.more,
                                            size: 24, color: black),
                                      ),
                                    ],
                                  ))
                                : Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      atPersonalInformationScreen(
                                                          required,
                                                          uid: ownerId))));
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.only(
                                                right: 16),
                                            child: const Icon(Iconsax.edit_2,
                                                size: 24, color: black)),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          signOut(context);
                                        },
                                        child: const Icon(Iconsax.logout,
                                            size: 24, color: black),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(owner.userName,
                              style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: black)),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 8),
                          width: 327 + 24,
                          alignment: Alignment.topLeft,
                          child: Text(owner.role,
                              style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: black)),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 192,
                            height: 0.5,
                            decoration: const BoxDecoration(
                              color: gray,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 144,
                            height: 0.5,
                            decoration: const BoxDecoration(
                              color: gray,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (postList.isEmpty)
                                        ? '0'
                                        : postList.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                      color: black,
                                    ),
                                  ),
                                  const Text(
                                    "Posts",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w400,
                                      color: gray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 63.5),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (owner.favoriteList.isEmpty)
                                        ? '0'
                                        : owner.favoriteList.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                      color: black,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) => seeAll(
                                                    idUser: idFollowers,
                                                  ))));
                                    },
                                    child: const Text(
                                      "Followers",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w400,
                                        color: gray,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 63.5),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (owner.follow.isEmpty)
                                        ? '0'
                                        : owner.follow.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                      color: black,
                                    ),
                                  ),
                                  const Text(
                                    "Following",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w400,
                                      color: gray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 56,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            color: Colors.transparent,
                            child: const TabBar(
                              labelColor: black,
                              unselectedLabelColor: Colors.transparent,
                              indicator: UnderlineTabIndicator(
                                  borderSide:
                                      BorderSide(color: black, width: 1)),
                              //For Indicator Show and Customization
                              indicatorColor: black,
                              tabs: [
                                Tab(
                                  icon: Icon(Iconsax.grid_8,
                                      color: black, size: 24),
                                ),
                                Tab(
                                  icon: Icon(Iconsax.video_circle,
                                      color: black, size: 24),
                                ),
                                Tab(
                                  icon: Icon(Iconsax.save_2,
                                      color: black, size: 24),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: TabBarView(
                          controller: _tabController,
                          children: [
                            profileTabPostScreen(postList),
                            profileTabVideoScreen(postVideoList),
                            profileTabPostScreen(postSaveList),
                          ],
                        ))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (userId == ownerId) {
                        pickImage();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 24, top: 98 + 44),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 30,
                              offset: Offset(2, 4), // Shadow position
                            ),
                          ],
                          image: DecorationImage(
                              image: NetworkImage(
                                  // userList[index]
                                  //     .avatar
                                  (photoUrl != '')
                                      ? photoUrl
                                      : 'https://i.imgur.com/RUgPziD.jpg'),
                              fit: BoxFit.cover),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  profileTabPostScreen(List postList) {
    return GridView.custom(
      gridDelegate: (postList.length >= 4)
          ? SliverQuiltedGridDelegate(
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              repeatPattern: QuiltedGridRepeatPattern.inverted,
              pattern: [
                const QuiltedGridTile(2, 1),
                const QuiltedGridTile(1, 1),
                const QuiltedGridTile(1, 1),
                const QuiltedGridTile(1, 2),
              ],
            )
          : SliverQuiltedGridDelegate(
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              repeatPattern: QuiltedGridRepeatPattern.inverted,
              pattern: [const QuiltedGridTile(1, 1)],
            ),
      childrenDelegate: SliverChildBuilderDelegate(
        (context, index) {
          // (postList.length == 0)
          //     ? Container()
          //     :
          return (postList[index].urlImage != '')
              ? ImageWidget(
                  src: postList[index].urlImage,
                  postId: postList[index].id,
                  uid: userId,
                  position: index.toString(),
                )
              : VideoWidget(
                  src: postList[index].urlVideo,
                  postId: postList[index].id,
                  uid: userId,
                  position: index.toString(),
                );
        },
        childCount: postList.length,
      ),
    );
  }

  profileTabVideoScreen(List postList) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: postList.length,
        itemBuilder: (context, index) {
          // (postList.length == 0)
          //     ? Container()
          //     :
          return VideoWidget(
            src: postList[index].urlVideo,
            postId: postList[index].id,
            uid: userId,
            position: index.toString(),
          );
        },
      ),
    );
  }

  profileTabReelScreen(List postList) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: postList.length,
        itemBuilder: (context, index) {
          // (postList.length == 0)
          //     ? Container()
          //     :
          return VideoWidget(
            src: postList[index].urlVideo,
            postId: postList[index].id,
            uid: userId,
            position: index.toString(),
          );
        },
      ),
    );
  }
}
