import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:social_network_app/constants/colors.dart';
import 'package:social_network_app/views/forgotPassword.dart';
import 'package:social_network_app/views/signUp.dart';

import '../../constants/images.dart';

class SignInScreen extends StatefulWidget with InputValidationMixin {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreen createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> with InputValidationMixin {
  bool isHiddenPassword = true;

  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  bool isLoading = false;

  Color notiColorEmail = red;
  Color notiColorPassword = red;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent),
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(signInBackground), fit: BoxFit.cover),
            ),
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 44 + 32),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Welcome!',
                        style: TextStyle(
                            fontFamily: 'Recoleta',
                            fontSize: 32,
                            color: black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 327 + 24,
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Say hi with Social Network’s World! Please enter your details and enjoy it.',
                        style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16,
                            color: black,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Email',
                            style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Form(
                          key: emailFormKey,
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
                                  hintText: "Enter your email",
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
                                          validator: (password) {
                                            if (isPasswordValid(
                                                password.toString())) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                setState(() {
                                                  notiColorPassword = green;
                                                });
                                              });
                                              return null;
                                            } else {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
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
                                                color: black.withOpacity(0.5)),
                                            hintText: "Enter your password",
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
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isHiddenPassword = !isHiddenPassword;
                                      });
                                    },
                                    child: (isHiddenPassword)
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
                                                border: Border.all(
                                                    color: gray, width: 1),
                                                borderRadius:
                                                    const BorderRadius.all(
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen()),
                            );
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 327 + 24,
                          height: 44,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: black,
                          ),
                          child: ElevatedButton(
                            //action navigate to dashboard screen
                            onPressed: () async {
                              // if (isLoading) return;
                              // setState(() {
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
                              // signIn(emailController.text,
                              //     passwordController.text, context);
                              // });
                              // await Future.delayed(Duration(seconds: 3));
                              // if (this.mounted) {
                              //   setState(() {
                              //     isLoading = false;
                              //   });
                              // }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: black.withOpacity(0.25),
                                elevation: 15,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                // maximumSize: Size.fromWidth(200),
                                minimumSize: const Size(327 + 24, 44),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
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
                                            child: CircularProgressIndicator(
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
                                      'Sign in',
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
                                    border: Border.all(width: 1.5, color: gray),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/vectors/vectorFacebook.png',
                                      width: 16.0,
                                      height: 16.0,
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
                                    border: Border.all(width: 1.5, color: gray),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/vectors/vectorGoogle.png',
                                      width: 16.0,
                                      height: 16.0,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don’t have an account?',
                              style: TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: gray),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()),
                                );
                              },
                              child: const Text(
                                ' Sign up for free',
                                style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: black),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(bottom: 34),
                      child: GestureDetector(
                        onTap: () {
                          // chuyển page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(32)),
                            color: white,
                          ),
                          child: const Icon(Iconsax.refresh_circle,
                              size: 36, color: black),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}

mixin InputValidationMixin {
  bool isEmailValid(String email) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(email);
  }

  bool isPasswordValid(String password) => password.length >= 6;
}
