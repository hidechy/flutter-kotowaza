import 'package:flutter/material.dart';

class Utility {
  /**
   * θζ―εεΎ
   */
  Widget getBackGround() {
    return Image.asset(
      'assets/images/bg.jpg',
      fit: BoxFit.cover,
      color: Colors.black.withOpacity(0.7),
      colorBlendMode: BlendMode.darken,
    );
  }
}
