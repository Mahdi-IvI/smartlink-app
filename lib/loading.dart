
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        size: 25,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
class WhiteLoading extends StatelessWidget {
  const WhiteLoading({super.key});


  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitThreeBounce(
        size: 25,
        color: Colors.white,
      ),
    );
  }
}