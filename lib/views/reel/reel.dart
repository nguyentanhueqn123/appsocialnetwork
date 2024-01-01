import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../constants/colors.dart';
import '../../models/reelModel.dart';
import 'contentScreen.dart';
import 'createReel.dart';

// ignore: camel_case_types, must_be_immutable
class atReelScreen extends StatefulWidget {
  String uid;
  atReelScreen(required, {Key? key, required this.uid}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _atReelScreen createState() => _atReelScreen();
}

// ignore: camel_case_types
class _atReelScreen extends State<atReelScreen>
    with SingleTickerProviderStateMixin {
  String userId = '';

  List<reelModel> reelList = [];
  List videoList = [];
  List ownerId = [];
  List reelId = [];
  Future getReelList() async {
    FirebaseFirestore.instance
        .collection("reels")
        .orderBy('timeCreate', descending: true)
        .snapshots()
        .listen((value) {
      setState(() {
        reelList.clear();
        for (var element in value.docs) {
          reelList.add(reelModel.fromDocument(element.data()));
        }
        // ignore: avoid_print
        print(reelList.length);
      });
    });
  }

  late SwiperController swiperController = SwiperController();
  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    userId = userid!;
    // ignore: avoid_print
    print(userId);
    getReelList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshController() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return refreshController();
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Swiper(
              controller: swiperController,
              itemBuilder: (BuildContext context, int index) {
                return ContentScreen(
                  src: reelList[index].urlVideo,
                  uid: reelList[index].idUser,
                  reelId: reelList[index].id,
                );
              },
              itemCount: reelList.length,
              scrollDirection: Axis.vertical,
            ),
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, top: 24 + 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      // SizedBox(width: 117.5),
                      const Text(
                        'Reel',
                        style: TextStyle(
                            fontFamily: 'Recoleta',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: white),
                      ),
                      // SizedBox(width: 117.5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      //             atPersonalInformationScreen(
                                      //                 required,
                                      //                 uid: ownerId))));

                                      atCreateReelScreen(context,
                                          uid: userId))));
                        },
                        child:
                            const Icon(Iconsax.camera, size: 28, color: white),
                      )
                    ],
                  ),
                ),
              ],
            ),
            // ContentScreen(like: like,)
          ],
        ),
      ),
    );
  }
}
