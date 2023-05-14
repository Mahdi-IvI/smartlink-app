
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SmartLink"),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(

                  padding: EdgeInsets.all(0),
                  child: Container(
                    color: Colors.purple,
                  )),
              ListTile(
                title: Text("Settings"),
              )
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: const [
              GradeListItem(
                icon: Icons.chat,
                title: 'Group Chat',
                subtitle: 'Join the conversation',
              ),
              GradeListItem(
                icon: Icons.info,
                title: 'Ticket',
                subtitle: 'Get your event ticket',
              ),
              GradeListItem(
                icon: Icons.article,
                title: 'News',
                subtitle: 'Stay up-to-date',
              ),
              GradeListItem(
                icon: Icons.lock,
                title: 'Door Opener',
                subtitle: 'Unlock the door',
              ),
              GradeListItem(
                icon: Icons.contacts,
                title: 'Contacts',
                subtitle: 'Find your contacts',
              ),
            ],
          ),
        ));
  }
}

class GradeListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const GradeListItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Icon(icon,size: 38,),
              ListTile(
                title: Center(
                  child: Text(title),
                ),
              ),
            ],
          )),
    );
  }
}
