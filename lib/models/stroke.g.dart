// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stroke.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Stroke extends Stroke {
  @override
  final double strokeWidth;
  @override
  final int strokeStyle;
  @override
  final BuiltList<TouchLocationColorEvent> location_colors;

  factory _$Stroke([void Function(StrokeBuilder) updates]) =>
      (new StrokeBuilder()..update(updates)).build();

  _$Stroke._({this.strokeWidth, this.strokeStyle, this.location_colors})
      : super._() {
    if (strokeWidth == null) {
      throw new BuiltValueNullFieldError('Stroke', 'strokeWidth');
    }
    if (strokeStyle == null) {
      throw new BuiltValueNullFieldError('Stroke', 'strokeStyle');
    }
    if (location_colors == null) {
      throw new BuiltValueNullFieldError('Stroke', 'location_colors');
    }
  }

  @override
  Stroke rebuild(void Function(StrokeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StrokeBuilder toBuilder() => new StrokeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Stroke &&
        strokeWidth == other.strokeWidth &&
        strokeStyle == other.strokeStyle &&
        location_colors == other.location_colors;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, strokeWidth.hashCode), strokeStyle.hashCode),
        location_colors.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Stroke')
          ..add('strokeWidth', strokeWidth)
          ..add('strokeStyle', strokeStyle)
          ..add('location_colors', location_colors))
        .toString();
  }
}

class StrokeBuilder implements Builder<Stroke, StrokeBuilder> {
  _$Stroke _$v;

  double _strokeWidth;
  double get strokeWidth => _$this._strokeWidth;
  set strokeWidth(double strokeWidth) => _$this._strokeWidth = strokeWidth;

  int _strokeStyle;
  int get strokeStyle => _$this._strokeStyle;
  set strokeStyle(int strokeStyle) => _$this._strokeStyle = strokeStyle;

  ListBuilder<TouchLocationColorEvent> _location_colors;
  ListBuilder<TouchLocationColorEvent> get location_colors =>
      _$this._location_colors ??= new ListBuilder<TouchLocationColorEvent>();
  set location_colors(ListBuilder<TouchLocationColorEvent> location_colors) =>
      _$this._location_colors = location_colors;

  StrokeBuilder();

  StrokeBuilder get _$this {
    if (_$v != null) {
      _strokeWidth = _$v.strokeWidth;
      _strokeStyle = _$v.strokeStyle;
      _location_colors = _$v.location_colors?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Stroke other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Stroke;
  }

  @override
  void update(void Function(StrokeBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Stroke build() {
    _$Stroke _$result;
    try {
      _$result = _$v ??
          new _$Stroke._(
              strokeWidth: strokeWidth,
              strokeStyle: strokeStyle,
              location_colors: location_colors.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'location_colors';
        location_colors.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Stroke', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
