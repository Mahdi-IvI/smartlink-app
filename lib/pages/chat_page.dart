import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartlink/config/config.dart';
import 'package:smartlink/config/my_colors.dart';
import 'package:smartlink/models/place_model.dart';
import 'package:smartlink/models/ticket_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/loading.dart';
import '../models/message_model.dart';

class ChatPage extends StatefulWidget {
  final PlaceModel place;
  final TicketModel? ticket;

  const ChatPage({super.key, required this.place, this.ticket});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController _msgTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.ticket != null
              ? widget.ticket!.subject
              : widget.place.name),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  child: FirestorePagination(
                    onEmpty: chatPageEmptyDisplay(),
                    initialLoader: const Loading(),
                    viewType: ViewType.list,
                    itemBuilder: (context, documentSnapshots, index) {
                      MessageModel model =
                          MessageModel.fromDocument(documentSnapshots[index]);

                      return message(model: model, size: size);
                    },
                    reverse: true,
                    isLive: true,
                    limit: 20,
                    query: widget.ticket != null
                        ? Config.fireStore
                            .collection(Config.placesCollection)
                            .doc(widget.place.id)
                            .collection(Config.ticketCollection)
                            .doc(widget.ticket!.id)
                            .collection(Config.ticketMessageCollection)
                            .orderBy(Config.dateTime, descending: true)
                        : Config.fireStore
                            .collection(Config.placesCollection)
                            .doc(widget.place.id)
                            .collection(Config.groupChatCollection)
                            .orderBy(Config.dateTime, descending: true),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(4),
                width: size.width,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          maxLines: 3,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          controller: _msgTextController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)!.message),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor),
                        child: IconButton(
                          icon: const Icon(
                            Icons.send_outlined,
                            textDirection: TextDirection.ltr,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_msgTextController.text.trim() != "") {
                              sendMessage();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  chatPageEmptyDisplay() {
    return const Center(child: SizedBox());
  }

  void sendMessage() async {
    String message = _msgTextController.text.trim();
    _msgTextController.clear();
    String messageId = DateTime.now().millisecondsSinceEpoch.toString();
    if (widget.ticket != null) {
      Config.fireStore
          .collection(Config.placesCollection)
          .doc(widget.place.id)
          .collection(Config.ticketCollection)
          .doc(widget.ticket!.id)
          .update({
        Config.lastMessageDateTime: DateTime.now(),
        Config.lastSender: Config.auth.currentUser!.uid,
        Config.read: false,
      }).whenComplete(() async {
        await Config.fireStore
            .collection(Config.placesCollection)
            .doc(widget.place.id)
            .collection(Config.ticketCollection)
            .doc(widget.ticket!.id)
            .collection(Config.ticketMessageCollection)
            .doc(messageId)
            .set({
          Config.text: message,
          Config.senderUid: Config.auth.currentUser!.uid,
          Config.dateTime: DateTime.now(),
        });
      });
    } else {
      await Config.fireStore
          .collection(Config.placesCollection)
          .doc(widget.place.id)
          .collection(Config.groupChatCollection)
          .doc(messageId)
          .set({
        Config.text: message,
        Config.senderUid: Config.auth.currentUser!.uid,
        Config.dateTime: DateTime.now(),
      });
    }
  }

  Widget message({required MessageModel model, required Size size}) {
    return InkWell(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: model.text));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.messageCopied)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Container(
          margin: model.senderUid == Config.auth.currentUser!.uid
              ? EdgeInsets.only(top: 0, bottom: 4, left: size.width / 6)
              : EdgeInsets.only(top: 0, bottom: 4, right: size.width / 6),
          padding: const EdgeInsets.only(right: 7, left: 7, top: 7, bottom: 5),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: MyColors.primaryColor,
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
              color: model.senderUid == Config.auth.currentUser!.uid
                  ? Colors.purple[50]
                  : Theme.of(context).primaryColor,
              borderRadius: model.senderUid == Config.auth.currentUser!.uid
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(12))
                  : const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  model.senderUid != Config.auth.currentUser!.uid
                      ? getUserName(model.senderUid)
                      : const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${model.dateTime.toDate().day}/${model.dateTime.toDate().month}   ",
                        style: TextStyle(
                            color:
                                model.senderUid == Config.auth.currentUser!.uid
                                    ? Colors.black45
                                    : Colors.white70),
                      ),
                      Text(
                        "${model.dateTime.toDate().hour}:${model.dateTime.toDate().minute}",
                        style: TextStyle(
                            color:
                                model.senderUid == Config.auth.currentUser!.uid
                                    ? Colors.black45
                                    : Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        model.text,
                        style: TextStyle(
                            color:
                                model.senderUid == Config.auth.currentUser!.uid
                                    ? Colors.black
                                    : Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              model.senderUid == Config.auth.currentUser!.uid
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.done,
                          color: Colors.black,
                          size: 15,
                        )
                      ],
                    )
                  : const SizedBox(
                      height: 5,
                    )
            ],
          ),
        ),
      ),
    );
  }

  getUserName(String userUID) {
    String username = " ";

    if (widget.ticket != null || userUID == widget.place.id) {
      return Text(
        widget.place.name,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      );
    } else {
      return StreamBuilder<DocumentSnapshot>(
        stream: Config.fireStore
            .collection(Config.userCollection)
            .doc(userUID)
            .snapshots(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.hasError) {
            return const SizedBox();
          }

          if (dataSnapshot.data == null) {
            username = AppLocalizations.of(context)!.user;
            return Text(
              username,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            );
          } else {
            if (dataSnapshot.data!.exists) {
              if (dataSnapshot.hasData) {
                return Text(
                  dataSnapshot.data![Config.username],
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                );
              } else {
                return Text(
                  dataSnapshot.data![Config.username],
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                );
              }
            } else {
              username = AppLocalizations.of(context)!.user;
              return Text(
                username,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              );
            }
          }
        },
      );
    }
  }
}
