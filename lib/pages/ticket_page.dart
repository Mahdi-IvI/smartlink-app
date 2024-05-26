import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartlink/components/ticket_list_item.dart';
import 'package:smartlink/models/ticket_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/loading.dart';
import '../config/config.dart';
import '../models/place_model.dart';
import 'create_ticket_page.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key, required this.place});

  final PlaceModel place;

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  Stream<List<TicketModel>> getMyTickets() {
    return Config.fireStore
        .collection(Config.placesCollection)
        .doc(widget.place.id)
        .collection(Config.ticketCollection)
        .where(Config.senderUid, isEqualTo: Config.auth.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TicketModel.fromDocument(doc);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myTickets),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateTicketPage(
                              place: widget.place,
                            )));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<List<TicketModel>>(
        stream: getMyTickets(),
        builder: (BuildContext context, ticketSnapshot) {
          if (ticketSnapshot.hasError) {
            if (kDebugMode) {
              print(ticketSnapshot.error);
            }
            return Center(child: Text(ticketSnapshot.error.toString()));
          }

          if (ticketSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: WhiteLoading());
          }
          if (kDebugMode) {
            print(ticketSnapshot.data!.length);
            print(widget.place.id);
          }

          if (ticketSnapshot.data!.isEmpty) {
            return SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.createTicketText),
                  TextButton(
                    child: Text(AppLocalizations.of(context)!.createTicket),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateTicketPage(
                                    place: widget.place,
                                  )));
                    },
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: ticketSnapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TicketListItem(
                    ticket: ticketSnapshot.data![index],
                    place: widget.place,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
