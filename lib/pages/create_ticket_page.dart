import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartlink/components/loading.dart';
import 'package:smartlink/components/my_container.dart';
import 'package:smartlink/config/config.dart';
import 'package:smartlink/models/message_model.dart';
import 'package:smartlink/models/ticket_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/place_model.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key, required this.place});

  final PlaceModel place;

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createNewTicket),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /* MyContainer(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: TextFormField(
                          controller: categoryController,
                          decoration: const InputDecoration(
                              labelText: "Category: ",
                              errorText: "Please choose a Category.",
                              border: InputBorder.none),
                        )),*/
                    MyContainer(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: TextFormField(
                          controller: subjectController,
                          decoration: InputDecoration(
                              //   errorText: "Please fill the Subject.",
                              labelText: AppLocalizations.of(context)!.subject,
                              border: InputBorder.none),
                        )),
                    MyContainer(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        child: TextFormField(
                          controller: descriptionController,
                          minLines: 3,
                          maxLines: 6,
                          decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.description,
                              border: InputBorder.none),
                        )),
                  ],
                ),
              ),
            ),
          ),
          MyContainer(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: ListTile(
              title: Center(
                  child: loading
                      ? const WhiteLoading()
                      : const Text(
                          "Submit",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  String docId = Config.auth.currentUser!.uid +
                      DateTime.now().microsecondsSinceEpoch.toString();
                  TicketModel ticketModel = TicketModel(
                      id: docId,
                      read: false,
                      subject: subjectController.text.trim(),
                      lastMessageDateTime: Timestamp.now(),
                      senderUid: Config.auth.currentUser!.uid,
                      lastSender: Config.auth.currentUser!.uid,
                      createDateTime: Timestamp.now(),
                      description: descriptionController.text.trim());
                  Config.fireStore
                      .collection(Config.placesCollection)
                      .doc(widget.place.id)
                      .collection(Config.ticketCollection)
                      .doc(docId)
                      .set(ticketModel.toJson())
                      .whenComplete(() {
                    MessageModel message = MessageModel(
                        id: docId,
                        dateTime: Timestamp.now(),
                        senderUid: Config.auth.currentUser!.uid,
                        text: descriptionController.text.trim());
                    Config.fireStore
                        .collection(Config.placesCollection)
                        .doc(widget.place.id)
                        .collection(Config.ticketCollection)
                        .doc(docId)
                        .collection(Config.ticketMessageCollection)
                        .doc()
                        .set(message.toJson());
                  }).whenComplete(() {
                    setState(() {
                      loading = false;
                    });
                    Navigator.pop(context);
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
