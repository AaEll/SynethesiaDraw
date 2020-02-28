import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:built_collection/built_collection.dart';
import 'package:drawapp/bloc/painter_bloc.dart';
import 'package:drawapp/dialogs/width_dialog.dart';
import 'package:drawapp/models/stroke_style.dart';
import 'package:drawapp/models/clear.dart';
import 'package:drawapp/models/end_touch.dart';
import 'package:drawapp/models/stroke.dart';
import 'package:drawapp/models/stroke_width.dart';
import 'package:drawapp/models/touch_location_color.dart';
import 'package:drawapp/strokes_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:flutter/animation.dart';



class DrawPage extends StatefulWidget {
  @override
  DrawPageState createState() => DrawPageState();
}

class DrawPageState extends State<DrawPage> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  final StrokeCap _strokeCap = StrokeCap.round;
  final List<ColorTween> tween_list = [ColorTween(begin: Colors.red[300], end: Colors.orange[300]),
                                    ColorTween(begin: Colors.orange[300], end: Colors.green[300]),
                                    ColorTween(begin: Colors.green[300], end: Colors.blue[300]),
                                    ColorTween(begin: Colors.blue[300], end: Colors.indigo[300]),
                                    ColorTween(begin: Colors.indigo[300], end: Colors.purple[300]),
                                    ColorTween(begin: Colors.indigo[300], end: Colors.grey[300])];
  StreamSubscription _dbPeakSubscription;
  FlutterSound flutterSound;
  Color newColor = Colors.red[300];
  bool recording = false;
  int strokeType = 1;
  final t_CODEC _codec = t_CODEC.CODEC_AAC;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    // The widgets returned by build(...) change when animationStatus changes
    _controller.addStatusListener((newAnimationStatus) {
      if (newAnimationStatus != _animationStatus) {
        setState(() {
          _animationStatus = newAnimationStatus;
        });
      }
    });

    flutterSound = FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.04);
    flutterSound.setDbLevelEnabled(true);

    startRecorder();

  }

  void startRecorder() async{

    var tempDir = await getTemporaryDirectory();

    await flutterSound.startRecorder(
      uri: '${tempDir.path}/sound.aac',
      codec: _codec,
    );

    recording = true;

  }

    @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PainterBloc>(context);
    if (recording && (_dbPeakSubscription == null)){
      _dbPeakSubscription = flutterSound.onRecorderDbPeakChanged.listen( (value){
        final idx = value ~/20;
        final lerp_val = (value - 20*idx)/20;
        setState(() {
          newColor = tween_list[idx].lerp( lerp_val );
        });
      }

      );
    }

    return Scaffold(
      body: Container(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              final RenderBox object = context.findRenderObject();
              final localPosition =
                  object.globalToLocal(details.globalPosition);
              bloc.drawEvent.add(TouchLocationColorEvent((builder) {
                if (recording){
                builder
                  ..x = localPosition.dx
                  ..y = localPosition.dy
                  ..red = newColor.red
                  ..blue = newColor.blue
                  ..green = newColor.green
                  ;
                }

              }));
            });
          },
          onPanEnd: (DragEndDetails details) =>
              bloc.drawEvent.add(EndTouchEvent()),
          child: StreamBuilder<BuiltList<Stroke>>(
            stream: bloc.strokes,
            builder: (context, snapshot) {
              return CustomPaint(
                painter: StrokesPainter(
                    strokeCap: _strokeCap, strokes: snapshot.data),
                size: Size.infinite,
              );
            },
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          !_controller.isDismissed
              ? Container(
                  height: 70.0,
                  width: 56.0,
                  alignment: FractionalOffset.topCenter,
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _controller,
                      curve: Interval(0.0, 1.0 - 0 / 3 / 2.0,
                          curve: Curves.easeOut),
                    ),
                    child: FloatingActionButton(
                      mini: true,
                      child: Icon(Icons.clear),
                      onPressed: () {
                        bloc.drawEvent.add(ClearEvent());
                      },
                    ),
                  ),
                )
              : null,
          !_controller.isDismissed && (strokeType != 1)
              ? Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.0, 1.0 - 2 / 3 / 2.0,
                        curve: Curves.easeOut),
                  ),
                  child: FloatingActionButton(
                      mini: true,
                      child: Icon(Icons.gesture),
                      onPressed: () {
                        setState(() {
                          strokeType = 1;
                        });
                        _controller.reverse();
                        bloc.drawEvent.add(StrokeStyleChangeEvent((builder) {
                          builder.style = strokeType;
                        }));
                      }
                  )
              )
          )
              : null,
          !_controller.isDismissed && (strokeType != 0)
              ? Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.0, 1.0 - 2 / 3 / 2.0,
                        curve: Curves.easeOut),
                  ),
                  child: FloatingActionButton(
                      mini: true,
                      child: Icon(Icons.scatter_plot),
                      onPressed: () {
                        setState(() {
                          strokeType = 0;
                        });
                        _controller.reverse();
                        bloc.drawEvent.add(StrokeStyleChangeEvent((builder) {
                          builder.style = strokeType;
                        }));
                      }
                  )
              )
          )
              : null,
          !_controller.isDismissed
              ? Container(
                  height: 70.0,
                  width: 56.0,
                  alignment: FractionalOffset.topCenter,
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _controller,
                      curve: Interval(0.0, 1.0 - 1 / 3 / 2.0,
                          curve: Curves.easeOut),
                    ),
                    child: FloatingActionButton(
                      mini: true,
                      child: Icon(Icons.lens),
                      onPressed: () async {
                        final strokeWidth = bloc.width.value;
                        final newWidth = await showDialog(
                            context: context,
                            builder: (context) =>
                                WidthDialog(strokeWidth: strokeWidth));
                        if (newWidth != null) {
                          bloc.drawEvent.add(StrokeWidthChangeEvent((builder) {
                            builder.width = newWidth;
                          }));
                        }
                      },
                    ),
                  ),
                )
              : null,
          FloatingActionButton(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return Transform(
                  transform:
                      Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: Icon(Icons.format_paint),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ].where((widget) => widget != null).toList(),
      ),
    );
  }
}
