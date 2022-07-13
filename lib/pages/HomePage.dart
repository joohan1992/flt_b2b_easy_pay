import 'package:flt_b2b_easy_pay/common/BottomBar.dart';
import 'package:flutter/material.dart';

import '../NotificationController.dart';
import '../common/Header.dart';
import '../widgets/ImagePost.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin<MyHomePage> {
  int currentTab = 0;
  String imageUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVYtLzv3tsqFK2q2sTPnO0SE9DfB_E3z8z02hOHmI3QQ&s';

  void onClickTab(int idx) {
    setState(() {
      currentTab = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: Header(key: null, page: "Home"),
        // 헤더는 page에 따라 자동으로 그려지도록 공통 컴포넌트 따로 구현
        body: SafeArea( // SafeArea는 노치 스크린, 라운드 코너 등을 제외하고 컨텐츠가 온전히 보여질 수 있는 영역으로 제한
            child: buildTabPage()
        ),
        bottomNavigationBar: BottomBar(key: null, selectedTab: currentTab, profileImg: imageUrl, onClickTab: onClickTab),
    );
  }

  buildTabPage() {
    if(currentTab == 0) {
      return buildFeed();
    } else {
      return Container();
    }
  }

  buildFeed() {
    return Container(
      child: FutureBuilder(
          future: getImagePosts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator(),
              );
            }
            else {
              return ListView(children: snapshot.data as List<Widget>);
            }
          }
      ),
    );
  }

  buildActivityFeed() {
    return Container(
      child: FutureBuilder(
        future: getFeed(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator()
            );
          }
          else {
            return ListView(children: snapshot.data as List<Widget>);
          }
        }
      ),
    );
  }

  getImagePosts() async {
    List<ImagePost> items = [];

    items.add(const ImagePost(
      media: ['https://a.cdn-hotels.com/gdcs/production143/d1112/c4fedab1-4041-4db5-9245-97439472cf2c.jpg'],
      username: 'jhseong',
      location: 'Seoul',
      description: '게시글\n#렌더링 #로맨틱 #성공적',
      likes: null,
      postId: '1',
      ownerId: '1',
    ));
    items.add(const ImagePost(
      media: ['https://answers.opencv.org/upfiles/13921515003259208.png', 'https://i.stack.imgur.com/3ETM1.jpg'],
      username: 'Jake',
      location: 'Belgium',
      description: 'What are you looking for? #L2B',
      likes: null,
      postId: '2',
      ownerId: '2',
    ));
    return items;
  }

  getFeed() async {
    List<FeedTile> items = [];

    items.add(FeedTile(
      username: 'jhseong',
      userId: 'jhseong',
      type: 'like',
      mediaUrl: 'https://a.cdn-hotels.com/gdcs/production143/d1112/c4fedab1-4041-4db5-9245-97439472cf2c.jpg',
      mediaId: '',
      userProfileImg: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVYtLzv3tsqFK2q2sTPnO0SE9DfB_E3z8z02hOHmI3QQ&s',
      commentData: '',
    ));
    items.add(FeedTile(
      username: 'jhseong',
      userId: 'jhseong',
      type: 'like',
      mediaUrl: 'https://t1.daumcdn.net/cfile/tistory/99D40C3D5D3D1B8510',
      mediaId: '',
      userProfileImg: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVYtLzv3tsqFK2q2sTPnO0SE9DfB_E3z8z02hOHmI3QQ&s',
      commentData: '',
    ));
    items.add(FeedTile(
      username: 'jhseong',
      userId: 'jhseong',
      type: 'like',
      mediaUrl: 'http://tourimage.interpark.com/BBS/Tour/FckUpload/201608/6360590598284247970.jpg',
      mediaId: '',
      userProfileImg: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVYtLzv3tsqFK2q2sTPnO0SE9DfB_E3z8z02hOHmI3QQ&s',
      commentData: '',
    ));

    return items;
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}

// class UsingBuilderListConstructing extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(8),
//       itemCount: people.length + 1,
//       itemBuilder: (context, index) {
//         if (index == 0) return HeaderTile();
//         return PersonTile(people[index - 1]);
//       },
//     );
//   }
// }

class FeedTile extends StatelessWidget {
  final String? username;
  final String? userId;
  final String?
  type; // types include liked photo, follow user, comment on photo
  final String? mediaUrl;
  final String? mediaId;
  final String? userProfileImg;
  final String? commentData;

  FeedTile({
    this.username,
    this.userId,
    this.type,
    this.mediaUrl,
    this.mediaId,
    this.userProfileImg,
    this.commentData
  });

  Widget mediaPreview = Container();
  String? actionText;

  void configureItem(BuildContext context) {
    if (type == "like" || type == "comment") {
      mediaPreview = GestureDetector(
        onTap: () {
          // openImage(context, mediaId);
        },
        child: Container(
          height: 45.0,
          width: 45.0,
          child: AspectRatio(
            aspectRatio: 487 / 451,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    alignment: FractionalOffset.topCenter,
                    image: NetworkImage(mediaUrl!),
                  )),
            ),
          ),
        ),
      );
    }

    if (type == "like") {
      actionText = " liked your post.";
    } else if (type == "follow") {
      actionText = " starting following you.";
    } else if (type == "comment") {
      actionText = " commented: $commentData";
    } else {
      actionText = "Error - invalid activityFeed type: $type";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureItem(context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 15.0),
          child: CircleAvatar(
            radius: 23.0,
            backgroundImage: NetworkImage(userProfileImg!),
          )
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: Text(
                  username!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // openProfile(context, userId);
                },
              ),
              Flexible(
                child: Container(
                  child: Text(
                    actionText!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          child: Align(
            child: Padding(
              child: mediaPreview,
              padding: EdgeInsets.all(15.0),
            ),
            alignment: AlignmentDirectional.bottomEnd
          )
        )
      ],
    );
  }

  factory FeedTile.fromJson(Map<String, dynamic> data) {
    return FeedTile(
      username: data['username'],
      userId: data['userId'],
      type: data['type'],
      mediaUrl: data['mediaUrl'],
      mediaId: data['mediaId'],
      userProfileImg: data['userProfileImg'],
      commentData: data['commentData'],
    );
  }
}