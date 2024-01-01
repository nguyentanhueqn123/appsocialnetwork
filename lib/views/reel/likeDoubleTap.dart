// ignore_for_file: file_names

import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class LikeIcon extends StatelessWidget {
  Future<int> tempFuture() async {
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: tempFuture(),
        builder: (context, snapshot) =>
            snapshot.connectionState != ConnectionState.done
                ? const Icon(Icons.favorite, size: 100, color: Colors.red)
                : const SizedBox(),
      ),
    );
  }
}
