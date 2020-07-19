import 'package:flutter/material.dart';

class CustomRRect extends CustomClipper<RRect> {
  @override
  RRect getClip(Size size) {
    RRect rect = RRect.fromRectAndRadius(Rect.fromLTRB(4, 4, size.width-4, size.height-4), Radius.circular(15));
    return rect;
  }

  @override
  bool shouldReclip(CustomClipper<RRect> oldClipper) {
    // TODO: implement shouldReclip
    return true;
    throw UnimplementedError();
  }
}