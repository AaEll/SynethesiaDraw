import 'dart:math';
import 'dart:ui';

import 'package:built_collection/built_collection.dart';
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

    if (stroke.strokeStyle == 0) {
      final rnd =  Random( stroke.strokeWidth.floor());

      paint.strokeCap = StrokeCap.round;
      paint.strokeWidth = 2.5;
      for (var i = 0; i < stroke.location_colors.length; i++) {
        final to = stroke.location_colors[i];
        paint.color = Color.fromARGB(
            200, to.red,
            to.green,
            to.blue);
        final point_field = ListBuilder<Offset>();

        for (var j =0; j < stroke.strokeWidth*stroke.strokeWidth/10; j++) {

          var rand_radius = rnd.nextDouble()*stroke.strokeWidth/2;
          rand_radius = rand_radius*rand_radius.abs();
          final rand_direction = rnd.nextDouble()*2;

          final rand_x = cos(rand_direction)*rand_radius;
          final rand_y = sin(rand_direction)*rand_radius;

          point_field.add(Offset(to.x + rand_x, to.y + rand_y ));
        }

        canvas.drawPoints(PointMode.points,point_field.build().toList(),paint);
      }
    } else if (stroke.strokeStyle == 1) {
      paint.strokeWidth = stroke.strokeWidth;
      paint.strokeCap = strokeCap;

      for (var i = 0; i < stroke.location_colors.length - 1; i++) {
        final from = stroke.location_colors[i];
        final to = stroke.location_colors[i + 1];
        paint.color = Color.fromARGB(
            255, from.red,
            from.green,
            from.blue);

        canvas.drawLine(Offset(from.x, from.y), Offset(to.x, to.y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(StrokePainter oldPainter) => stroke != oldPainter.stroke;


}
