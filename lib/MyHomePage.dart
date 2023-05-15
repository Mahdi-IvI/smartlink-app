
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:smartlink/config.dart';

import 'IntroductionPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName = SmartLink.auth.currentUser?.displayName ?? "User";
  String userEmail = SmartLink.auth.currentUser?.email ?? "Use Emailr";
  String userPhoto =
      SmartLink.auth.currentUser?.photoURL ?? "https://picsum.photos/200/400";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SmartLink"),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                accountEmail: Text(userEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(userPhoto),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign out'),
                onTap: () {
                  SmartLink.auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const IntroductionPage()),
                          (route) => false);
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children:  [
              const GradeListItem(
                icon: Icons.chat,
                title: 'Group Chat',
                subtitle: 'Join the conversation',
              ),
              const GradeListItem(
                icon: Icons.info,
                title: 'Ticket',
                subtitle: 'Get your event ticket',
              ),
              const GradeListItem(
                icon: Icons.article,
                title: 'News',
                subtitle: 'Stay up-to-date',
              ),
              InkWell(
                child: const GradeListItem(
                  icon: Icons.lock,
                  title: 'Door Opener',
                  subtitle: 'Unlock the door',
                ),
                onTap: ()async{
                  LocalAuthentication localAuth = LocalAuthentication();
                  if(await localAuth.canCheckBiometrics){
                    bool didAuth= await localAuth.authenticate(localizedReason: "Please use finger print to open the door");
                    if(didAuth){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("worked")));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("did not work")));

                    }
                  }
                },
              ),
              const GradeListItem(
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
