import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:email_otp/email_otp.dart';
import 'package:social_network_app/constants/images.dart';

import '../../constants/colors.dart';

class SignUpScreen extends StatefulWidget with InputValidationMixin {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> with InputValidationMixin {
  bool isSendVerifyCodeEmail = false;
  bool isSendVerifyCodePhone = false;
  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;
  bool isHiddenEmailCode = true;
  bool isHiddenPhoneCode = true;
  bool isChecked = false;

  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> confirmPasswordFormKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> usernameFormKey = GlobalKey<FormState>();

  TextEditingController emailVerificationController = TextEditingController();
  final GlobalKey<FormState> emailVerificationFormKey = GlobalKey<FormState>();

  bool isLoading = false;

  final bool _enabledPhone = true;
  bool _enabledEmail = true;

  bool submitValid = false;

  Color notiColorEmail = red;
  Color notiColorName = red;
  Color notiColorPhoneNumber = red;
  Color notiColorPassword = red;
  EmailOTP myauth = EmailOTP();

  @override
  void initState() {
    super.initState();
    // Initialize the package
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Create validation

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
                  image: AssetImage(signUpBackground), fit: BoxFit.cover),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(top: 80, left: 320),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(32)),
                color: black,
              ),
              child: const Icon(
                Iconsax.refresh_circle,
                size: 36,
                color: white,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 72 + 44, left: 24, right: 24),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign up!',
                  style: TextStyle(
                      fontFamily: 'Recoleta',
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: black),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: 327 + 24,
                  child: Text(
                    'Only one step left to be part of the Social Network'
                    's World community!',
                    style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: black),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 72 + 44 + 32 + 8 + 32 + 7 + 32),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    children: [
                      // SizedBox(height: 32),
                      Container(
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 65,
                              child: Divider(
                                color: gray,
                                thickness: 0.5,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "personal information",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                color: gray,
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            SizedBox(
                              width: 65,
                              child: Divider(
                                color: gray,
                                thickness: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 327 + 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Email",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                color: black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Form(
                                  key: emailFormKey,
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
                                        //validator
                                        validator: (email) {
                                          if (isEmailValid(email.toString())) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              setState(() {
                                                notiColorEmail = green;
                                              });
                                            });
                                            return null;
                                          } else {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              setState(() {
                                                notiColorEmail = red;
                                              });
                                            });
                                            return '';
                                          }
                                        },
                                        controller: emailController,
                                        autofillHints: const [
                                          AutofillHints.email
                                        ],
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
                                              left: 20, right: 12),
                                          hintStyle: TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: black.withOpacity(0.5)),
                                          hintText: "Enter your email",
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
                                const SizedBox(width: 8),
                                (_enabledEmail)
                                    ? GestureDetector(
                                        onTap: () async {
                                          // if (emailController.text == '') {
                                          //   showSnackBar(
                                          //       context,
                                          //       "Please fill your email",
                                          //       'error');
                                          // } else {
                                          //   myauth.setConfig(
                                          //     appEmail:
                                          //         "binkstore2022@gmail.com",
                                          //     appName: "Email OTP",
                                          //     userEmail: emailController.text,
                                          //   );
                                          //   if (await myauth.sendOTP() ==
                                          //       true) {
                                          //     ScaffoldMessenger.of(context)
                                          //         .showSnackBar(const SnackBar(
                                          //       content:
                                          //           Text("OTP has been sent"),
                                          //     ));
                                          //   } else {
                                          //     ScaffoldMessenger.of(context)
                                          //         .showSnackBar(const SnackBar(
                                          //       content: Text(
                                          //           "Oops, OTP send failed"),
                                          //     ));
                                          //   }
                                          //   setState(() {
                                          //     _enabledEmail = false;
                                          //   });
                                          // }
                                        },
                                        child: Container(
                                          height: 44,
                                          width: 44,
                                          decoration: const BoxDecoration(
                                              color: black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: const Icon(
                                            Iconsax.scan,
                                            size: 20,
                                            color: white,
                                          ),
                                        ))
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _enabledEmail = true;
                                          });
                                        },
                                        child: Container(
                                          height: 44,
                                          width: 44,
                                          decoration: const BoxDecoration(
                                              color: white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: const Icon(
                                            Iconsax.repeat,
                                            size: 20,
                                            color: black,
                                          ),
                                        ))
                              ],
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
                                      'Password',
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
                                        key: passwordFormKey,
                                        child: Container(
                                          width: 275 + 16,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              validator: (password) {
                                                if (isPasswordValid(
                                                    password.toString())) {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    setState(() {
                                                      notiColorPassword = green;
                                                    });
                                                  });
                                                  return null;
                                                } else {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    setState(() {
                                                      notiColorPassword = red;
                                                    });
                                                  });
                                                  return '';
                                                }
                                              },
                                              controller: passwordController,
                                              obscureText: isHiddenPassword,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              autofillHints: const [
                                                AutofillHints.password
                                              ],
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 20, right: 12),
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        black.withOpacity(0.5)),
                                                hintText: "Enter your password",
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                            isHiddenPassword =
                                                !isHiddenPassword;
                                          });
                                        },
                                        child: (isHiddenPassword)
                                            ? Container(
                                                height: 44,
                                                width: 44,
                                                decoration: const BoxDecoration(
                                                    color: black,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                                                    border: Border.all(
                                                        color: gray, width: 1),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                                      'Confirm Password',
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
                                        key: confirmPasswordFormKey,
                                        child: Container(
                                          width: 275 + 16,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              controller:
                                                  confirmPasswordController,
                                              obscureText:
                                                  isHiddenConfirmPassword,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              autofillHints: const [
                                                AutofillHints.password
                                              ],
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 20, right: 12),
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        black.withOpacity(0.5)),
                                                hintText:
                                                    "Enter your confirm password",
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                                                    border: Border.all(
                                                        color: gray, width: 1),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 65,
                                    child: Divider(
                                      color: gray,
                                      thickness: 0.5,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "authentication",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      color: gray,
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  SizedBox(
                                    width: 65,
                                    child: Divider(
                                      color: gray,
                                      thickness: 0.5,
                                    ),
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
                                      'Email Verificatiion',
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
                                        key: emailVerificationFormKey,
                                        child: Container(
                                          width: 275 + 16,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                              controller:
                                                  emailVerificationController,
                                              obscureText: isHiddenEmailCode,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 20, right: 12),
                                                hintStyle: TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        black.withOpacity(0.5)),
                                                hintText:
                                                    "Enter your email code verification",
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                            isHiddenEmailCode =
                                                !isHiddenEmailCode;
                                          });
                                        },
                                        child: (isHiddenEmailCode)
                                            ? Container(
                                                height: 44,
                                                width: 44,
                                                decoration: const BoxDecoration(
                                                    color: black,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                                                    border: Border.all(
                                                        color: gray, width: 1),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
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
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                Container(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isChecked = !isChecked;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      height: 16,
                                      width: 16,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: isChecked
                                            ? black
                                            : Colors.transparent,
                                        border:
                                            Border.all(color: gray, width: 1),
                                      ),
                                      child: isChecked
                                          ? const Icon(
                                              Icons.check,
                                              color: white,
                                              size: 12,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Agree to ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  "Terms & Conditions",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: black,
                                    fontFamily: 'Urbanist',
                                    fontSize: 14,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: 327 + 24,
                              height: 44,
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
                                    isLoading = true;
                                    // controlSignUp();
                                  });
                                  await Future.delayed(Duration(seconds: 3));
                                  if (this.mounted) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shadowColor: black.withOpacity(0.25),
                                    backgroundColor: Colors.transparent,
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
                                    ? const SizedBox(
                                        height: 48,
                                        width: 200,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
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
                                          'Sign up',
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
                            const SizedBox(height: 24),
                            Container(
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 65,
                                    child: Divider(
                                      color: gray,
                                      thickness: 0.5,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "or continue with",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      color: gray,
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  SizedBox(
                                    width: 65,
                                    child: Divider(
                                      color: gray,
                                      thickness: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: 327 + 24,
                              height: 44,
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Container(
                                    width: 156,
                                    height: 44,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border:
                                            Border.all(width: 1.5, color: gray),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Image.asset(
                                            'assets/vectors/vectorFacebook.png',
                                            width: 16.0,
                                            height: 16.0,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Facebook',
                                          style: TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 156,
                                    height: 44,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border:
                                            Border.all(width: 1.5, color: gray),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Image.asset(
                                            'assets/vectors/vectorGoogle.png',
                                            width: 16.0,
                                            height: 16.0,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Google',
                                          style: TextStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: black),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                            Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'To be able to register, you must agree to our',
                                style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: gray),
                              ),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Terms of Use',
                                  style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: black),
                                ),
                                Text(
                                  ' and',
                                  style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: gray),
                                ),
                                Text(
                                  ' Privacy Policy',
                                  style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 67 + 44),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

mixin InputValidationMixin {
  bool isEmailValid(String email) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(email);
  }

  bool isNameValid(String name) => name.length >= 3;

  bool isPasswordValid(String password) => password.length >= 6;

  bool isPhoneNumberValid(String phoneNumber) {
    RegExp regex = RegExp(r'(^(?:[+84])?[0-9]{10,12}$)');
    return regex.hasMatch(phoneNumber);
  }
}
