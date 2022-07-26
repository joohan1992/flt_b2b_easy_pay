import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  Header({Key? key, required String page}) : preferredSize = Size.fromHeight(kToolbarHeight), _page = page, super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  String _page = '';

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<Header>{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        getTitle(widget._page),
        style: TextStyle(color:Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      actions: [
        Icon(
          Icons.add_box_outlined,
          color:Colors.black,
        ),
        SizedBox(width:16),
        Icon(
          FontAwesomeIcons.heart,
          color:Colors.black,
        ),
        SizedBox(width:16),
        Icon(
          Icons.send_outlined,
          color:Colors.black,
        ),
        SizedBox(width:16),
      ],
    );
  }
}

String getTitle(String page) {
  String title = '';
  switch(page) {
    case 'Home':
      title = "Instagram";
  }
  return title;
}