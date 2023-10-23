import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_network_app/constants/colors.dart';
import 'package:social_network_app/constants/images.dart';

class InstructionManualScreen extends StatefulWidget {
  const InstructionManualScreen({Key? key}) : super(key: key);
  @override
  _InstructionManualScreen createState() => _InstructionManualScreen();
}

class _InstructionManualScreen extends State<InstructionManualScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent),
        child: Scaffold(
          body: Container(
            width: 375 + 24,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(instructionManualBackground),
                  fit: BoxFit.cover),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32 + 44),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Instruction Manual',
                      style: TextStyle(
                          fontFamily: 'Recoleta',
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: black),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: 375,
                    child: Text(
                      'To be able to recover your password now, please follow these steps with us:',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: black),
                    ),
                  ),
                  const SizedBox(
                    width: 327 + 24,
                    child: Divider(
                      color: gray,
                      thickness: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        color: black,
                        fontWeight: FontWeight.w300,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Step 1: ',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Entering your registered email in the textfield.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        color: black,
                        fontWeight: FontWeight.w300,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Step 2: ',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: 'Pressing the',
                        ),
                        TextSpan(
                          text: ' Send',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' button to recover the password',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        color: black,
                        fontWeight: FontWeight.w300,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Step 3: ',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Accessing email address you’ve used to register and check the',
                        ),
                        TextSpan(
                          text: ' OTP code',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' has been sent!',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        color: black,
                        fontWeight: FontWeight.w300,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Step 4: ',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' Entering the ',
                        ),
                        TextSpan(
                          text: ' OTP code',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' new password and authentication of login password ',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 64),
                  const SizedBox(
                    width: 327 + 24,
                    child: Divider(
                      color: gray,
                      thickness: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 185,
                    alignment: Alignment.center,
                    child: const Text(
                      'For any questions or problems please email us at',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          color: black,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 185,
                    alignment: Alignment.center,
                    child: const Text(
                      'HelpFerce@gmail.com',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 18,
                          color: black,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 64),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
                          "Understand",
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
                ],
              ),
            ),
          ),
        ));
  }
}
