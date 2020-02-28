import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import './touch_location_color.dart';

// Generated code part of this Built Value.
// Generate using `flutter packages pub run build_runner build`
part 'stroke.g.dart';

abstract class Stroke implements Built<Stroke, StrokeBuilder> {
  double get strokeWidth;
  int get strokeStyle;
  BuiltList<TouchLocationColorEvent> get location_colors;

  Stroke._();
  factory Stroke([updates(StrokeBuilder b)]) = _$Stroke;
}
