import 'package:flutter/material.dart';
import 'package:smartlink/models/place_model.dart';
import 'package:smartlink/models/ticket_model.dart';
import 'package:smartlink/pages/chat_page.dart';

class TicketListItem extends StatelessWidget {
  final TicketModel ticket;
  final PlaceModel place;

  const TicketListItem({super.key, required this.ticket, required this.place});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      place: place,
                      ticket: ticket,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ticket.subject,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(ticket.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
