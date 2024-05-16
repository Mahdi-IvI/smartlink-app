import 'package:flutter/cupertino.dart';

class EmptyWidget extends StatelessWidget {
  final String message;

  const EmptyWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
