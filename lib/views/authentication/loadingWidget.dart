// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:social_network_app/constants/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SpinKitSpinningLines(
            color: black,
            size: 50.0,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Loading...',
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 16,
              color: black,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
