import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smartlink/config/config.dart';
import 'package:smartlink/models/place_model.dart';
import 'package:smartlink/pages/photo_gallery.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/loading.dart';
import '../config/my_colors.dart';

class PlaceInfoPage extends StatefulWidget {
  final PlaceModel place;

  const PlaceInfoPage({super.key, required this.place});

  @override
  State<PlaceInfoPage> createState() => _PlaceInfoPageState();
}

class _PlaceInfoPageState extends State<PlaceInfoPage> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.place.images.isEmpty
                ? AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage(Config.logoAssetAddress))),
                    ),
                  )
                : widget.place.images.length == 1
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhotoGallery(
                                        imagesUrl: widget.place.images,
                                        index: 0,
                                        url: true,
                                      )));
                        },
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.place.images[0],
                            placeholder: (context, url) => const ImageLoading(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          CarouselSlider.builder(
                            carouselController: _controller,
                            itemCount: widget.place.images.length,
                            itemBuilder: (BuildContext context, index, _) =>
                                InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PhotoGallery(
                                              url: true,
                                              index: index,
                                              imagesUrl: widget.place.images,
                                            )));
                              },
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: widget.place.images[index],
                                placeholder: (context, url) =>
                                    const ImageLoading(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            options: CarouselOptions(
                                aspectRatio: 4 / 3,
                                autoPlay: false,
                                viewportFraction: 1,
                                autoPlayInterval: const Duration(seconds: 7),
                                autoPlayAnimationDuration:
                                    const Duration(seconds: 3),
                                pauseAutoPlayInFiniteScroll: true,
                                scrollDirection: Axis.horizontal,
                                enlargeCenterPage: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    if (index >= widget.place.images.length) {
                                      index = 0;
                                    }
                                    if (kDebugMode) {
                                      print(index);
                                    }
                                    _current = index;
                                  });
                                }),
                          ),
                          widget.place.images.length > 1
                              ? Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: widget.place.images
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
                                                      ? 1.0
                                                      : 0.2)),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
            const SizedBox(
              height: kToolbarHeight / 4,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.place.website != "")
                        SizedBox(
                          width: (size.width - 24) / 5,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                    color: MyColors.primaryContainerColor,
                                    shape: BoxShape.circle),
                                child: IconButton(
                                    icon: Icon(MdiIcons.web),
                                    color: Colors.black,
                                    onPressed: () {
                                      String webSite = widget.place.website;
                                      _openWebSite(webSite);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      if (widget.place.instagram != null &&
                          widget.place.instagram != "")
                        SizedBox(
                          width: (size.width - 24) / 5,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                    color: MyColors.primaryContainerColor,
                                    shape: BoxShape.circle),
                                child: IconButton(
                                    icon: Icon(MdiIcons.instagram),
                                    color: Colors.black,
                                    onPressed: () {
                                      String instagram = widget.place.instagram!;
                                      _openInstagram(instagram);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      if (widget.place.facebook!=null && widget.place.facebook != "")
                        SizedBox(
                          width: (size.width - 24) / 5,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                    color: MyColors.primaryContainerColor,
                                    shape: BoxShape.circle),
                                child: IconButton(
                                    icon: const Icon(Icons.facebook),
                                    color: Colors.black,
                                    onPressed: () {
                                      String faceBook = widget.place.facebook!;
                                      _openFaceBook(faceBook);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      if (widget.place.phoneNumbers.isNotEmpty)
                        SizedBox(
                          width: (size.width - 24) / 5,
                          child: Column(
                            children: [
                              Container(
                                width: 70,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                    color: MyColors.primaryContainerColor,
                                    shape: BoxShape.circle),
                                child: IconButton(
                                    icon: const Icon(Icons.call),
                                    color: Colors.black,
                                    onPressed: () {
                                      String phoneNumber =
                                          widget.place.phoneNumbers[0];
                                      _makePhoneCall(phoneNumber);
                                    }),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  if (widget.place.address != "")
                    InkWell(
                      onTap: () {
                        launchMap(widget.place.address);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.location_on_outlined),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  child: Text(
                                    widget.place.address,
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    launchMap(widget.place.address);
                                  },
                                  onLongPress: () {
                                    Clipboard.setData(ClipboardData(
                                        text: widget.place.address));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                AppLocalizations.of(context)!
                                                    .addressCopied)));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.place.website != "")
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: MyColors.borderColor,
                    ),
                  if (widget.place.website != "")
                    InkWell(
                      onTap: () {
                        String webSite = widget.place.website;
                        _openWebSite(webSite);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(MdiIcons.web),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  child: Text(
                                    widget.place.website,
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onLongPress: () {
                                    Clipboard.setData(ClipboardData(
                                        text: widget.place.website));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                AppLocalizations.of(context)!
                                                    .addressCopied)));
                                  },
                                  onPressed: () {
                                    String webSite = widget.place.website;
                                    _openWebSite(webSite);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.place.email != "")
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: MyColors.borderColor,
                    ),
                  if (widget.place.email != "")
                    InkWell(
                      onTap: () {
                        sendEmail(widget.place.email);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.email_outlined),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  child: FittedBox(
                                      child: Text(
                                    widget.place.email,
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )),
                                  onLongPress: () {
                                    Clipboard.setData(ClipboardData(
                                        text: widget.place.email));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                AppLocalizations.of(context)!
                                                    .emailCopied)));
                                  },
                                  onPressed: () {
                                    sendEmail(widget.place.email);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.place.phoneNumbers.isNotEmpty)
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: MyColors.borderColor,
                    ),
                  if (widget.place.phoneNumbers.isNotEmpty)
                    InkWell(
                      onTap: () {
                        String phoneNumber = widget.place.phoneNumbers[0];

                        _makePhoneCall(phoneNumber);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.call),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  child: Text(
                                    widget.place.phoneNumbers.join(", "),
                                    textDirection: TextDirection.ltr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onLongPress: () {
                                    Clipboard.setData(ClipboardData(
                                        text: widget.place.phoneNumbers
                                            .join(", ")));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                AppLocalizations.of(context)!
                                                    .numberCopied)));
                                  },
                                  onPressed: () {
                                    String phoneNumber =
                                        widget.place.phoneNumbers[0];
                                    _makePhoneCall(phoneNumber);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.description,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.all(8),
                      width: size.width,
                      child: Text(
                        widget.place.descriptionDe,
                        textDirection: TextDirection.ltr,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (!await launchUrl(Uri.parse("tel:$url"))) {
      throw Exception('Could not call $url');
    }
  }

  void launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";
    if (!await launchUrl(Uri.parse(googleUrl))) {
      throw Exception('Could not launch $googleUrl');
    }
  }

  void sendEmail(String infoEmail) async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: "mailto",
      path: infoEmail,
      query: encodeQueryParameters(<String, String>{}),
    );

    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch $emailLaunchUri');
    }
  }

  _openWebSite(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  _openInstagram(String instagramId) async {
    String url = "https://www.instagram.com/$instagramId";
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  _openFaceBook(String facebookId) async {
    String url = "https://www.facebook.com/$facebookId";
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
