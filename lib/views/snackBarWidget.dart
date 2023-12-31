// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:social_network_app/constants/colors.dart';

void showSnackBar(context, text, category) {
  final snackBar = SnackBar(
    content: GestureDetector(
      onTap: () => ScaffoldMessenger.of(context)..hideCurrentSnackBar(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 4),
          (category == 'success')
              ? const Icon(Iconsax.tick_square, size: 24, color: black)
              : ((category == 'error')
                  ? const Icon(Iconsax.close_square, size: 24, color: black)
                  : const Icon(Iconsax.danger, size: 24, color: black)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontFamily: 'Urbanist',
                  color: black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    ),
    backgroundColor: white,
    duration: const Duration(seconds: 3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 24),
    behavior: SnackBarBehavior.floating,
    elevation: 10,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
