import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'models/stroke.dart';


class StrokePainter extends CustomPainter {
  final Stroke stroke;
  final StrokeCap strokeCap;

  StrokePainter({@required this.stroke, @required this.strokeCap});


  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.strokeWidth = stroke.strokeWidth;
    paint.strokeCap = strokeCap;

    for (var i = 0; i < stroke.location_colors.length ; i++) {
      final to = stroke.location_colors[i];
      paint.color = Color.fromARGB(
          255, to.red,
          to.green,
          to.blue);

      canvas.drawLine(Offset(to.x, to.y), Offset(3, to.y), paint);
    }
  }

  @override
  bool shouldRepaint(StrokePainter oldPainter) => stroke != oldPainter.stroke;

}
