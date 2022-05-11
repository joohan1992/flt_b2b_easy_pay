import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget{
  BottomBar({Key? key, required int selectedTab, required String profileImg, required this.onClickTab}) : _selectedTab = selectedTab, _profileImg = profileImg, super(key: key);

  int _selectedTab;
  String _profileImg;
  Function onClickTab;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<BottomBar>{
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(
                      top: BorderSide(color: Colors.black, width: 0.3))),
              child:
              Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) => {widget.onClickTab(index)},
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(
                        (widget._selectedTab == 0 ? Icons.home : Icons
                            .home_outlined),
                        color: Colors.black,
                      ),
                      label: '홈',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        (widget._selectedTab == 1 ? Icons.search : Icons
                            .search_outlined),
                        color: Colors.black,
                      ),
                      label: '검색',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        (widget._selectedTab == 2 ? Icons.movie : Icons
                            .movie_outlined),
                        color: Colors.black,
                      ),
                      label: '릴스',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        (widget._selectedTab == 3 ? Icons.shopping_bag : Icons
                            .shopping_bag_outlined),
                        color: Colors.black,
                      ),
                      label: '구매',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        (widget._selectedTab == 4 ? Icons.circle : Icons
                            .circle_outlined),
                        color: Colors.black,
                      ),
                      label: '프로필',
                    ),
                  ],
                ),
              )
          ),
          Positioned(
              right: MediaQuery.of(context).size.width/10-18, // 화면 크기를 구해 탭 아이콘의 위치에 정확히 표현되도록 함
              child: Container(
                  width: 36.0,
                  height: 36.0,
                  margin: EdgeInsets.only(top: 9),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,
                        width: (widget._selectedTab == 4 ? 1.0 : 0.5)),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      widget.onClickTab(4);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        widget._profileImg,
                      ),
                    ),
                  )
              )
          )
        ]
    );
  }
}