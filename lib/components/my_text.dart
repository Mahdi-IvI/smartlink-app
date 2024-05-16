import 'package:flutter/material.dart';

//Different Kind of Text that has been used in App
class NText extends StatelessWidget {
  final String text;
  final Color? color;

  const NText({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color ?? Colors.black),
    );
  }
}

class SText extends StatelessWidget {
  final String text;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;

  const SText(
      {super.key,
      required this.text,
      this.color,
      this.maxLines,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(fontSize: 16, color: color ?? Colors.black),
    );
  }
}

class BoldText extends StatelessWidget {
  final String text;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;
  final bool? showStar;

  const BoldText(
      {super.key,
      required this.text,
      this.color,
      this.maxLines,
      this.textAlign,
      this.showStar});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines ?? 1,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style:
          TextStyle(fontWeight: FontWeight.bold, color: color ?? Colors.black),
    );
  }
}

class H2Text extends StatelessWidget {
  final String text;
  final Color? color;

  const H2Text({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28),
    );
  }
}

class H3Text extends StatelessWidget {
  final String text;
  final Color? color;

  const H3Text({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22),
    );
  }
}

class H4Text extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool? notBold;
  final int? maxLines;

  const H4Text(
      {super.key,
      required this.text,
      this.color,
      this.textAlign,
      this.notBold,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: color ?? Colors.black,
          fontWeight:
              notBold != null && notBold! ? FontWeight.normal : FontWeight.bold,
          fontSize: 18),
    );
  }
}

class H5Text extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;

  const H5Text({super.key, required this.text, this.color, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16),
    );
  }
}
