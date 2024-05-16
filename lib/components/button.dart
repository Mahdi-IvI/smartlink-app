import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color foregroundColor;
  final Color backgroundColor;
  final String text;
  final VoidCallback onPressed;

  const Button(
      {super.key,
      required this.foregroundColor,
      required this.backgroundColor,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
