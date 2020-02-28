import 'package:built_value/built_value.dart';
import './draw_event.dart';

// Generated code part of this Built Value.
// Generate using `flutter packages pub run build_runner build`
part 'touch_location_color.g.dart';

abstract class TouchLocationColorEvent
    implements Built<TouchLocationColorEvent, TouchLocationColorEventBuilder>, DrawEvent {
  double get x;
  double get y;
  int get red;
  int get green;
  int get blue;

  TouchLocationColorEvent._();
  factory TouchLocationColorEvent([updates(TouchLocationColorEventBuilder b)]) =
      _$TouchLocationColorEvent;
}
