// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../models/messageModel.dart';
import '../../models/userModel.dart';
import 'messageDetail.dart';

// ignore: camel_case_types, must_be_immutable
class messsageScreen extends StatefulWidget {
  String uid;
  messsageScreen(required, {Key? key, required this.uid}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _messsageScreenState createState() => _messsageScreenState(uid);
}

// ignore: camel_case_types
class _messsageScreenState extends State<messsageScreen> {
  String uid = '';
  _messsageScreenState(uid);

  List<UserModel> userList = [];

  Future getAllUser() async {
    FirebaseFirestore.instance.collection("users").get().then((value) {
      setState(() {
        for (var element in value.docs) {
          if (element.id == uid) {
          } else {
            userList.add(UserModel.fromDocument(element.data()));
          }
        }
      });
    });

    setState(() {});
  }

  late UserModel currentUser = UserModel(
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
        currentUser = UserModel.fromDocument(value.docs.first.data());
        // ignore: avoid_print
        print(currentUser.userName);
      });
    });
  }

  String newMessageId = "";
  String messageId = '';

  Future createMessage(String userName, String userIdS2, String userName2,
      String background2) async {
    FirebaseFirestore.instance.collection("messages").get().then((value) {
      for (var element in value.docs) {
        if ((uid == (element.data()['userId1'] as String) &&
                    userIdS2 == (element.data()['userId2'] as String)) ||
                (uid == (element.data()['userId2'] as String) &&
                    userIdS2 == (element.data()['userId1'] as String))
            //      &&
            // element.data()['timeSend'] != null
            ) {
          newMessageId = element.id;
          // ignore: avoid_print
          print(newMessageId);
        }
      }
      setState(() {
        if (newMessageId == '') {
          FirebaseFirestore.instance.collection("messages").add({
            'userId1': uid,
            'userId2': userIdS2,
            'name1': userName,
            'name2': userName2,
            'background1': currentUser.avatar,
            'background2': background2,
            'contentList': FieldValue.arrayUnion([]),
            'lastTimeSend': DateFormat('hh:mm a').format(DateTime.now()),
            'lastMessage': '',
          }).then((value) {
            setState(() {
              FirebaseFirestore.instance
                  .collection("messages")
                  .doc(value.id)
                  .update({
                'messageId': value.id,
              });
            });
            messageId = value.id;
          });
        } else {
          (currentUser.id == userIdS2)
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => messageDetailScreen(required,
                        uid: uid, uid2: userIdS2, messagesId: newMessageId),
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => messageDetailScreen(required,
                        uid: userIdS2, uid2: uid, messagesId: newMessageId),
                  ),
                );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => messageDetailScreen(required,
          //         uid: uid, uid2: userIdS2, messagesId: newMessageId),
          //   ),
          // );
        }
      });
    });
  }

  late List<Message> messagesList = [];
  late List messagesIdList;
  Future getMessage() async {
    FirebaseFirestore.instance
        .collection("messages")
        .snapshots()
        .listen((value2) {
      setState(() {});
      messagesList.clear();
      for (var element in value2.docs) {
        if (uid.contains(element.data()['userId1'] as String) ||
            uid.contains(element.data()['userId2'] as String)) {
          messagesList.add(Message.fromDocument(element.data()));
        }
      }

      // ignore: avoid_print
      print(messagesList.length);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    getUserDetail();
    getAllUser();
    getMessage();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 62),
                Container(
                  padding: const EdgeInsets.only(right: 28),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.only(left: 28),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Iconsax.arrow_square_left,
                            size: 24, color: black),
                      ),
                      const SizedBox(width: 6),
                      // Container(
                      //   padding: EdgeInsets.only(left: 16),
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(4),
                      //     child: Image.network(
                      //       currentUser.avatar,
                      //       width: 48,
                      //       height: 48,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                currentUser.userName,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    color: black,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2),
                              )),
                        ],
                      ),
                      const Spacer(),
                      Container(
                          // padding: EdgeInsets.only(right: 28),
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.only(left: 28),
                  child: const Text(
                    "Messages",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 24.0,
                        color: black,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 28),
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
                              // searchMessageDialog(context, userList);
                            },
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: const Duration(milliseconds: 300),
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Container(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  child: const Icon(Iconsax.search_normal,
                                      size: 18, color: black)),
                            ),
                          )),
                      const SizedBox(width: 4),
                      // ignore: sized_box_for_whitespace
                      Container(
                        width: 367,
                        height: 48 + 14 + 16,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: userList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  height: 48 + 16,
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 4),
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      createMessage(
                                          currentUser.userName,
                                          userList[index].id,
                                          userList[index].userName,
                                          userList[index].avatar);
                                      getMessage();
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          // ignore: sort_child_properties_last
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Image.network(
                                                userList[index].avatar,
                                                fit: BoxFit.cover,
                                                width: 48,
                                                height: 48,
                                              ),
                                            ),
                                          ),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            userList[index].userName,
                                            style: const TextStyle(
                                                fontFamily: 'Urbanist',
                                                fontSize: 12,
                                                color: black,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(left: 28, right: 28),
                      // height: 700 - 107 - 14 - 16 - 70,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36),
                            topRight: Radius.circular(36)),
                        color: white,
                      ),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(top: 16),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: messagesList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                alignment: Alignment.center,
                                child: GestureDetector(
                                    onTap: () {
                                      (currentUser.id ==
                                              messagesList[index].userId2)
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    messageDetailScreen(
                                                        required,
                                                        uid: messagesList[index]
                                                            .userId1,
                                                        uid2:
                                                            messagesList[index]
                                                                .userId2,
                                                        messagesId:
                                                            messagesList[index]
                                                                .messageId),
                                              ),
                                            )
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    messageDetailScreen(
                                                        required,
                                                        uid: messagesList[index]
                                                            .userId2,
                                                        uid2:
                                                            messagesList[index]
                                                                .userId1,
                                                        messagesId:
                                                            messagesList[index]
                                                                .messageId),
                                              ),
                                            );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          width: 60,
                                          height: 60,
                                          // ignore: sort_child_properties_last
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Image.network(
                                                (currentUser.id ==
                                                        messagesList[index]
                                                            .userId1)
                                                    ? messagesList[index]
                                                        .background2
                                                    : messagesList[index]
                                                        .background1,
                                                width: 32,
                                                height: 32,
                                              ),
                                            ),
                                          ),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Container(
                                          alignment: Alignment.center,
                                          height: 64,
                                          width: 232,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  // ignore: sized_box_for_whitespace
                                                  Container(
                                                    width: 100,
                                                    child: Text(
                                                      (currentUser.id ==
                                                              messagesList[
                                                                      index]
                                                                  .userId1)
                                                          ? messagesList[index]
                                                              .name2
                                                          : messagesList[index]
                                                              .name1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: 14.0,
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          height: 1.4),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    messagesList[index]
                                                        .lastTimeSend,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 12.0,
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              // ignore: sized_box_for_whitespace
                                              Container(
                                                width: 232,
                                                child: Text(
                                                  messagesList[index]
                                                      .lastMessage,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 12.0,
                                                      color: black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              const SizedBox(height: 6)
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              );
                            }),
                        const SizedBox(height: 24)
                      ]))),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
