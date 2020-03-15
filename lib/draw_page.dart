import 'dart:async';
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
import 'package:mic_stream/mic_stream.dart';
import 'package:flutter/animation.dart';
import 'package:fft/fft.dart';




class DrawPage extends StatefulWidget {
  @override
  DrawPageState createState() => DrawPageState();
}

class DrawPageState extends State<DrawPage> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  final StrokeCap _strokeCap = StrokeCap.round;
  final List<ColorTween> tween_list = [ColorTween(begin: Colors.red[300], end: Colors.yellow[300]),
                                    ColorTween(begin: Colors.yellow[300], end: Colors.green[300]),
                                    ColorTween(begin: Colors.green[300], end: Colors.blue[300]),
                                    ColorTween(begin: Colors.blue[300], end: Colors.indigo[300]),
                                    ColorTween(begin: Colors.indigo[300], end: Colors.purple[300])];
  StreamSubscription _dbSubscription;
  Color newColor = Colors.red[300];
  bool recording = false;
  bool started = false;
  int strokeType = 1;
  Stream<List<int>> stream;
  final AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;
  final SAMPLE_RATE = 32000;
  final LOGS = [math.log(2), math.log(3), math.log(4), math.log(5),math.log(6), math.log(7)];

  // Start listening to the stream


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

    //startRecorder();

  }

  void startRecorder() {
    stream = microphone(
        audioSource: AudioSource.DEFAULT,
        sampleRate: SAMPLE_RATE,
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: AUDIO_FORMAT);
    recording = true;

    print('recording!');

  }

  List<num> frequency_projection(num x, num param1, num param2, int sample_rate){
    //return math.sqrt(x)*param1/math.sqrt(param2);
    //return x*param1/param2; //math.sqrt(x+1)*param1/math.sqrt(param2);
    final return_val = List<double>(6);
    final  n_harmonics = 6;

    for ( var i = 0; i < n_harmonics; i++ ){
      return_val[i] = ((math.log((x+1)*sample_rate/param2)/LOGS[i])%1)*param1;
    }
    return return_val;

  }

    @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PainterBloc>(context);

    if ( !recording && !started){
      started = true;
      startRecorder();
    }
    if (recording && (_dbSubscription == null)){


      _dbSubscription = stream.listen((samples) {
        var idx;
        var proj;
        Color col;

        var _red_ = 0.0;
        var _green_ = 0.0;
        var _blue_ = 0.0;


        List<num> data; // = samples;

        final windowed = Window(WindowType.HANN);
        final samples_window = windowed.apply(samples);
        data = samples;
        final end_idx = math.pow(2,(math.log(data.length)/math.log(2)).floor()).toInt();

        final freq_samples = FFT().Transform(data.sublist(0,end_idx));
        final numeric_stability = 1.0;
        var normalization_val = numeric_stability;

        bloc.drawEvent.add(ClearEvent());
        //print(freq_samples);
        for (var i=0;i < freq_samples.length/2; i++){

          proj = frequency_projection(i,tween_list.length,freq_samples.length/2,SAMPLE_RATE);
          idx = proj.floor();

          print(idx);
          print(proj);

          final lerp_val = proj - idx;
          col = tween_list[idx%tween_list.length ].lerp( lerp_val );

          final multiplier = 1 ; // i; //math.sqrt(i+1); //math.log(i/25+1).floor(); //1;
          final magnitude = math.max( math.sqrt(freq_samples[i].real*freq_samples[i].real
              +freq_samples[i].imaginary*freq_samples[i].imaginary)*multiplier, 0);
          normalization_val = normalization_val+ magnitude;

          _red_ = _red_ + col.red * magnitude;
          _green_ = _green_ + col.green * magnitude;
          _blue_ = _blue_ + col.blue * magnitude;

          setState(() {
            bloc.drawEvent.add(TouchLocationColorEvent((builder) {
              builder
                ..x = magnitude/1000
                ..y = i*.9 + 30
                ..red =  col.red
                ..blue =  col.blue
                ..green = col.green
              ;
            }));
          });

        }

        //final darkness_coefficient = math.max(0, 1.8 - math.log(   (normalization_val / 5179469) + 1) )  ;


        //final _red = math.max(0,math.min(255,(_red_*darkness_coefficient/normalization_val).floor()));
        //final _green = math.max(0,math.min(255,(_green_*darkness_coefficient/normalization_val).floor()));
        //final _blue = math.max(0,math.min(255,(_blue_*darkness_coefficient/normalization_val).floor()));
        final _red = math.max(0,math.min(255,(_red_/normalization_val).floor()));
        final _green = math.max(0,math.min(255,(_green_/normalization_val).floor()));
        final _blue = math.max(0,math.min(255,(_blue_/normalization_val).floor()));

        setState(() {
          bloc.drawEvent.add(TouchLocationColorEvent((builder) {
            builder
              ..x = 500
              ..y = 600
              ..red = _red
              ..blue = _green
              ..green = _blue
            ;
          }));
        });

      });
    }

    return Scaffold(
      body: Container(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            /*
            setState(() {
              final RenderBox object = context.findRenderObject();
              final localPosition =
                  object.globalToLocal(details.globalPosition);
              bloc.drawEvent.add(TouchLocationColorEvent((builder) {
                builder
                  ..x = localPosition.dx
                  ..y = localPosition.dy
                  ..red = newColor.red
                  ..blue = newColor.blue
                  ..green = newColor.green
                  ;

              }));
            });
            */
            ;
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
                        _controller.reverse();
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
                        startRecorder();
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
