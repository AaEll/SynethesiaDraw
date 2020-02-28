// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'touch_location_color.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TouchLocationColorEvent extends TouchLocationColorEvent {
  @override
  final double x;
  @override
  final double y;
  @override
  final int red;
  @override
  final int green;
  @override
  final int blue;

  factory _$TouchLocationColorEvent(
          [void Function(TouchLocationColorEventBuilder) updates]) =>
      (new TouchLocationColorEventBuilder()..update(updates)).build();

  _$TouchLocationColorEvent._({this.x, this.y, this.red, this.green, this.blue})
      : super._() {
    if (x == null) {
      throw new BuiltValueNullFieldError('TouchLocationColorEvent', 'x');
    }
    if (y == null) {
      throw new BuiltValueNullFieldError('TouchLocationColorEvent', 'y');
    }
    if (red == null) {
      throw new BuiltValueNullFieldError('TouchLocationColorEvent', 'red');
    }
    if (green == null) {
      throw new BuiltValueNullFieldError('TouchLocationColorEvent', 'green');
    }
    if (blue == null) {
      throw new BuiltValueNullFieldError('TouchLocationColorEvent', 'blue');
    }
  }

  @override
  TouchLocationColorEvent rebuild(
          void Function(TouchLocationColorEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TouchLocationColorEventBuilder toBuilder() =>
      new TouchLocationColorEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TouchLocationColorEvent &&
        x == other.x &&
        y == other.y &&
        red == other.red &&
        green == other.green &&
        blue == other.blue;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, x.hashCode), y.hashCode), red.hashCode),
            green.hashCode),
        blue.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TouchLocationColorEvent')
          ..add('x', x)
          ..add('y', y)
          ..add('red', red)
          ..add('green', green)
          ..add('blue', blue))
        .toString();
  }
}

class TouchLocationColorEventBuilder
    implements
        Builder<TouchLocationColorEvent, TouchLocationColorEventBuilder> {
  _$TouchLocationColorEvent _$v;

  double _x;
  double get x => _$this._x;
  set x(double x) => _$this._x = x;

  double _y;
  double get y => _$this._y;
  set y(double y) => _$this._y = y;

  int _red;
  int get red => _$this._red;
  set red(int red) => _$this._red = red;

  int _green;
  int get green => _$this._green;
  set green(int green) => _$this._green = green;

  int _blue;
  int get blue => _$this._blue;
  set blue(int blue) => _$this._blue = blue;

  TouchLocationColorEventBuilder();

  TouchLocationColorEventBuilder get _$this {
    if (_$v != null) {
      _x = _$v.x;
      _y = _$v.y;
      _red = _$v.red;
      _green = _$v.green;
      _blue = _$v.blue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TouchLocationColorEvent other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TouchLocationColorEvent;
  }

  @override
  void update(void Function(TouchLocationColorEventBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TouchLocationColorEvent build() {
    final _$result = _$v ??
        new _$TouchLocationColorEvent._(
            x: x, y: y, red: red, green: green, blue: blue);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
