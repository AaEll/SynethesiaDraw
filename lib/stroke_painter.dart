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

  void draw_lines(Canvas canvas,Paint paint, start_idx, end_idx,colorBegin, endColor ){

    final color_tween = ColorTween( begin:colorBegin, end: endColor);


    final step_size = 5 ;

    for (var i = start_idx; i < end_idx; i++) {
      if ((i - start_idx) % step_size == 0){
        paint.color = color_tween.lerp(((1.0*(i-start_idx))/(end_idx-start_idx)));
      }
      final from = stroke.location_colors[i];
      final to = stroke.location_colors[i + 1];
      canvas.drawLine(Offset(from.x, from.y), Offset(to.x, to.y), paint);
    }
  }


  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    if (stroke.strokeStyle == 1) {
      paint.strokeWidth = stroke.strokeWidth;
      paint.strokeCap = strokeCap;

      Color beginColor;
      Color color;
      var start_idx = 0;
      var location_color;
      for (var i = 0; i < stroke.location_colors.length; i++) {
        location_color = stroke.location_colors[i];
        color  = Color.fromARGB(255, location_color.red, location_color.green, location_color.blue);
        if (beginColor == null) {
          beginColor = color;
        } else if (beginColor != color){
          draw_lines(canvas, paint, start_idx, i, beginColor, color);
          start_idx = i;
          beginColor = color;
        }
      }
      //draw_lines(canvas, paint, start_idx, stroke.location_colors.length, beginColor, beginColor);

    } else if (stroke.strokeStyle == 0) {
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
    }
  }

  @override
  bool shouldRepaint(StrokePainter oldPainter) => stroke != oldPainter.stroke;


}
