import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ImageViewer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flare_flutter/flare_actor.dart';

class ImagePost extends StatefulWidget {
  const ImagePost(
      {required this.media,
        required this.username,
        required this.location,
        required this.description,
        required this.likes,
        required this.postId,
        required this.ownerId});

  factory ImagePost.fromJson(Map<String, dynamic> data) {
    return ImagePost(
      username: data['username'],
      location: data['location'],
      media: data['media'],
      likes: data['likes'],
      description: data['description'],
      postId: data['postId'],
      ownerId: data['ownerId'],
    );
  }

  int getLikeCount(var likes) {
    if (likes == null) {
      return 0;
    }
// issue is below
    var vals = likes.values;
    int count = 0;
    for (var val in vals) {
      if (val == true) {
        count = count + 1;
      }
    }

    return count;
  }

  final List<String> media;
  final String username;
  final String location;
  final String description;
  final likes;
  final String postId;
  final String ownerId;

  _ImagePost createState() => _ImagePost(
    media: this.media,
    username: this.username,
    location: this.location,
    description: this.description,
    likes: this.likes,
    likeCount: getLikeCount(this.likes),
    ownerId: this.ownerId,
    postId: this.postId,
  );
}

class _ImagePost extends State<ImagePost> {
  final List<String> media;
  final String username;
  final String location;
  final String description;
  Map? likes;
  int likeCount;
  final String postId;
  bool liked = false;
  final String ownerId;

  bool showHeart = false;

  TextStyle boldStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  // var reference = FirebaseFirestore.instance.collection('insta_posts');

  _ImagePost(
      {required this.media,
        required this.username,
        required this.location,
        required this.description,
        required this.likes,
        required this.postId,
        required this.likeCount,
        required this.ownerId});

  GestureDetector buildLikeIcon() {
    Color? color;
    IconData icon;

    if (liked) {
      color = Colors.pink;
      icon = FontAwesomeIcons.solidHeart;
    } else {
      icon = FontAwesomeIcons.heart;
    }

    return GestureDetector(
        child: Icon(
          icon,
          size: 25.0,
          color: color,
        ),
        onTap: () {
          //_likePost(postId);
        });
  }

  GestureDetector buildLikeableImage() {
    return GestureDetector(
      onDoubleTap: () {
        //_likePost(postId)
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ImageViewer(media: media, postId: postId, ownerId: ownerId,),
          showHeart
              ? Positioned(
            child: Container(
              width: 100,
              height: 100,
              child:  Opacity(
                  opacity: 0.85,
                  child: FlareActor("assets/flare/Like.flr",
                    animation: "Like",
                  )),
            ),
          )
              : Container(
            width: 100,
            height: 100,)
        ],
      ),
    );
  }

  buildPostHeader({String? ownerId}) {
    if (ownerId == null) {
      return Text("owner error");
    }

    return FutureBuilder(
        future: getUser(ownerId),
        builder: (context, snapshot) {

          if (snapshot.data != null) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider((snapshot.data as Map<String, dynamic>)['photoUrl']),
                backgroundColor: Colors.grey,
              ),
              title: GestureDetector(
                child: Text((snapshot.data as Map<String, dynamic>)['username'], style: boldStyle),
                onTap: () {
                  // openProfile(context, ownerId);
                },
              ),
              subtitle: Text(this.location),
              trailing: const Icon(Icons.more_vert),
            );
          }

          // snapshot data is null here
          return Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    // liked = (likes[googleSignIn.currentUser.id.toString()] == true);
    liked = false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(ownerId: ownerId),
        buildLikeableImage(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
            buildLikeIcon(),
            Padding(padding: const EdgeInsets.only(right: 20.0)),
            GestureDetector(
                child: const Icon(
                  FontAwesomeIcons.comment,
                  size: 25.0,
                ),
                onTap: () {
                  /* goToComments(
                      context: context,
                      postId: postId,
                      ownerId: ownerId,
                      mediaUrl: mediaUrl);
                      */
                }),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Text(
                "$likeCount likes",
                style: boldStyle,
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "$username ",
                  style: boldStyle,
                )),
            Expanded(child: Text(description)),
          ],
        )
      ],
    );
  }

  getUser(String ownerId) async {
    Map<String, dynamic> userMap = {
      "1": {
        "photoUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVYtLzv3tsqFK2q2sTPnO0SE9DfB_E3z8z02hOHmI3QQ&s",
        "username": "jhseong",
      },
      "2": {
        "photoUrl": "https://static.euronews.com/articles/stories/06/70/53/54/320x180_cmsv2_575d371f-6c0f-5d2d-9ede-d54fe96b0297-6705354.jpg",
        "username": "Jake",
      }
    };

    return userMap[ownerId];
  }

  /*
  void _likePost(String postId2) {
    // var userId = googleSignIn.currentUser.id;
    var userId = 1;
    bool _liked = likes[userId] == true;

    if (_liked) {
      print('removing like');
      reference.doc(postId).update({
        'likes.$userId': false
        //firestore plugin doesnt support deleting, so it must be nulled / falsed
      });

      setState(() {
        likeCount = likeCount - 1;
        liked = false;
        likes[userId] = false;
      });

      removeActivityFeedItem();
    }

    if (!_liked) {
      print('liking');
      reference.doc(postId).update({'likes.$userId': true});

      addActivityFeedItem();

      setState(() {
        likeCount = likeCount + 1;
        liked = true;
        likes[userId] = true;
        showHeart = true;
      });
      Timer(const Duration(milliseconds: 2000), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  void addActivityFeedItem() {
    FirebaseFirestore.instance
        .collection("insta_a_feed")
        .doc(ownerId)
        .collection("items")
        .doc(postId)
        .set({
      "username": currentUserModel.username,
      "userId": currentUserModel.id,
      "type": "like",
      "userProfileImg": currentUserModel.photoUrl,
      "mediaUrl": mediaUrl,
      "timestamp": DateTime.now(),
      "postId": postId,
    });
  }

  void removeActivityFeedItem() {
    FirebaseFirestore.instance
        .collection("insta_a_feed")
        .doc(ownerId)
        .collection("items")
        .doc(postId)
        .delete();
  }
  */
}