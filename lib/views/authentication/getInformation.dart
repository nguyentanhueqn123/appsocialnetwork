// ignore_for_file: file_names

import 'dart:io' show File;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app/views/authentication/signIn.dart';
import 'package:social_network_app/views/snackBarWidget.dart';
import 'package:social_network_app/views/authentication/widget_auth.dart';

import '../../constants/colors.dart';
import '../../repository/cloud_data_management.dart';
import 'loadingWidget.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  bool _isLoading = false;

  final GlobalKey<FormState> _infoKey = GlobalKey<FormState>();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  File? _image;
  final CloudStoreDataManagement _cloudStoreDataManagement =
      CloudStoreDataManagement();
  pickImage(ImageSource source) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: false,
    );
    // ignore: avoid_print
    print('result');
    // ignore: avoid_print
    print(result);
    if (result != null) {
      // ignore: unused_local_variable
      Uint8List? fileBytes = result.files.first.bytes;
      // ignore: unused_local_variable
      String fileName = result.files.first.name;
      return File(result.files.first.path.toString());
    }
    // ignore: avoid_print
    print('No Image Selected');
  }

  selectImage() async {
    File im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _fullname.dispose();
    _username.dispose();
    _phone.dispose();
    _bio.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _infoKey,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('assets/images/background/signInBackground.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: _isLoading
                ? const LoadingWidget()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 62,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Update Your Profile",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: black,
                              fontFamily: 'Recoleta',
                              fontSize: 24,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      GestureDetector(
                        onTap: selectImage,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Row(
                                children: [
                                  _image != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.file(
                                            _image!,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : ClipRRect(
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(color: black),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Iconsax.camera,
                                                size: 24,
                                                color: black,
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Full Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: black,
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InformationTextFormField(
                        textEditingController: _fullname,
                        hintText: '  Enter your full name',
                        size: size,
                        validator: (inputVal) {
                          if (inputVal!.isEmpty) {
                            showSnackBar(
                                context,
                                'Password must be at least 6 characters',
                                'error');
                            return '';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "User Name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: black,
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InformationTextFormField(
                        textEditingController: _username,
                        hintText: '  Enter your user name',
                        size: size,
                        validator: (inputVal) {
                          if (inputVal!.isEmpty) {
                            showSnackBar(
                                context,
                                'Password must be at least 6 characters',
                                'error');
                            return '';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Phone number",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: black,
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InformationTextFormField(
                        textEditingController: _phone,
                        hintText: '  Enter your phone number',
                        size: size,
                        validator: (inputVal) {
                          if (inputVal!.isEmpty) {
                            showSnackBar(
                                context,
                                'Password must be at least 10 characters',
                                'error');
                            return '';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Biography",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: black,
                            fontFamily: 'Urbanist',
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InformationTextFormField(
                        textEditingController: _bio,
                        hintText: '  Enter your biography',
                        size: size,
                        validator: (inputVal) {
                          if (inputVal!.isEmpty) {
                            showSnackBar(
                                context,
                                'Password must be at least 10 characters',
                                'error');
                            return '';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ConFirmButton(context, 'Confirm', size),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget ConFirmButton(BuildContext context, String buttonName, Size size) {
    return Padding(
      padding: const EdgeInsets.only(left: 122, right: 122),
      child: GestureDetector(
        onTap: () async {
          if (_infoKey.currentState!.validate()) {
            // ignore: avoid_print
            print('Validated');
            SystemChannels.textInput.invokeMethod('TextInput.hide');

            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }

            String msg = '';

            final bool canRegisterNewUser = await _cloudStoreDataManagement
                .checkThisUserAlreadyPresentOrNot(userName: _username.text);

            if (!canRegisterNewUser) {
              msg = 'User Name Already Present';
            } else {
              final bool userEntryResponse =
                  await _cloudStoreDataManagement.registerNewUser(
                fullname: _fullname.text,
                userName: _username.text,
                phone: _phone.text,
                bio: _bio.text,
                file: _image!,
              );

              if (userEntryResponse) {
                msg = 'Create account Successfully';

                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SignInScreen(),
                    ),
                    (route) => false);
                // ignore: use_build_context_synchronously
                showSnackBar(context, msg, 'success');
              } else {
                msg = 'User Data Not Entry Successfully';
              }
              // ignore: use_build_context_synchronously
              showSnackBar(context, msg, 'error');
            }

            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          } else {
            // ignore: avoid_print
            print('Not Validated');
          }
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
            child: Text(
              buttonName,
              style: const TextStyle(
                color: white,
                fontFamily: 'Urbanist',
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
