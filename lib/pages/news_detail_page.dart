
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smartlink/pages/photo_gallery.dart';
import 'package:timeago/timeago.dart' as time_ago;
import '../components/loading.dart';
import '../models/news_model.dart';

class NewsDetailPage extends StatefulWidget {
  final NewsModel newsModel;

  const NewsDetailPage({super.key, required this.newsModel});

  @override
  NewsDetailPageState createState() => NewsDetailPageState();
}

class NewsDetailPageState extends State<NewsDetailPage> {
  bool singleImage = false;
  final CarouselController _controller = CarouselController();
  int _current = 0;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.newsModel.images.length <= 1) {
      singleImage = true;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0),
        elevation: 0,
        title:Text(
          widget.newsModel.title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: widget.newsModel.images.length,
                  itemBuilder: (BuildContext context, index, _) =>
                      InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhotoGallery(
                                    url: true,
                                    index: index,
                                    imagesUrl: widget.newsModel.images,
                                  )));
                    },
                    child: AspectRatio(
                      aspectRatio: 4/3,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.newsModel.images[index],
                        placeholder: (context, url) => const ImageLoading(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  options: CarouselOptions(
                      aspectRatio: 4 / 3,
                      autoPlay: true,
                      viewportFraction: 1,
                      autoPlayInterval: const Duration(seconds: 7),
                      autoPlayAnimationDuration: const Duration(seconds: 3),
                      pauseAutoPlayInFiniteScroll: true,
                      scrollDirection: Axis.horizontal,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          if (index >=
                              widget.newsModel.images.length) {
                            index = 0;
                          }
                          _current = index;
                        });
                      }),
                ),
                widget.newsModel.images.length > 1
                    ? Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: widget.newsModel.images
                                .asMap()
                                .entries
                                .map((entry) {
                              return Container(
                                width: 6.0,
                                height: 6.0,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 3.0),
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.white,
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0,
                                            0), // changes position of shadow
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                    color: (Colors.black).withOpacity(
                                        _current == entry.key
                                            ? 0.9
                                            : 0.2)),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              width: size.width,
              child: Text(
                widget.newsModel.description,
                style: const TextStyle(fontSize: 17),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    time_ago
                        .format(
                            DateTime.fromMicrosecondsSinceEpoch(widget
                                .newsModel
                                .publishDateTime
                                .microsecondsSinceEpoch),
                            locale: 'en'),
                    style:
                        const TextStyle( fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
