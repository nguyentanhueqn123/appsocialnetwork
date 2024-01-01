// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';

// ignore: camel_case_types
class changingPasswordScreen extends StatefulWidget {
  const changingPasswordScreen({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _changingPasswordScreen createState() => _changingPasswordScreen();
}

// ignore: camel_case_types
class _changingPasswordScreen extends State<changingPasswordScreen> {
  bool isHiddenCurrentPassword = true;
  bool isHiddenNewPassword = true;
  bool isHiddenConfirmPassword = true;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent),
        child: Scaffold(
            body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(changingPasswordBackground),
                fit: BoxFit.cover),
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              children: [
                const SizedBox(height: 20 + 44),
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
                        // ignore: avoid_print
                        print('Menu');
                      },
                      child: const Icon(Iconsax.menu_14, size: 28),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Changing Password',
                    style: TextStyle(
                        fontFamily: 'Recoleta',
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: black),
                  ),
                ),
                const SizedBox(height: 8),
                const SizedBox(
                  width: 327 + 24,
                  child: Text(
                    'Your new password must be different from the current password and ensure the safety of password.',
                    style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: black),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  alignment: Alignment.topLeft,
                  width: 327 + 24,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Current Password',
                          style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              color: black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Form(
                            // key: passwordFormKey,
                            child: Container(
                              width: 275 + 16,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: gray,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.topLeft,
                              child: TextFormField(
                                  style: const TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 16,
                                      color: black,
                                      fontWeight: FontWeight.w400),
                                  controller: currentPasswordController,
                                  obscureText: isHiddenCurrentPassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  autofillHints: const [AutofillHints.password],
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 12),
                                    hintStyle: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: black.withOpacity(0.5)),
                                    hintText: "Enter your password",
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
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isHiddenCurrentPassword =
                                    !isHiddenCurrentPassword;
                              });
                            },
                            child: (isHiddenCurrentPassword)
                                ? Container(
                                    height: 44,
                                    width: 44,
                                    decoration: const BoxDecoration(
                                        color: black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: const Icon(
                                      Iconsax.eye,
                                      size: 20,
                                      color: white,
                                    ),
                                  )
                                : Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border:
                                            Border.all(color: gray, width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: const Icon(
                                      Iconsax.eye_slash,
                                      size: 24,
                                      color: black,
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  alignment: Alignment.topLeft,
                  width: 327 + 24,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'New Password',
                          style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              color: black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Form(
                            // key: passwordFormKey,
                            child: Container(
                              width: 275 + 16,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: gray,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.topLeft,
                              child: TextFormField(
                                  style: const TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 16,
                                      color: black,
                                      fontWeight: FontWeight.w400),
                                  controller: newPasswordController,
                                  obscureText: isHiddenNewPassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  autofillHints: const [AutofillHints.password],
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 12),
                                    hintStyle: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: black.withOpacity(0.5)),
                                    hintText: "Enter your password",
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
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isHiddenNewPassword = !isHiddenNewPassword;
                              });
                            },
                            child: (isHiddenNewPassword)
                                ? Container(
                                    height: 44,
                                    width: 44,
                                    decoration: const BoxDecoration(
                                        color: black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: const Icon(
                                      Iconsax.eye,
                                      size: 20,
                                      color: white,
                                    ),
                                  )
                                : Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border:
                                            Border.all(color: gray, width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: const Icon(
                                      Iconsax.eye_slash,
                                      size: 24,
                                      color: black,
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  alignment: Alignment.topLeft,
                  width: 327 + 24,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Confirm New Password',
                          style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 16,
                              color: black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Form(
                            // key: confirmPasswordFormKey,
                            child: Container(
                              width: 275 + 16,
                              height: 44,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: gray,
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.topLeft,
                              child: TextFormField(
                                  style: const TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 16,
                                      color: black,
                                      fontWeight: FontWeight.w400),
                                  controller: confirmNewPasswordController,
                                  obscureText: isHiddenConfirmPassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  autofillHints: const [AutofillHints.password],
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 12),
                                    hintStyle: TextStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: black.withOpacity(0.5)),
                                    hintText: "Enter your confirm password",
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
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isHiddenConfirmPassword =
                                    !isHiddenConfirmPassword;
                              });
                            },
                            child: (isHiddenConfirmPassword)
                                ? Container(
                                    height: 44,
                                    width: 44,
                                    decoration: const BoxDecoration(
                                        color: black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: const Icon(
                                      Iconsax.eye,
                                      size: 20,
                                      color: white,
                                    ),
                                  )
                                : Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border:
                                            Border.all(color: gray, width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: const Icon(
                                      Iconsax.eye_slash,
                                      size: 24,
                                      color: black,
                                    ),
                                  ),
                          )
                        ],
                      ),
                      const SizedBox(height: 32),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 327 + 24,
                          height: 44,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: black,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              "Change",
                              style: TextStyle(
                                color: white,
                                fontFamily: 'Urbanist',
                                fontSize: 18,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          currentPasswordController.text = '';
                          newPasswordController.text = '';
                          confirmNewPasswordController.text = '';
                        },
                        child: Container(
                          width: 327 + 24,
                          height: 44,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.transparent,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                color: black,
                                fontFamily: 'Urbanist',
                                fontSize: 18,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
