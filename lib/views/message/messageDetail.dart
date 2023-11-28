// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../models/contentMessageModel.dart';
import '../../models/userModel.dart';

// ignore: camel_case_types, must_be_immutable
class messageDetailScreen extends StatefulWidget {
  String uid;
  String uid2;
  String messagesId;
  messageDetailScreen(required,
      {Key? key,
      required this.uid,
      required this.uid2,
      required this.messagesId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _messageDetailScreenState createState() =>
      // ignore: no_logic_in_create_state
      _messageDetailScreenState(uid, uid2, messagesId);
}

// ignore: camel_case_types
class _messageDetailScreenState extends State<messageDetailScreen> {
  String uid = '';
  String uid2 = '';
  String messagesId = "";
  _messageDetailScreenState(this.uid, this.uid2, this.messagesId);
  late Content content = Content(
      contentId: '',
      userId: '',
      messageId: '',
      message: '',
      createAt: '',
      timeSendDetail: '');
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
  TextEditingController messageController = TextEditingController();
  GlobalKey<FormState> messageFormKey = GlobalKey<FormState>();
  String message = '';

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

  late DateTime date = DateTime.now();
  Future sendMessage() async {
    if (messageController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("contents").add({
        'content': messageController.text,
        'sendBy': uid,
        'messageId': messagesId,
        'timeSend': DateFormat('hh:mm a').format(DateTime.now()),
        'timeSendDetail':
            DateFormat('y MMMM d, hh:mm:ss').format(DateTime.now())
      }).then((value) {
        FirebaseFirestore.instance
            .collection("messages")
            .doc(messagesId)
            .update({
          'contentList': FieldValue.arrayUnion([value.id]),
          'lastMessage': messageController.text,
          'lastTimeSend': DateFormat('hh:mm a').format(DateTime.now())
        });
        FirebaseFirestore.instance.collection("contents").doc(value.id).update({
          'contentId': value.id,
        }).then((value) {
          setState(() {
            messageController.clear();
          });
        });
      });
    }
  }

  late List contentList;
  late List<Content> chatting = [];

  Future getMessage2() async {
    FirebaseFirestore.instance
        .collection("messages")
        .doc(messagesId)
        .snapshots()
        .listen((value1) {
      FirebaseFirestore.instance
          .collection("contents")
          .orderBy('timeSendDetail', descending: false)
          .snapshots()
          .listen((value2) {
        setState(() {
          chatting.clear();
          contentList = value1.data()!["contentList"];
          for (var element in value2.docs) {
            if (contentList.contains(element.data()['contentId'] as String)) {
              chatting.add(Content.fromDocument(element.data()));
            }
          }
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetail();
    getMessage2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(profileBackground), fit: BoxFit.cover),
            ),
          ),
          // ignore: avoid_unnecessary_containers
          Container(
            // scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
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
                    Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         Screen(required, uid: uid),
                            //   ),
                            // );
                          },
                          child: AnimatedContainer(
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 300),
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: black,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: black.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 64,
                                  offset: const Offset(8, 8),
                                ),
                                BoxShadow(
                                  color: black.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Container(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                child: const Icon(Iconsax.call,
                                    size: 18, color: white)),
                          ),
                        )),
                    const SizedBox(width: 8),
                    Container(
                        padding: const EdgeInsets.only(right: 28),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         Screen(required, uid: uid),
                            //   ),
                            // );
                          },
                          child: AnimatedContainer(
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 300),
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: black,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: black.withOpacity(0.25),
                                  spreadRadius: 0,
                                  blurRadius: 64,
                                  offset: const Offset(8, 8),
                                ),
                                BoxShadow(
                                  color: black.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Container(
                                padding: EdgeInsets.zero,
                                alignment: Alignment.center,
                                child: const Icon(Iconsax.video,
                                    size: 18, color: white)),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.only(left: 28),
                  child: Text(
                    user.userName,
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 24.0,
                        color: black,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 700,
                  decoration: const BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36.0),
                        topRight: Radius.circular(36.0),
                      )),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // ignore: sized_box_for_whitespace
                        Container(
                            height: 530,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const SizedBox(height: 32),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 24, right: 24),
                                      child: ListView.separated(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const SizedBox(height: 16),
                                          itemCount: chatting.length,
                                          itemBuilder: (context, index) {
                                            return (uid ==
                                                    chatting[index].userId)
                                                // ignore: avoid_unnecessary_containers
                                                ? Container(
                                                    // padding: EdgeInsets.only(
                                                    //     left: 28, right: 28),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          chatting[index]
                                                              .createAt,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontSize: 10.0,
                                                              color: gray,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                        const Spacer(),
                                                        Container(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  maxWidth:
                                                                      264),
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16,
                                                                  left: 24,
                                                                  bottom: 16,
                                                                  right: 24),
                                                          // height: 73,
                                                          // width: 236 - 12,
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        24.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        24.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        24.0)),
                                                            color: gray,
                                                          ),
                                                          child: Text(
                                                            chatting[index]
                                                                .message,
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontSize: 12.0,
                                                                color: white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                // ignore: avoid_unnecessary_containers
                                                : Container(
                                                    // padding: EdgeInsets.only(
                                                    //     left: 28, right: 28),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          width: 32,
                                                          height: 32,
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    // '${projects[index]!["background"]}'),
                                                                    user.avatar),
                                                                fit: BoxFit.cover),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Container(
                                                          constraints:
                                                              const BoxConstraints(
                                                                  maxWidth:
                                                                      254),
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 16,
                                                                  left: 24,
                                                                  bottom: 16,
                                                                  right: 24),
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        24.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        24.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        24.0)),
                                                            color: pink,
                                                          ),
                                                          child: Text(
                                                            chatting[index]
                                                                .message,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontSize: 12.0,
                                                                color: black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          chatting[index]
                                                              .createAt,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontSize: 10.0,
                                                              color: gray,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                          }),
                                    ),
                                  ],
                                ))),
                        const SizedBox(height: 100),
                        Container(
                          height: 54,
                          width: 319 + 32,
                          alignment: Alignment.center,
                          // margin: EdgeInsets.only(left: 24, right: 24),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24.0)),
                              color: Colors.transparent,
                              border: Border.all(color: gray)),
                          child: Row(
                            children: <Widget>[
                              const SizedBox(width: 28),
                              Expanded(
                                  child: Form(
                                key: messageFormKey,
                                child: TextField(
                                    controller: messageController,
                                    // onChanged: (value) => setState(() {
                                    //       message = value;
                                    //     }),
                                    onEditingComplete: () {
                                      setState(() {
                                        // sendMessage();
                                        getMessage2();
                                        // messageController.clear();
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: gray,
                                      ),
                                      hintText: "Type your message...",
                                    )),
                              )),
                              const SizedBox(width: 20),
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: AnimatedContainer(
                                  alignment: Alignment.center,
                                  duration: const Duration(milliseconds: 300),
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: gray,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: black.withOpacity(0.25),
                                        spreadRadius: 0,
                                        blurRadius: 64,
                                        offset: const Offset(8, 8),
                                      ),
                                      BoxShadow(
                                        color: black.withOpacity(0.2),
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      // padding: EdgeInsets.zero,
                                      alignment: Alignment.center,
                                      child: IconButton(
                                          icon: const Icon(Iconsax.send1),
                                          iconSize: 18,
                                          color: white,
                                          onPressed: () {
                                            setState(() {
                                              sendMessage();
                                              getMessage2();
                                            });
                                            setState(() {});
                                          })),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
