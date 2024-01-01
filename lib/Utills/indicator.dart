import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Indicator extends StatelessWidget {
  const Indicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: Colors.yellow,
          size: 40,
        ),
      ),
    );
  }
}
