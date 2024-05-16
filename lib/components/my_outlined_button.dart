import 'package:flutter/material.dart';

class MyOutlinedButton extends StatelessWidget {
  final Widget? child;
  final String text;
  final VoidCallback onTap;

  const MyOutlinedButton(
      {super.key, this.child, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: kToolbarHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.purple, width: 2)),
        child: child ??
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
      ),
    );
  }
}
