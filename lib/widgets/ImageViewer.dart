import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageViewer extends StatefulWidget {

  const ImageViewer(
      {required this.media,
        required this.postId,
        required this.ownerId});

  final List<String> media;
  final String postId;
  final String ownerId;


  @override
  _ImageViewer createState() => _ImageViewer(
    media: this.media,
    ownerId: this.ownerId,
    postId: this.postId,
  );
}

class _ImageViewer extends State<ImageViewer> {
  final List<String> media;
  final String postId;
  final String ownerId;
  int _current = 0;

  List<Widget> imageSliders = <Widget>[Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  )];

  _ImageViewer({required this.media,
    required this.postId,
    required this.ownerId});

  Container loadingPlaceHolder = Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  );

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [buildContainer(media)],
    );
  }

  Widget buildContainer(List<String> media) {
    if(media.length <= 1) {
      return CachedNetworkImage(
        imageUrl: media.first,
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => loadingPlaceHolder,
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    } else {
      print("111");
      imageSliders = media.map((item) => Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(0.0),
          child: Stack(
                children: <Widget>[
                  Image.network(item, fit: BoxFit.fitWidth, width: 1000.0),
                  /*Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        'No. ${media.indexOf(item)} image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
        ),
      ).toList();

      print("222");
      print(imageSliders.toString());

      return Column(children: [
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: false,
            enableInfiniteScroll: false,
            aspectRatio: 16/9,
            viewportFraction: 1.0,
            padEnds: false,
            clipBehavior: Clip.hardEdge,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: media
              .asMap()
              .entries
              .map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 6.0,
                height: 6.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme
                        .of(context)
                        .brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ]);
    }
  }

}