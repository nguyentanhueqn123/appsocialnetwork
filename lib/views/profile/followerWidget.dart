// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../models/userModel.dart';
import 'profile.dart';

// ignore: camel_case_types, must_be_immutable
class followerWidget extends StatefulWidget {
  String uid;

  followerWidget({Key? key, required this.uid}) : super(key: key);

  bool liked = false;
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _followerWidgetState createState() => _followerWidgetState(uid);
}

// ignore: camel_case_types
class _followerWidgetState extends State<followerWidget> {
  String uid = '';
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

  _followerWidgetState(this.uid);

  Future getOwnerDetail() async {
    // ignore: avoid_print
    print(uid.replaceAll(r'[', '').replaceAll(r']', ''));
    FirebaseFirestore.instance
        .collection("users")
        .where("userId",
            isEqualTo: uid.replaceAll(r'[', '').replaceAll(r']', ''))
        .snapshots()
        .listen((value) {
      setState(() {
        owner = UserModel.fromDocument(value.docs.first.data());
        // ignore: avoid_print
        print(owner.userName);
        // ignore: avoid_print
        print("owner.background 123");
        // ignore: avoid_print
        print(owner.background);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getOwnerDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ignore: unused_field
  final bool _liked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => atProfileScreen(ownerId: owner.id)));
      },
      child: Stack(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 0, right: 16),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            // userList[index]
                            //     .avatar
                            (owner.avatar != '')
                                ? owner.avatar
                                : 'https://i.imgur.com/RUgPziD.jpg'),
                        fit: BoxFit.cover),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  owner.userName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
