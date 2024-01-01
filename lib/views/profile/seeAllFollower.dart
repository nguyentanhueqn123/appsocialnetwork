// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../models/userModel.dart';
import 'profile.dart';

// ignore: camel_case_types, must_be_immutable
class seeAll extends StatefulWidget {
  late List idUser;
  seeAll({Key? key, required this.idUser}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _seeAll createState() => _seeAll(idUser);
}

// ignore: camel_case_types
class _seeAll extends State<seeAll> {
  List<UserModel> userSearch = [];
  List<UserModel> userList = [];
  List idUser = [];

  _seeAll(this.idUser);
  Future searchName() async {
    FirebaseFirestore.instance.collection("users").snapshots().listen((value) {
      setState(() {
        userSearch.clear();
        userList.clear();
        for (var element in value.docs) {
          userSearch.add(UserModel.fromDocument(element.data()));
        }
        for (var element1 in idUser) {
          for (var element2 in userSearch) {
            if (element1 == element2.id) {
              userList.add(element2);
            }
          }
        }
      });
    });
  }

  @override
  void initState() {
    searchName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent),
      child: SafeArea(
          child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(profileBackground), fit: BoxFit.cover),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Iconsax.back_square, size: 28),
                      ),
                      const Spacer(),
                      Container()
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'All Followers',
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
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8))),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  atProfileScreen(
                                                    ownerId: userList[index].id,
                                                  ))));
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
                                                    (userList[index].avatar !=
                                                            '')
                                                        ? userList[index].avatar
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
                                              Text(
                                                userList[index].userName,
                                                style: const TextStyle(
                                                  color: black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                userList[index].email,
                                                style: const TextStyle(
                                                  color: gray,
                                                  fontWeight: FontWeight.w400,
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
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
