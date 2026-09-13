// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleEvent {

 String get id; String get title; String get subjectCode; DateTime get date; EventSeverity get severity; DateTime? get time; String? get kindLabel;
/// Create a copy of ScheduleEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleEventCopyWith<ScheduleEvent> get copyWith => _$ScheduleEventCopyWithImpl<ScheduleEvent>(this as ScheduleEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subjectCode, subjectCode) || other.subjectCode == subjectCode)&&(identical(other.date, date) || other.date == date)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.time, time) || other.time == time)&&(identical(other.kindLabel, kindLabel) || other.kindLabel == kindLabel));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subjectCode,date,severity,time,kindLabel);

@override
String toString() {
  return 'ScheduleEvent(id: $id, title: $title, subjectCode: $subjectCode, date: $date, severity: $severity, time: $time, kindLabel: $kindLabel)';
}


}

/// @nodoc
abstract mixin class $ScheduleEventCopyWith<$Res>  {
  factory $ScheduleEventCopyWith(ScheduleEvent value, $Res Function(ScheduleEvent) _then) = _$ScheduleEventCopyWithImpl;
@useResult
$Res call({
 String id, String title, String subjectCode, DateTime date, EventSeverity severity, DateTime? time, String? kindLabel
});




}
/// @nodoc
class _$ScheduleEventCopyWithImpl<$Res>
    implements $ScheduleEventCopyWith<$Res> {
  _$ScheduleEventCopyWithImpl(this._self, this._then);

  final ScheduleEvent _self;
  final $Res Function(ScheduleEvent) _then;

/// Create a copy of ScheduleEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subjectCode = null,Object? date = null,Object? severity = null,Object? time = freezed,Object? kindLabel = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subjectCode: null == subjectCode ? _self.subjectCode : subjectCode // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as EventSeverity,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime?,kindLabel: freezed == kindLabel ? _self.kindLabel : kindLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleEvent].
extension ScheduleEventPatterns on ScheduleEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleEvent value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleEvent value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String subjectCode,  DateTime date,  EventSeverity severity,  DateTime? time,  String? kindLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleEvent() when $default != null:
return $default(_that.id,_that.title,_that.subjectCode,_that.date,_that.severity,_that.time,_that.kindLabel);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String subjectCode,  DateTime date,  EventSeverity severity,  DateTime? time,  String? kindLabel)  $default,) {final _that = this;
switch (_that) {
case _ScheduleEvent():
return $default(_that.id,_that.title,_that.subjectCode,_that.date,_that.severity,_that.time,_that.kindLabel);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String subjectCode,  DateTime date,  EventSeverity severity,  DateTime? time,  String? kindLabel)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleEvent() when $default != null:
return $default(_that.id,_that.title,_that.subjectCode,_that.date,_that.severity,_that.time,_that.kindLabel);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleEvent implements ScheduleEvent {
  const _ScheduleEvent({required this.id, required this.title, required this.subjectCode, required this.date, required this.severity, this.time, this.kindLabel});
  

@override final  String id;
@override final  String title;
@override final  String subjectCode;
@override final  DateTime date;
@override final  EventSeverity severity;
@override final  DateTime? time;
@override final  String? kindLabel;

/// Create a copy of ScheduleEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleEventCopyWith<_ScheduleEvent> get copyWith => __$ScheduleEventCopyWithImpl<_ScheduleEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subjectCode, subjectCode) || other.subjectCode == subjectCode)&&(identical(other.date, date) || other.date == date)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.time, time) || other.time == time)&&(identical(other.kindLabel, kindLabel) || other.kindLabel == kindLabel));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subjectCode,date,severity,time,kindLabel);

@override
String toString() {
  return 'ScheduleEvent(id: $id, title: $title, subjectCode: $subjectCode, date: $date, severity: $severity, time: $time, kindLabel: $kindLabel)';
}


}

/// @nodoc
abstract mixin class _$ScheduleEventCopyWith<$Res> implements $ScheduleEventCopyWith<$Res> {
  factory _$ScheduleEventCopyWith(_ScheduleEvent value, $Res Function(_ScheduleEvent) _then) = __$ScheduleEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String subjectCode, DateTime date, EventSeverity severity, DateTime? time, String? kindLabel
});




}
/// @nodoc
class __$ScheduleEventCopyWithImpl<$Res>
    implements _$ScheduleEventCopyWith<$Res> {
  __$ScheduleEventCopyWithImpl(this._self, this._then);

  final _ScheduleEvent _self;
  final $Res Function(_ScheduleEvent) _then;

/// Create a copy of ScheduleEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subjectCode = null,Object? date = null,Object? severity = null,Object? time = freezed,Object? kindLabel = freezed,}) {
  return _then(_ScheduleEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subjectCode: null == subjectCode ? _self.subjectCode : subjectCode // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as EventSeverity,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime?,kindLabel: freezed == kindLabel ? _self.kindLabel : kindLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
