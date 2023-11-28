// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import 'instructionManual.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  TextEditingController emailOrNumberController = TextEditingController();
  final GlobalKey<FormState> emailOrNumberFormKey = GlobalKey<FormState>();

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
                    image: AssetImage(forgotPasswordBackground),
                    fit: BoxFit.cover),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32 + 44),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const InstructionManualScreen()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.topRight,
                        child:
                            const Icon(Iconsax.story, size: 24, color: black),
                      ),
                    ),
                    const SizedBox(height: 42),
                    Container(
                      alignment: Alignment.center,
                      child: const Image(
                          image:
                              AssetImage("assets/vectors/vectorLogoFerce.png")),
                    ),
                    const SizedBox(height: 82),
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Forgot Password!',
                        style: TextStyle(
                          fontFamily: 'Recoleta',
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 327 + 24,
                      alignment: Alignment.center,
                      child: const Text(
                        'Please enter the email address associated with your account. We will email you a link have OTP code to reset your password.',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Email / Phone Number',
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Form(
                      // key: emailFormKey,
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
                        child: TextFormField(
                            style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w400),
                            controller: emailOrNumberController,
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(left: 20, right: 12),
                              hintStyle: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: black.withOpacity(0.5)),
                              hintText: "Enter your email or your phone number",
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
                    const SizedBox(height: 27.5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const InstructionManualScreen()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.topRight,
                        child: const Text(
                          'Instruction Manual',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 27.5),
                    GestureDetector(
                      onTap: () {
                        // late bool emailValid = RegExp(
                        //         r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                        //     .hasMatch(emailOrNumberController.text.toString());
                        // if (emailValid == true) {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) =>
                        //               verificationEmailScreen()));
                        // } else {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) =>
                        //               verificationPhoneScreen()));
                        // }
                      },
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
                            "Send",
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
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 327 + 24,
                        height: 44,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            color: white,
                            border: Border.all(color: black)),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Cancel",
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
              )),
        ));
  }
}
