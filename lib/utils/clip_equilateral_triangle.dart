import 'package:flutter/material.dart';

class TriangleClip extends CustomClipper<Path> {
  double height;
  TriangleClip(this.height);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(size.width / 2, height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
