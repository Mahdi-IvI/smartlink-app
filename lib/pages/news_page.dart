import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartlink/components/loading.dart';
import 'package:smartlink/models/place_model.dart';
import '../components/emptyWidget.dart';
import '../config/config.dart';
import '../models/news_model.dart';
import 'news_detail_page.dart';
import 'package:timeago/timeago.dart' as time_ago;

class NewsPage extends StatefulWidget {
  final PlaceModel place;

  const NewsPage({super.key, required this.place});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int refreshed = 0;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("${Config.placesCollection} > ${widget.place.id} > ${Config.newsCollection}");
    }
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          refreshed++;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "News",
          ),
        ),
        body: FirestorePagination(
          initialLoader: const Loading(),
          onEmpty: const EmptyWidget("News box is empty."),
          viewType: ViewType.list,
          itemBuilder: (context, documentSnapshots, index) {
            NewsModel model = NewsModel.fromDocument(
                documentSnapshots);
            return Column(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: model.images.isEmpty
                      ? Image.asset(Config.logoAddress)
                      : Image.network(
                          model.images[0],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: Loading());
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        model.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              model.description,
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  time_ago.format(
                                      DateTime.fromMicrosecondsSinceEpoch(model
                                          .publishDateTime
                                          .microsecondsSinceEpoch),
                                      locale: 'en'),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NewsDetailPage(newsModel: model)));
                              },
                              child: const Text(
                                "Read more...",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          limit: 10,
          query: Config.fireStore
              .collection(Config.placesCollection)
              .doc(widget.place.id)
              .collection(Config.newsCollection)
              .orderBy(Config.publishDateTime, descending: true),
          key: Key("$refreshed times"),
        ),
      ),
    );
  }
}
