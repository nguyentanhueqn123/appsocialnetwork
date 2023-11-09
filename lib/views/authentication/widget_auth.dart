import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:social_network_app/constants/colors.dart';
import 'package:social_network_app/views/authentication/signUp.dart';

Widget EmailTextFormField(
    {required String hintText,
    required TextEditingController textEditingController,
    required Size size,
    required String? Function(String?)? validator,
    required double padding}) {
  return Container(
    margin: const EdgeInsets.only(left: 32, right: 32),
    width: size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: white,
    ),
    child: TextFormField(
      cursorColor: gray,
      controller: textEditingController,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      validator: validator,
      // decoration: InputDecoration(
      //   hintText: hintText,
      //   hintStyle: TextStyle(color: gray),
      //   border: InputBorder.none,
      // ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 8, right: 8),
        hintStyle: const TextStyle(
          color: gray,
          fontFamily: 'Urbanist',
          fontSize: 20,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
        ),
        hintText: "Enter your Email",
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorStyle: const TextStyle(
          color: Colors.transparent,
          fontSize: 0,
          height: 0,
        ),
      ),
    ),
  );
}

Widget PasswordTextFormField({
  required BuildContext context,
  required String hintText,
  required String? Function(String?)? validator,
  required TextEditingController textEditingController,
  required Size size,
  required bool isHiddenPassword,
}) {
  return Container(
    margin: const EdgeInsets.only(left: 32, right: 32),
    width: size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: white,
    ),
    child: TextFormField(
      validator: validator,
      cursorColor: gray,
      controller: textEditingController,
      obscureText: isHiddenPassword,
      keyboardType: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        suffixIcon: InkWell(
            onTap: () {
              isHiddenPassword = !isHiddenPassword;
            },
            child: isHiddenPassword
                ? Stack(alignment: Alignment.centerRight, children: [
                    Container(
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Iconsax.eye, size: 24, color: gray))
                  ])
                : Stack(alignment: Alignment.centerRight, children: [
                    Container(
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Iconsax.eye_slash,
                            size: 24, color: gray))
                  ])),
        contentPadding: const EdgeInsets.only(left: 8, right: 8),
        hintStyle: const TextStyle(
          fontSize: 12,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          color: gray,
        ),
        hintText: "Enter your Password",
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorStyle: const TextStyle(
          color: Colors.transparent,
          fontSize: 0,
          height: 0,
        ),
      ),
    ),
  );
}

Widget switchAnotherAuthScreen(
    BuildContext context, String buttonNameFirst, String buttonNameLast) {
  return GestureDetector(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          buttonNameFirst,
          style: const TextStyle(
            color: white,
            fontSize: 16.0,
          ),
        ),
        Text(
          buttonNameLast,
          style: const TextStyle(
            color: red,
            fontFamily: 'Urbanist',
            fontSize: 20,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
    onTap: () {
      if (buttonNameLast == "Sign up for free") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SignUpScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SignUpScreen()),
        );
      }
    },
  );
}

Widget RecoveryTextFormField(
    {required String hintText,
    required String? Function(String?)? validator,
    required TextEditingController textEditingController,
    required Size size}) {
  return Container(
    margin: const EdgeInsets.only(left: 16, right: 16),
    width: size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: gray,
    ),
    child: TextFormField(
      validator: validator,
      cursorColor: white,
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: white),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget InfomationTextFormField({
  required String hintText,
  required TextEditingController textEditingController,
  required Size size,
  required String? Function(String?)? validator,
}) {
  return Container(
    margin: const EdgeInsets.only(left: 15, right: 15),
    width: size.width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
        border: Border.all(color: black)),
    child: TextFormField(
      cursorColor: white,
      controller: textEditingController,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      validator: validator,
      // decoration: InputDecoration(
      //   hintText: hintText,
      //   hintStyle: TextStyle(color: gray),
      //   border: InputBorder.none,
      // ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 8, right: 8),
        hintStyle: const TextStyle(
          color: black,
          fontFamily: 'Urbanist',
          fontSize: 16,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
        hintText: hintText,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorStyle: const TextStyle(
          color: Colors.transparent,
          fontSize: 0,
          height: 0,
        ),
      ),
    ),
  );
}
