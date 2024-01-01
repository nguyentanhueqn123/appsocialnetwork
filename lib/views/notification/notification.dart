import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../models/notifyModel.dart';
import 'postNotification.dart';

// ignore: camel_case_types, must_be_immutable
class atNotificationScreen extends StatefulWidget {
  String uid;
  atNotificationScreen(required, {Key? key, required this.uid})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _atNotificationScreen createState() => _atNotificationScreen(uid);
}

// ignore: camel_case_types
class _atNotificationScreen extends State<atNotificationScreen>
    with SingleTickerProviderStateMixin {
  String uid = '';

  List<notifyModel> notifyList = [];

  _atNotificationScreen(this.uid);
  Future getNotifiesList() async {
    // ignore: avoid_print
    print(widget.uid);
    FirebaseFirestore.instance
        .collection("notifies")
        .orderBy('timeCreate', descending: true)
        .snapshots()
        .listen((value) {
      setState(() {
        notifyList.clear();
        for (var element in value.docs) {
          if (element.data()['idReceiver'] == widget.uid) {
            notifyList.add(notifyModel.fromDocument(element.data()));
          }
        }
        // ignore: avoid_print
        print("notifyList.length");
        // ignore: avoid_print
        print(notifyList.length);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getNotifiesList();
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
              color: white,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Container(
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, top: 20 + 20),
                    child: Column(
                      children: [
                        // ignore: avoid_unnecessary_containers
                        Container(
                            // margin: EdgeInsets.only(
                            //     left: 24, right: 24, top: 20 + 20),
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'Notification',
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
                          ],
                        )),
                        const SizedBox(height: 24),
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'This month',
                            style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        // ignore: avoid_unnecessary_containers
                        Container(
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.only(top: 8),
                              shrinkWrap: true,
                              itemCount: notifyList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    width: 327 + 24,
                                    margin: const EdgeInsets.only(top: 8),
                                    decoration: const BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (notifyList[index].category ==
                                            'follow') {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             atProfileScreen(required,
                                          //                 ownerId:
                                          //                     notifyList[index]
                                          //                         .idSender)));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      postNotification(context,
                                                          uid: uid,
                                                          postId:
                                                              notifyList[index]
                                                                  .idPost))));
                                        }
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 44,
                                            height: 44,
                                            margin: const EdgeInsets.only(
                                                left: 16, bottom: 16, top: 16),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      // userList[index]
                                                      //     .avatar
                                                      (notifyList[index]
                                                                  .avatarSender !=
                                                              '')
                                                          ? notifyList[index]
                                                              .avatarSender
                                                          : 'https://i.imgur.com/RUgPziD.jpg'),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            width: 183 + 24,
                                            margin:
                                                const EdgeInsets.only(left: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                    text: TextSpan(
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              'Urbanist',
                                                          fontSize: 16,
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                        children: <TextSpan>[
                                                      TextSpan(
                                                        text: notifyList[index]
                                                            .nameSender,
                                                        style: const TextStyle(
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            " ${notifyList[index].content}",
                                                        style: const TextStyle(
                                                          color: gray,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ])),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8),
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    notifyList[index]
                                                        .timeCreate,
                                                    style: const TextStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontSize: 12,
                                                        color: gray,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                              }),
                        ),
                        // SizedBox(height: 24),
                        // Container(
                        //   alignment: Alignment.topLeft,
                        //   child: Text(
                        //     'Before',
                        //     style: TextStyle(
                        //         fontFamily: 'Urbanist',
                        //         fontSize: 16,
                        //         color: black,
                        //         fontWeight: FontWeight.w400),
                        //   ),
                        // ),
                        // SizedBox(height: 16),
                        // Container(
                        //   child: ListView.builder(
                        //       physics: const NeverScrollableScrollPhysics(),
                        //       scrollDirection: Axis.vertical,
                        //       padding: EdgeInsets.only(top: 8),
                        //       shrinkWrap: true,
                        //       itemCount: 4,
                        //       itemBuilder: (context, index) {
                        //         return Container(
                        //             width: 327 + 24,
                        //             margin: EdgeInsets.only(top: 8),
                        //             decoration: BoxDecoration(
                        //                 color: white,
                        //                 borderRadius: BorderRadius.all(
                        //                     Radius.circular(8))),
                        //             child: GestureDetector(
                        //               onTap: () {
                        //                 print('Post');
                        //               },
                        //               child: Row(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.center,
                        //                 children: [
                        //                   Container(
                        //                     width: 44,
                        //                     height: 44,
                        //                     margin: EdgeInsets.only(
                        //                         left: 16, bottom: 16, top: 16),
                        //                     decoration: new BoxDecoration(
                        //                       shape: BoxShape.circle,
                        //                       image: DecorationImage(
                        //                           image: NetworkImage(
                        //                               // userList[index]
                        //                               //     .avatar
                        //                               'https://i.imgur.com/bCnExb4.jpg'),
                        //                           fit: BoxFit.cover),
                        //                     ),
                        //                   ),
                        //                   Container(
                        //                     width: 183 + 24,
                        //                     margin: EdgeInsets.only(left: 16),
                        //                     child: Column(
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                       children: [
                        //                         RichText(
                        //                             text: TextSpan(
                        //                                 style: TextStyle(
                        //                                   fontFamily:
                        //                                       'Urbanist',
                        //                                   fontSize: 16,
                        //                                   color: black,
                        //                                   fontWeight:
                        //                                       FontWeight.w300,
                        //                                 ),
                        //                                 children: const <
                        //                                     TextSpan>[
                        //                               TextSpan(
                        //                                 text: 'pan_chao ',
                        //                                 style: TextStyle(
                        //                                   color: black,
                        //                                   fontWeight:
                        //                                       FontWeight.w600,
                        //                                 ),
                        //                               ),
                        //                               TextSpan(
                        //                                 text:
                        //                                     'liked your photo. ',
                        //                                 style: TextStyle(
                        //                                   color: gray,
                        //                                   fontWeight:
                        //                                       FontWeight.w400,
                        //                                 ),
                        //                               ),
                        //                             ])),
                        //                         Container(
                        //                           padding:
                        //                               EdgeInsets.only(top: 8),
                        //                           alignment: Alignment.topLeft,
                        //                           child: Text(
                        //                             'Today, at 3:15 AM',
                        //                             style: TextStyle(
                        //                                 fontFamily: 'Urbanist',
                        //                                 fontSize: 12,
                        //                                 color: gray,
                        //                                 fontWeight:
                        //                                     FontWeight.w400),
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   )
                        //                 ],
                        //               ),
                        //             ));
                        //       }),
                        // ),
                      ],
                    ))),
          )
        ])));
  }
}
