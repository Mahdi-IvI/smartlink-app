import 'package:flutter/material.dart';

class GradeListItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const GradeListItem({
    super.key,
    required this.icon,
    required this.title,
  });

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
              Icon(
                icon,
                size: 38,
              ),
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
