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
          boxShadow: const [
            BoxShadow(
              color: Colors.purple,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Card(
            shadowColor: Colors.purple,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(ticket.subject),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(ticket.description),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
