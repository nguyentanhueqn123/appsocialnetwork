// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/colors.dart';
import '../../models/userModel.dart';
import '../dashboard/dashboard.dart';
import '../notification/notification.dart';
import '../profile/profile.dart';
import '../reel/reel.dart';
import '../searching/searching.dart';

// ignore: camel_case_types, must_be_immutable
class navigationBar extends StatefulWidget {
  String uid;

  navigationBar({Key? key, required this.uid}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _navigationBar createState() => _navigationBar(uid);
}

// ignore: camel_case_types
class _navigationBar extends State<navigationBar>
    with SingleTickerProviderStateMixin {
  String uid = "";

  _navigationBar(uid);
  TabController? _tabController;
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
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    User? user = FirebaseAuth.instance.currentUser;
    final userid = user?.uid.toString();
    uid = userid!;
    getUserDetail();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        //onPageChanged: whenPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          atDashboardScreen(uid: uid),
          atSearchScreen(required, uid: uid),
          atReelScreen(required, uid: uid),
          atNotificationScreen(required, uid: uid),
          atProfileScreen(ownerId: uid)
        ],
      ),
      extendBody: true,
      bottomNavigationBar: SizedBox(
        height: 56,
        width: 375 + 24,
        // decoration: BoxDecoration(
        //   border: Border.all(color: white, width: 1),
        // ),
        // padding: EdgeInsets.only(
        //     left: (MediaQuery.of(context).size.width - 375 + 24) / 2,
        //     right: (MediaQuery.of(context).size.width - 375 + 24) / 2),
        child: ClipRRect(
          child: Container(
            color: black,
            child: TabBar(
              labelColor: white,
              unselectedLabelColor: white,
              indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(color: white, width: 1)),
              //For Indicator Show and Customization
              indicatorColor: black,
              tabs: <Widget>[
                const Tab(
                    // icon: SvgPicture.asset(
                    //   nbDashboard,
                    //   height: 24, width: 24
                    // )
                    icon: Icon(Iconsax.global, size: 24)),
                const Tab(
                    // icon: SvgPicture.asset(
                    //   nbAccountManagement,
                    //   height: 24, width: 24
                    // )
                    icon: Icon(Iconsax.search_normal, size: 24)),
                const Tab(
                    // icon: SvgPicture.asset(
                    //   nbIncidentReport,
                    //   height: 24, width: 24
                    // )
                    icon: Icon(Iconsax.video_play, size: 24)),
                const Tab(
                    // icon: SvgPicture.asset(
                    //   nbIncidentReport,
                    //   height: 24, width: 24
                    // )
                    icon: Icon(Iconsax.notification, size: 24)),
                Tab(
                  // icon: SvgPicture.asset(
                  //   nbIncidentReport,
                  //   height: 24, width: 24
                  // )
                  child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: black,
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          (user.avatar != '')
                              ? user.avatar
                              : 'https://i.imgur.com/RUgPziD.jpg',
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
              ],
              controller: _tabController,
            ),
          ),
        ),
      ),
    );
  }
}
