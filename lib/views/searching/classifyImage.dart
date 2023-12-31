// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter_tflite/flutter_tflite.dart';

import '../../constants/colors.dart';
import '../../models/postModel.dart';
import '../../models/userModel.dart';
import '../notification/postNotification.dart';
import '../widget/image.dart';
import '../widget/video.dart';

// ignore: camel_case_types, must_be_immutable
class atClassifyImageScreen extends StatefulWidget {
  String uid;
  atClassifyImageScreen({Key? key, required this.uid}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _atClassifyImageScreen createState() => _atClassifyImageScreen(uid);
}

// ignore: camel_case_types
class _atClassifyImageScreen extends State<atClassifyImageScreen>
    with SingleTickerProviderStateMixin {
  String uid = '';
  _atClassifyImageScreen(this.uid);
  String imageFile = '';
  String link = '';

  TextEditingController captionController = TextEditingController();
  final GlobalKey<FormState> captionFormKey = GlobalKey<FormState>();

  List<PostModel> postList = [];
  List<PostModel> postListCaption = [];

  Future searchCaption() async {
    FirebaseFirestore.instance.collection("posts").snapshots().listen((value) {
      setState(() {
        postListCaption.clear();
        postList.clear();
        for (var element in value.docs) {
          postListCaption.add(PostModel.fromDocument(element.data()));
        }

        for (var element in postListCaption) {
          // ignore: avoid_print
          print((element.caption
                  .toUpperCase()
                  .contains(search.toUpperCase().trim())) ==
              true);
          if ((("${element.caption} ")
                  .toUpperCase()
                  .contains(search.toUpperCase().trim())) ==
              true) {
            postList.add(element);
            // ignore: avoid_print
            print(postList.length);
          }
        }
      });
    });
  }

  List<UserModel> userSearch = [];
  List<UserModel> userList = [];
  Future searchName() async {
    FirebaseFirestore.instance.collection("users").snapshots().listen((value) {
      setState(() {
        userSearch.clear();
        userList.clear();
        for (var element in value.docs) {
          userSearch.add(UserModel.fromDocument(element.data()));
        }

        for (var element in userSearch) {
          // ignore: avoid_print
          print((element.email.toUpperCase().contains(search.toUpperCase())) ==
              true);
          if ((("${element.email} ")
                  .toUpperCase()
                  .contains(search.toUpperCase())) ==
              true) {
            userList.add(element);
            // ignore: avoid_print
            print(userList.length);
          }
        }
        for (var element in userList) {
          // ignore: avoid_print
          print(element.id);
          if (element.id == uid) {
            setState(() {
              userList.remove(element);
            });
          }
        }
      });
    });
  }

  handleTakePhoto() async {
    Navigator.pop(context);
  }

  String search = '';
  String resultError = '';

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
            model: "assets/model.tflite", labels: "assets/labels.txt")
        .onError((error, stackTrace) {
      resultError = 'PLease choose another image';
      return null;
    }))!;

    // ignore: avoid_print
    print("Models loading status: $res");
  }

  List _results = [];
  Future handleTakeGallery() async {
    Navigator.pop(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowCompression: false,
    );
    // ignore: avoid_print
    print('result');
    // ignore: avoid_print
    print(result);
    if (result != null) {
      // Upload file
      // ignore: avoid_print
      print(result.files.first.name);
      // ignore: avoid_print
      print(result.files.first.path);
      if (result.files.first.path != null) {
        // ignore: avoid_print
        print(result.files.first.path.toString());
        final List? recognitions = await Tflite.runModelOnImage(
          path: result.files.first.path.toString(),
          numResults: 1,
          threshold: 0.05,
          imageMean: 127.5,
          imageStd: 127.5,
        );
        setState(() {
          imageFile = result.files.first.path.toString();
          _results = recognitions!;
        });
      }
    }
  }

  selectImage(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              "Choose Resource",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: black),
            ),
            children: [
              SimpleDialogOption(
                onPressed: handleTakePhoto,
                child: const Text(
                  "Photo with Camera",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
              ),
              SimpleDialogOption(
                onPressed: handleTakeGallery,
                child: const Text(
                  "Photo with Gallery",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
              ),
              SimpleDialogOption(
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    // ignore: unused_local_variable
    final userid = user?.uid.toString();
    loadModel();
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
            color: white,
          ),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 24, right: 24, top: 20 + 20),
                      child: Column(children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Iconsax.back_square, size: 28),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                searchName();
                                searchCaption();
                              },
                              child:
                                  const Icon(Iconsax.search_favorite, size: 28),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        Column(children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              'Classify',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500,
                                  color: black),
                            ),
                          ),
                          const SizedBox(height: 8),
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
                          Stack(
                            children: [
                              (imageFile != '')
                                  ? GestureDetector(
                                      onTap: () {
                                        selectImage(context);
                                      },
                                      child: Container(
                                        width: 360,
                                        height: 340,
                                        padding: const EdgeInsets.only(
                                            top: 24, bottom: 16),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.file(
                                            File(imageFile),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(24),
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: gray, width: 1),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            color: Colors.transparent),
                                        child: IconButton(
                                            icon: const Icon(Iconsax.add,
                                                size: 30, color: gray),
                                            onPressed: () =>
                                                selectImage(context)),
                                      ),
                                    )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              'Classify: ',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(height: 16),
                          (_results.isEmpty)
                              ? Container()
                              : SingleChildScrollView(
                                  child: Column(
                                    children: _results.map((result) {
                                      setState(() {
                                        search = "${result['label']} ";
                                      });
                                      return Card(
                                        child: Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Text("${result['label']} ",
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  color: black,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                          const SizedBox(height: 24),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Post',
                              style: TextStyle(
                                  fontFamily: 'Recoleta',
                                  fontSize: 24,
                                  color: black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                              width: 327 + 24,
                              padding: const EdgeInsets.only(bottom: 8),
                              // height: 400,
                              child: GridView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2,
                                ),
                                itemCount: postList.length,
                                // userList.length.clamp(0, 3),
                                itemBuilder: (context, index) {
                                  // (postList.length == 0)
                                  //     ? Container()
                                  //     :
                                  return (postList[index].urlImage != '')
                                      ? ImageWidget(
                                          src: postList[index].urlImage,
                                          postId: postList[index].id,
                                          uid: uid,
                                          position: index.toString(),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        postNotification(
                                                            context,
                                                            uid: uid,
                                                            postId:
                                                                postList[index]
                                                                    .id))));
                                          },
                                          child: VideoWidget(
                                            src: postList[index].urlVideo,
                                            postId: postList[index].id,
                                            uid: uid,
                                            position: index.toString(),
                                          ),
                                        );
                                },
                              )),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'User',
                              style: TextStyle(
                                  fontFamily: 'Recoleta',
                                  fontSize: 24,
                                  color: black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.transparent),
                                child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    padding: const EdgeInsets.only(top: 8),
                                    shrinkWrap: true,
                                    itemCount: userList.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          width: 327 + 24,
                                          margin: const EdgeInsets.only(top: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(color: gray),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8))),
                                          child: GestureDetector(
                                            onTap: () {
                                              // ignore: avoid_print
                                              print('tap');
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 44,
                                                  height: 44,
                                                  margin: const EdgeInsets.only(
                                                      left: 16,
                                                      bottom: 16,
                                                      top: 16),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            // userList[index]
                                                            //     .avatar
                                                            (userList[index]
                                                                        .avatar !=
                                                                    '')
                                                                ? userList[
                                                                        index]
                                                                    .avatar
                                                                : 'https://i.imgur.com/RUgPziD.jpg'),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                Container(
                                                  width: 183 + 24,
                                                  margin: const EdgeInsets.only(
                                                      left: 16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        userList[index]
                                                            .userName,
                                                        style: const TextStyle(
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        userList[index].email,
                                                        style: const TextStyle(
                                                          color: gray,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ));
                                    })),
                          )
                        ])
                      ]))))
        ])));
  }
}
