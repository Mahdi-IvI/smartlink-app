import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../components/loading.dart';
import '../config/config.dart';

class PhotoGallery extends StatefulWidget {
  final List imagesUrl;
  final bool url;
  final int index;

  const PhotoGallery(
      {super.key,
      required this.imagesUrl,
      required this.index,
      required this.url});

  @override
  PhotoGalleryState createState() => PhotoGalleryState();
}

class PhotoGalleryState extends State<PhotoGallery> {
  late int _current = widget.index;
  late final PageController _pageController =
      PageController(initialPage: widget.index);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              width: size.width,
              height: size.height,
              child: PhotoViewGallery.builder(
                pageController: _pageController,
                enableRotation: true,
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: widget.url
                        ? NetworkImage(widget.imagesUrl[index])
                        : FileImage(widget.imagesUrl[index]) as ImageProvider,
                    initialScale: PhotoViewComputedScale.contained * 1.0,
                    maxScale: PhotoViewComputedScale.contained * 1.5,
                    minScale: PhotoViewComputedScale.contained * 0.8,
                  );
                },
                itemCount: widget.imagesUrl.length,
                loadingBuilder: (context, event) => Container(
                  color: Colors.black,
                  child: const Center(
                    child: SizedBox(
                        width: 60.0, height: 60.0, child: ImageLoading()),
                  ),
                ),
                onPageChanged: (index) {
                  setState(() {
                    _current = index;
                  });
                },
                backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                        opacity: 0.4,
                        scale: 3,
                        image: AssetImage(Config.logoAddress))),
              )),
          widget.imagesUrl.length > 1
              ? Positioned(
                  bottom: 50,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.imagesUrl.asMap().entries.map((entry) {
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Colors.white).withOpacity(
                                  _current == entry.key ? 1.0 : 0.2)),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : const SizedBox(),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Color.fromRGBO(0, 0, 0, 0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: AppBar(
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
                iconTheme: const IconThemeData(color: Colors.white),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
