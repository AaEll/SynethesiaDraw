// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stroke_style.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StrokeStyleChangeEvent extends StrokeStyleChangeEvent {
  @override
  final int style;

  factory _$StrokeStyleChangeEvent(
          [void Function(StrokeStyleChangeEventBuilder) updates]) =>
      (new StrokeStyleChangeEventBuilder()..update(updates)).build();

  _$StrokeStyleChangeEvent._({this.style}) : super._() {
    if (style == null) {
      throw new BuiltValueNullFieldError('StrokeStyleChangeEvent', 'style');
    }
  }

  @override
  StrokeStyleChangeEvent rebuild(
          void Function(StrokeStyleChangeEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StrokeStyleChangeEventBuilder toBuilder() =>
      new StrokeStyleChangeEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StrokeStyleChangeEvent && style == other.style;
  }

  @override
  int get hashCode {
    return $jf($jc(0, style.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('StrokeStyleChangeEvent')
          ..add('style', style))
        .toString();
  }
}

class StrokeStyleChangeEventBuilder
    implements Builder<StrokeStyleChangeEvent, StrokeStyleChangeEventBuilder> {
  _$StrokeStyleChangeEvent _$v;

  int _style;
  int get style => _$this._style;
  set style(int style) => _$this._style = style;

  StrokeStyleChangeEventBuilder();

  StrokeStyleChangeEventBuilder get _$this {
    if (_$v != null) {
      _style = _$v.style;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StrokeStyleChangeEvent other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$StrokeStyleChangeEvent;
  }

  @override
  void update(void Function(StrokeStyleChangeEventBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$StrokeStyleChangeEvent build() {
    final _$result = _$v ?? new _$StrokeStyleChangeEvent._(style: style);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
