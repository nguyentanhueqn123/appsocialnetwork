// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../models/userModel.dart';

// ignore: camel_case_types, must_be_immutable
class atEditProfileScreen extends StatefulWidget {
  String uid;
  atEditProfileScreen(required, {Key? key, required this.uid})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _atEditProfileScreen createState() => _atEditProfileScreen(uid);
}

// ignore: camel_case_types
class _atEditProfileScreen extends State<atEditProfileScreen>
    with SingleTickerProviderStateMixin {
  String uid = '';
  _atEditProfileScreen(uid);

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
        // ignore: avoid_print
        print(user.userName);
        usernameController.text = user.userName;
      });
    });
  }

  TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> usernameFormKey = GlobalKey<FormState>();

  TextEditingController websiteController = TextEditingController();
  final GlobalKey<FormState> websiteFormKey = GlobalKey<FormState>();

  TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> bioFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    getUserDetail();
    super.initState();
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
              image: DecorationImage(
                  image: AssetImage(profileBackground), fit: BoxFit.cover),
            ),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 24, right: 24, top: 20 + 20),
                      child: Column(children: [
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'Editing Profile',
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
                            const SizedBox(height: 32),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 56,
                                    width: 56,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: black, width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, left: 4),
                                    height: 56,
                                    width: 56,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: gray, width: 0.5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        'https://i.imgur.com/fRjRPRc.jpg',
                                        fit: BoxFit.cover,
                                        height: 56,
                                        width: 56,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            Container(
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'User Name',
                                style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 16,
                                    color: black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Form(
                              key: usernameFormKey,
                              child: Container(
                                width: 327 + 24,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
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
                                      return null;

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
                                    controller: usernameController,
                                    keyboardType: TextInputType.emailAddress,
                                    autofillHints: const [AutofillHints.email],
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 16, right: 12),
                                      hintStyle: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: black.withOpacity(0.5)),
                                      hintText: "Enter your username",
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorStyle: const TextStyle(
                                        color: Colors.transparent,
                                        fontSize: 0,
                                        height: 0,
                                      ),
                                    )),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'Website',
                                style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 16,
                                    color: black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Form(
                              key: websiteFormKey,
                              child: Container(
                                width: 327 + 24,
                                height: 44,
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
                                      return null;

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
                                    controller: websiteController,
                                    keyboardType: TextInputType.emailAddress,
                                    autofillHints: const [AutofillHints.email],
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 20, right: 12),
                                      hintStyle: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: black.withOpacity(0.5)),
                                      hintText: "Enter your website",
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorStyle: const TextStyle(
                                        color: Colors.transparent,
                                        fontSize: 0,
                                        height: 0,
                                      ),
                                    )),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'Biography',
                                style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 16,
                                    color: black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Form(
                              key: bioFormKey,
                              child: Container(
                                width: 327 + 24,
                                height: 44,
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
                                      return null;

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
                                    controller: bioController,
                                    keyboardType: TextInputType.emailAddress,
                                    autofillHints: const [AutofillHints.email],
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 20, right: 12),
                                      hintStyle: TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: black.withOpacity(0.5)),
                                      hintText: "Enter your biology",
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorStyle: const TextStyle(
                                        color: Colors.transparent,
                                        fontSize: 0,
                                        height: 0,
                                      ),
                                    )),
                              ),
                            ),
                            Container(
                              width: 327 + 24,
                              height: 44,
                              margin: const EdgeInsets.only(top: 32),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: black,
                              ),
                              child: ElevatedButton(
                                //action navigate to dashboard screen
                                onPressed: () async {
                                  if (isLoading) return;
                                  setState(() {
                                    // isLoading = true;
                                    // if (emailFormKey.currentState!.validate() &&
                                    //     passwordFormKey.currentState!
                                    //         .validate()) {
                                    //   signIn(emailController.text,
                                    //       passwordController.text, context);
                                    // } else {
                                    //   showSnackBar(
                                    //       context,
                                    //       'Please check your information!',
                                    //       'error');
                                    //   ;
                                    // }
                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => navigationBar(
                                    //             required,
                                    //             uid: 'h')));
                                  });
                                  await Future.delayed(
                                      const Duration(seconds: 3));
                                  if (mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: black,
                                    shadowColor: black.withOpacity(0.25),
                                    elevation: 15,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    // maximumSize: Size.fromWidth(200),
                                    minimumSize: const Size(327 + 24, 44),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0)),
                                    // BorderRadius.all(Radius.circular(16)),
                                    textStyle: const TextStyle(
                                        color: white,
                                        fontFamily: 'SFProText',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18)),
                                child: isLoading
                                    ? SizedBox(
                                        height: 48,
                                        width: 200,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                        color: white)),
                                            SizedBox(width: 16),
                                            Text(
                                              "Please Wait...",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Urbanist',
                                                fontWeight: FontWeight.w600,
                                                color: white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Save',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w600,
                                            color: white,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: 327 + 24,
                              height: 44,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.transparent,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                      color: black,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ]))))
        ])));
  }
}
