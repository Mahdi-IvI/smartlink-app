import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smartlink/config.dart';
import 'Loading.dart';
import 'models/messageModel.dart';

class ChatPage extends StatefulWidget {
  final String placeId;
  final String placeName;

  const ChatPage({Key? key, required this.placeId, required this.placeName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();

}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController _msgTextController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  late String userId=SmartLink.auth.currentUser!.uid;
  late String documentId, userName;
  late Size size;
  bool persian = false;

  @override
  void initState() {
    //WidgetsBinding.instance.addObserver(this);
    cancelNotification();
    super.initState();
  }

  cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }


  @override
  Widget build(BuildContext context) {
    userName = SmartLink.auth.currentUser!.displayName!;
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.placeName),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30)),
                    child: FirestorePagination(
                      onEmpty: chatPageEmptyDisplay(),
                      initialLoader: const Loading(),
                      viewType: ViewType.list,
                      itemBuilder: (context, documentSnapshots, index) {
                        MessageModel model = MessageModel.fromJson(
                            documentSnapshots.data()
                            as Map<String, dynamic>,
                            documentSnapshots.id);

                        return message(model);
                      },
                      reverse: true,
                      isLive: true,
                      limit: 20,
                      query: SmartLink.fireStore
                          .collection("hotels")
                          .doc(widget.placeId)
                          .collection("groupChat")
                          .orderBy(SmartLink.messageDate,
                          descending: true),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(4),
                  width: size.width,
                  child: Row(
                    children: [

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8),
                          child: TextField(
                            maxLines: 3,
                            minLines: 1,
                            textDirection: persian
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            keyboardType:
                            TextInputType.multiline,
                            controller: _msgTextController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Messege..."),
                            onChanged: (value) {
                              if (value.trim().startsWith(
                                  RegExp(r'[۱-۹]'))) {
                                setState(() {
                                  persian = true;
                                });
                              } else {
                                if (value.trim().startsWith(
                                    RegExp(r'[آ-ی]'))) {
                                  setState(() {
                                    persian = true;
                                  });
                                } else {
                                  setState(() {
                                    persian = false;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(100),
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
                              if (_msgTextController.text
                                  .trim() !=
                                  "") {
                                sendMessage();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
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
    await SmartLink.fireStore
        .collection("hotels")
        .doc(widget.placeId)
        .collection("groupChat")
        .doc(messageId)
        .set({
      SmartLink.messageText: message,
      SmartLink.messageSender: SmartLink.auth.currentUser!.uid,
      SmartLink.messageDate: DateTime.now(),
      SmartLink.messageRead: false
    });

    /*await SmartLink.fireStore
        .collection(SmartLink.collectionUser)
        .doc(widget.getterUserUID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot[SmartLink.chattingWith] != userId) {
          *//*NotificationController.instance.sendNotificationMessageToPeerUser(
              userName, message, documentId, getterUserToken, "message");*//*
        }
      } else {
        print('Document does not exist on the database');
      }
    });*/
  }

  Widget message(MessageModel model) {
    if (model.messageSender != SmartLink.auth.currentUser!.uid) {
      if (model.messageRead == false) {
        SmartLink.fireStore
            .collection("hotels")
            .doc(widget.placeId)
            .collection("groupChat")
            .doc(model.id)
            .update({SmartLink.messageRead: true})
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      }
    }

    bool persian;
    if (model.messageText.trim().startsWith(RegExp(r'[۱-۹]'))) {
      persian = true;
    } else {
      if (model.messageText.trim().startsWith(RegExp(r'[آ-ی]'))) {
        persian = true;
      } else {
        persian = false;
      }
    }

    return InkWell(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: model.messageText));
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('message copied')));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Container(
          margin: model.messageSender == SmartLink.auth.currentUser!.uid
              ? EdgeInsets.only(top: 0, bottom: 4, left: size.width / 6)
              : EdgeInsets.only(top: 0, bottom: 4, right: size.width / 6),
          padding: const EdgeInsets.only(right: 7, left: 7, top: 7, bottom: 5),
          decoration: BoxDecoration(
              color: model.messageSender == SmartLink.auth.currentUser!.uid
                  ? Theme.of(context).primaryColor
                  : Colors.purple[50],
              borderRadius: model.messageSender == SmartLink.auth.currentUser!.uid
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${model.messageDate
                            .toDate()
                            .day}/${model.messageDate
                                .toDate()
                                .month}   ",
                        style: TextStyle(
                            color: model.messageSender == SmartLink.auth.currentUser!.uid
                                ? Colors.white70
                                : Colors.black45),
                      ),
                    ],
                  ),
                  Text(
                    "${model.messageDate
                        .toDate()
                        .hour}:${model.messageDate
                            .toDate()
                            .minute}",
                    style: TextStyle(
                        color: model.messageSender == SmartLink.auth.currentUser!.uid
                            ? Colors.white70
                            : Colors.black45),
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
                        model.messageText,
                        textDirection:
                        persian ? TextDirection.rtl : TextDirection.ltr,
                        style: TextStyle(
                            color: model.messageSender == SmartLink.auth.currentUser!.uid
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              model.messageSender == SmartLink.auth.currentUser!.uid
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    model.messageRead == true
                        ? Icons.done_all
                        : Icons.done,
                    color: Colors.white,
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

}