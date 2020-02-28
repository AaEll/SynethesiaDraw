import 'package:built_value/built_value.dart';
import './draw_event.dart';

// Generated code part of this Built Value.
// Generate using `flutter packages pub run build_runner build`
part 'stroke_style.g.dart';

abstract class StrokeStyleChangeEvent
    implements
        Built<StrokeStyleChangeEvent, StrokeStyleChangeEventBuilder>,
        DrawEvent {
  int get style;

  StrokeStyleChangeEvent._();
  factory StrokeStyleChangeEvent([updates(StrokeStyleChangeEventBuilder b)]) =
  _$StrokeStyleChangeEvent;
}
