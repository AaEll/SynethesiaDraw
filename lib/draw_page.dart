import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';
import 'dart:typed_data';

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
import 'package:smart_signal_processing/smart_signal_processing.dart';
import 'package:color_models/color_models.dart';




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
  StreamSubscription _dbSubscription;
  Color oldColor = Colors.red[300];
  Color newColor = Colors.red[300];
  bool recording = false;
  int strokeType = 1;
  Stream<List<int>> stream;
  final AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;
  final SAMPLE_RATE = 16000;


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


    startRecorder();

  }

  double frequency_projection(num x, num max, num norm){
    //return math.sqrt(x)*param1/math.sqrt(param2);
    return (x*max/norm)%max; //math.sqrt(x+1)*param1/math.sqrt(param2);
    //return return_val;
  }


  void startRecorder() async{

    stream = microphone(
        audioSource: AudioSource.DEFAULT,
        sampleRate: 16000,
        channelConfig: ChannelConfig.CHANNEL_IN_MONO,
        audioFormat: AUDIO_FORMAT);
    recording = true;

    print('recording');

    _dbSubscription = stream.listen((samples) {
      var end_idx = math.pow(2,(math.log(samples.length)/math.log(2)).floor()).toInt();

      // convert (Array<Int> to Float64List)
      var real = Float64List.fromList(samples.sublist(0,end_idx).map((v) => v.toDouble() ).toList());
      var imag = Float64List(real.length); // array of 0's for imaginary part

      final decayFactor = -3.0 / (real.length - 1);
      WinFunc.expMult(real, decayFactor, false, '0');

      // FFT transform inplace
      FFT.transform(real, imag);
      end_idx =  real.length~/2;
      real = real.sublist(0,end_idx);
      imag = imag.sublist(0,end_idx);
      // run again for fundamental frequencies
      //FFT.transform(real,imag);
      //end_idx = end_idx~/2;
      //real = real.sublist(0,end_idx);
      //imag = imag.sublist(0,end_idx);

      final numeric_stability = 1.0;

      var wt_sum = 0.0;
      var normalization_val = numeric_stability;

      //print(freq_samples);
      for (var i=0;i < end_idx; i++){

        final magnitude = math.sqrt(real[i]*real[i] + imag[i]*imag[i]);
        normalization_val = normalization_val+ magnitude;

        final projection = frequency_projection(i, 360, end_idx);

        final col = HspColor(projection.floor(), 50, 50).toRgbColor();

        wt_sum = wt_sum + projection*magnitude ;
      }

      final mean_idx = wt_sum/normalization_val;

      final brightness = math.min(100,60*math.max(0, 5 - math.log(normalization_val)/4 ) ) ;

      final saturation = 50;

      final hue = (math.sqrt(mean_idx)*math.log(normalization_val)*4).floor()%360;

      print({hue,brightness,saturation});

      final color = RgbColor.from(HspColor(hue,saturation,brightness));

      final _red = color.red;
      final _green = color.green;
      final _blue = color.blue;

      setState(() {
        oldColor = newColor;
        newColor = Color.fromARGB(255, _red, _green, _blue);
      });
    });
  }

    @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PainterBloc>(context);

    /*if (recording && (_dbPeakSubscription == null))    }*/

    return Scaffold(
      body: Container(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
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
          },



          onPanEnd: (DragEndDetails details) =>
              bloc.drawEvent.add(EndTouchEvent()),
          child: StreamBuilder<BuiltList<Stroke>>(
            stream: bloc.strokes,
            builder: (context, snapshot) {
              return  RepaintBoundary(
                  child : CustomPaint(
                     painter: StrokesPainter(
                         strokeCap: _strokeCap, strokes: snapshot.data),
                     size: Size.infinite,
                     isComplex: true,
                     willChange: true,
                  )
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
