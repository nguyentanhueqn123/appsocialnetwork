// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/colors.dart';
import '../../constants/images.dart';
import '../../models/postModel.dart';
import '../dashboard/comment.dart';
import '../dashboard/postVideo.dart';

// ignore: camel_case_types
class postListView extends StatefulWidget {
  final String? position;
  final String? uid;

  const postListView({Key? key, this.position, this.uid}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _postListView createState() => _postListView();
}

// ignore: camel_case_types
class _postListView extends State<postListView> {
  bool liked = false;
  bool silent = false;
  bool isVideo = false;

  List<PostModel> postList = [];
  Future getPostList() async {
    FirebaseFirestore.instance
        .collection("posts")
        .orderBy('timeCreate', descending: true)
        .snapshots()
        .listen((value) {
      setState(() {
        postList.clear();
        for (var element in value.docs) {
          postList.add(PostModel.fromDocument(element.data()));
        }
      });
    });
  }

  late DateTime timeCreate = DateTime.now();

  Future like(String postId, List likes) async {
    if (likes.contains(widget.uid)) {
      FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([widget.uid.toString()])
      });
    } else {
      FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([widget.uid.toString()])
      });
    }
  }

  @override
  void initState() {
    getPostList();
    // ignore: avoid_print
    print(widget.position.toString());
    super.initState();
  }

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
                image: AssetImage(profileBackground), fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              IconButton(
                padding: const EdgeInsets.only(left: 28, top: 32),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Iconsax.arrow_square_left,
                    size: 28, color: black),
              ),
              Container(
                  margin: const EdgeInsets.only(
                      top: 32 + 24 + 16, left: 16, right: 16, bottom: 56),
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 16),
                      itemCount: postList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.network(
                                            postList[index].ownerAvatar,
                                            width: 32,
                                            height: 32,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        postList[index].ownerUsername,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Urbanist',
                                            fontWeight: FontWeight.w600,
                                            color: black),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.topRight,
                                  child: const Icon(Iconsax.more,
                                      size: 24, color: black),
                                )
                              ],
                            ),
                            (postList[index].urlImage != '')
                                ? Container(
                                    width: 360,
                                    height: 340,
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        postList[index].urlImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : postVideoWidget(context,
                                    src: postList[index].urlVideo),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        liked = !liked;
                                        like(postList[index].id,
                                            postList[index].likes);
                                      });
                                    },
                                    icon: (postList[index]
                                            .likes
                                            .contains(widget.uid))
                                        ? Container(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            alignment: Alignment.topRight,
                                            child: const Icon(Iconsax.like_15,
                                                size: 24, color: pink),
                                          )
                                        : Container(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            alignment: Alignment.topRight,
                                            child: const Icon(Iconsax.like_1,
                                                size: 24, color: black),
                                          )),
                                GestureDetector(
                                  onTap: () {
                                    //likes post
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.only(left: 8),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        (postList[index].likes.isEmpty)
                                            ? '0'
                                            : postList[index]
                                                .likes
                                                .length
                                                .toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: black,
                                          fontFamily: 'Urbanist',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                ),
                                IconButton(
                                  padding: const EdgeInsets.only(left: 8),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                atCommentScreen(
                                                  required,
                                                  uid: widget.uid.toString(),
                                                  postId: postList[index].id,
                                                  ownerId:
                                                      postList[index].idUser,
                                                ))));
                                  },
                                  icon: const Icon(Iconsax.message_text,
                                      size: 24, color: black),
                                ),
                                // Container(
                                //     margin: EdgeInsets.only(left: 8),
                                //     alignment: Alignment.centerLeft,
                                //     child: Text(
                                //       '24',
                                //       style: TextStyle(
                                //         fontSize: 16,
                                //         color: black,
                                //         fontFamily: 'Urbanist',
                                //         fontWeight: FontWeight.w600,
                                //       ),
                                //     )),
                                const Spacer(),
                                (isVideo)
                                    ? IconButton(
                                        onPressed: () {
                                          //save post
                                        },
                                        icon: (silent == true)
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    right: 8),
                                                child: const Icon(
                                                    Iconsax.volume_slash,
                                                    size: 24,
                                                    color: gray),
                                              )
                                            : Container(
                                                margin: const EdgeInsets.only(
                                                    right: 8),
                                                child: const Icon(
                                                    Iconsax.volume_high,
                                                    size: 24,
                                                    color: black),
                                              ))
                                    : Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.transparent),
                                      )
                              ],
                            ),
                            // SizedBox(height: 12),
                            GestureDetector(
                              onTap: () {
                                //likes post
                              },
                              child: Container(
                                  width: 327 + 24,
                                  margin: const EdgeInsets.only(left: 8),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    postList[index].caption,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: black,
                                        fontFamily: 'Urbanist',
                                        fontWeight: FontWeight.w600,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  )),
                            ),
                            const SizedBox(height: 8),
                            Container(
                                margin: const EdgeInsets.only(left: 8),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  postList[index].timeCreate,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: gray,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ],
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
