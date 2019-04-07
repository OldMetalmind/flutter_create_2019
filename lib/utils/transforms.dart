import 'package:flutter/material.dart';
import 'package:kaleidoscope/utils/math.dart';

Widget createHexagon(w, double size) {
  List<Widget> s = [];
  for (double angle = -120; angle <= 180; angle += 60) {
    s.add(rotate(w, angle));
  }
  return translate(Stack(children: s), size, size);
}

Widget translate(w, double x, double y) {
  return Transform.translate(
    offset: Offset(x, y),
    child: w,
  );
}

Widget rotate(w, double angle) {
  return Transform.rotate(
    angle: degreesToRad(angle),
    child: w,
    alignment: Alignment.topLeft,
  );
}

Widget groupHexagon(w, double S, double B, double half) {
  return Stack(
    children: <Widget>[
      w,
      translate(w, 0.0, B),
      translate(w, 0.0, -B),
      translate(w, S + half, -B / 2),
      translate(w, -S - half, -B / 2),
      translate(w, S + half, B / 2),
      translate(w, -S - half, B / 2),
    ],
  );
}

Widget fillScreen(w) {
  List<Widget> stack = [];

  var tri = Transform.scale(scale: 3, child: w);
  var oct = Transform.scale(scale: 8, child: w);

  stack.add(oct);
  stack.add(tri);
  stack.add(w);

  return Stack(
    children: stack,
  );
}