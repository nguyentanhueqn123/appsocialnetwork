// ignore_for_file: file_names, must_be_immutable, no_logic_in_create_state, camel_case_types, duplicate_ignore
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:file_picker/file_picker.dart';

import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../models/userModel.dart';
import 'postVideo.dart';

// ignore: camel_case_types
class atCreatePostScreen extends StatefulWidget {
  String uid;

  atCreatePostScreen(required, {Key? key, required this.uid}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _atCreatePostScreen createState() => _atCreatePostScreen(uid);
}

class _atCreatePostScreen extends State<atCreatePostScreen>
    with SingleTickerProviderStateMixin {
  String uid = '';
  _atCreatePostScreen(uid);
  File? imageFile;
  File? videoFile;
  String link = '';

  TextEditingController captionController = TextEditingController();
  final GlobalKey<FormState> captionFormKey = GlobalKey<FormState>();

  late String urlImage = '';
  late String urlVideo = '';

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
      // ignore: unused_local_variable
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;

      // Upload file
      // ignore: avoid_print
      print(result.files.first.name);
      // ignore: avoid_print
      print(result.files.first.path);
      if (result.files.first.path != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref('uploads/$fileName');
        // ignore: unused_local_variable
        await ref.putFile(File(result.files.first.path.toString()));
        Reference ref_2 =
            FirebaseStorage.instance.ref().child('uploads/$fileName');

        link = (await ref_2.getDownloadURL()).toString();

        // ignore: avoid_print
        print(result.files.first.path.toString());
        if (result.files.first.name.contains('.mp4')) {
          setState(() {
            urlVideo = link;
            urlImage = '';
          });
        } else {
          setState(() {
            urlVideo = '';
            urlImage = link;
          });
        }
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
                  fontFamily: 'Recoleta',
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: black),
            ),
            children: [
              SimpleDialogOption(
                child: const Text(
                  "Photo with Camera",
                  style: TextStyle(
                      fontFamily: 'Recoleta',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                onPressed: () {},
              ),
              SimpleDialogOption(
                // ignore: sort_child_properties_last
                child: const Text(
                  "Photo with Gallery",
                  style: TextStyle(
                      fontFamily: 'Recoleta',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                onPressed: handleTakeGallery,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                      fontFamily: 'Recoleta',
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
  List userFollower = [];
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
        userFollower = user.favoriteList;
        // ignore: avoid_print
        print('userFollower.length');
        // ignore: avoid_print
        print(userFollower.length);
      });
    });
  }

  late DateTime timeCreate = DateTime.now();
  Future post() async {
    FirebaseFirestore.instance.collection('posts').add({
      'userId': uid,
      'caption': captionController.text,
      'urlImage': urlImage,
      'urlVideo': urlVideo,
      'ownerAvatar': user.avatar,
      'ownerUsername': user.userName,
      'mode': 'public',
      'state': 'show',
      'likes': FieldValue.arrayUnion([]),
      'timeCreate': DateFormat('y MMMM d, hh:mm:ss').format(DateTime.now())
    }).then((value) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(value.id)
          .update({'id': value.id}).then((value2) {
        for (var element in userFollower) {
          FirebaseFirestore.instance.collection('notifies').add({
            'idSender': uid,
            'idReceiver': element,
            'avatarSender': user.avatar,
            'mode': 'public',
            'idPost': value.id,
            'content': 'just post the new photo',
            'category': 'post',
            'nameSender': user.userName,
            'timeCreate': DateFormat('y MMMM d, hh:mm a').format(DateTime.now())
          }).then((value3) {
            FirebaseFirestore.instance
                .collection('notifies')
                .doc(value3.id)
                .update({'id': value3.id});
          });
        }
      });
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    getUserDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.3,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            color: white),
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false, // this is new

          body: SingleChildScrollView(
              // this is new
              reverse: true,
              physics: BouncingScrollPhysics(),
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
                                post();
                              },
                              child: const Icon(Iconsax.add_square, size: 28),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        // ignore: avoid_unnecessary_containers
                        Container(
                            // margin: EdgeInsets.only(
                            //     left: 24, right: 24, top: 20 + 20),
                            child: Column(children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              'Create Post',
                              style: TextStyle(
                                  fontFamily: 'Recoleta',
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
                              (urlImage == '')
                                  ? ((urlVideo == '')
                                      ? Container(
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
                                      : postVideoWidget(context, src: urlVideo))
                                  : Container(
                                      width: 360,
                                      height: 340,
                                      padding: const EdgeInsets.only(
                                          top: 24, bottom: 16),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          urlImage,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              'Caption: ',
                              style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16,
                                  color: black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Form(
                            key: captionFormKey,
                            child: Container(
                              width: 327 + 24,
                              margin: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: gray,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.topCenter,
                              child: TextFormField(
                                  style: const TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 16,
                                      color: black,
                                      fontWeight: FontWeight.w400),
                                  //validator
                                  validator: (email) {
                                    // if (isEmailValid(email.toString())) {
                                    //   WidgetsBinding.instance!
                                    //       .addPostFrameCallback((_) {
                                    //     setState(() {
                                    //       notiColorEmail = green;
                                    //     });
                                    //   });
                                    //   return null;
                                    // } else {
                                    //   WidgetsBinding.instance!
                                    //       .addPostFrameCallback((_) {
                                    //     setState(() {
                                    //       notiColorEmail = red;
                                    //     });
                                    //   });
                                    //   return '';
                                    // }
                                  },
                                  controller: captionController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    hintStyle: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: black.withOpacity(0.5)),
                                    hintText: "Write something about your post",
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    errorStyle: const TextStyle(
                                      color: Colors.transparent,
                                      fontSize: 0,
                                      height: 0,
                                    ),
                                  )),
                            ),
                          ),
                        ])),
                        Padding(
                            // this is new
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom)),
                      ])))),
        ));
  }
}
