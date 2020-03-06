import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../models/clear.dart';
import '../models/draw_event.dart';
import '../models/end_touch.dart';
import '../models/stroke.dart';
import '../models/stroke_style.dart';
import '../models/stroke_width.dart';
import '../models/touch_location_color.dart';

part 'bloc_provider.dart';

class PainterBloc extends BlocBase {
  // Completed strokes
  BuiltList<Stroke> _strokes = BuiltList<Stroke>();

  // In progress stroke
  BuiltList<TouchLocationColorEvent> _locations_colors = BuiltList<TouchLocationColorEvent>();
  double _width = 7;
  int _strokeStyle = 1;

  // Streamed input into this BLoC
  final _drawEvents = BehaviorSubject<DrawEvent>();
  StreamSink<DrawEvent> get drawEvent => _drawEvents.sink;

  // Streamed outputs from this BLoC
  final _strokesSubject = BehaviorSubject<BuiltList<Stroke>>();
  StreamSink<BuiltList<Stroke>> get _strokesOut => _strokesSubject.sink;
  ValueObservable<BuiltList<Stroke>> get strokes => _strokesSubject.stream;

  final _widthSubject = BehaviorSubject<double>();
  StreamSink<double> get _widthOut => _widthSubject.sink;
  ValueObservable<double> get width => _widthSubject.stream;

  final _styleSubject = BehaviorSubject<int>();
  StreamSink<int> get _styleOut => _styleSubject.sink;
  ValueObservable<int> get strokeStyle => _styleSubject.stream;

  PainterBloc() {
    // Publish initial state
    _strokesOut.add(_strokes);
    _widthOut.add(_width);
    _styleOut.add(_strokeStyle);

    // Update state based on events
    _drawEvents.stream.listen((drawEvent) {
      if (drawEvent is ClearEvent) {
        _strokes = BuiltList<Stroke>();
        _locations_colors = BuiltList<TouchLocationColorEvent>();
        _strokesOut.add(_strokes);
      } else if (drawEvent is StrokeStyleChangeEvent) {
        finalizeCurrentStroke();
        _strokeStyle = drawEvent.style;
        _styleOut.add(_strokeStyle);
      } else if (drawEvent is TouchLocationColorEvent) {
        _locations_colors = (_locations_colors.toBuilder()..add(drawEvent)).build();
        final allStrokes = (_strokes.toBuilder()..add(_stroke)).build();
        _strokesOut.add(allStrokes);

      } else if (drawEvent is EndTouchEvent) {
        finalizeCurrentStroke();
      } else if (drawEvent is StrokeWidthChangeEvent) {
        finalizeCurrentStroke();
        _width = drawEvent.width;
        _widthOut.add(_width);
      } else {
        throw UnimplementedError('Unknown DrawEvent type: $drawEvent');
      }
    });
  }

  Stroke get _stroke => Stroke(
        (strokeBuilder) {
          strokeBuilder
            ..strokeWidth = _width
            ..strokeStyle = _strokeStyle
            ..location_colors = _locations_colors.toBuilder();
        },
      );

  void finalizeCurrentStroke() {
    if (_locations_colors.isNotEmpty) {
      _strokes = (_strokes.toBuilder()..add(_stroke)).build();
      _strokesOut.add(_strokes);
      _locations_colors = BuiltList<TouchLocationColorEvent>();
    }
  }

  @override
  void dispose() {
    _drawEvents.close();
    _strokesSubject.close();
    _widthSubject.close();
    _styleSubject.close();
  }
}
