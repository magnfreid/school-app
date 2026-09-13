// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'week_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeekSchedule {

 DateTime get weekStart; int get weekNumber; List<ScheduleEvent> get events; List<SpecialEvent> get specialEvents;
/// Create a copy of WeekSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekScheduleCopyWith<WeekSchedule> get copyWith => _$WeekScheduleCopyWithImpl<WeekSchedule>(this as WeekSchedule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekSchedule&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&const DeepCollectionEquality().equals(other.events, events)&&const DeepCollectionEquality().equals(other.specialEvents, specialEvents));
}


@override
int get hashCode => Object.hash(runtimeType,weekStart,weekNumber,const DeepCollectionEquality().hash(events),const DeepCollectionEquality().hash(specialEvents));

@override
String toString() {
  return 'WeekSchedule(weekStart: $weekStart, weekNumber: $weekNumber, events: $events, specialEvents: $specialEvents)';
}


}

/// @nodoc
abstract mixin class $WeekScheduleCopyWith<$Res>  {
  factory $WeekScheduleCopyWith(WeekSchedule value, $Res Function(WeekSchedule) _then) = _$WeekScheduleCopyWithImpl;
@useResult
$Res call({
 DateTime weekStart, int weekNumber, List<ScheduleEvent> events, List<SpecialEvent> specialEvents
});




}
/// @nodoc
class _$WeekScheduleCopyWithImpl<$Res>
    implements $WeekScheduleCopyWith<$Res> {
  _$WeekScheduleCopyWithImpl(this._self, this._then);

  final WeekSchedule _self;
  final $Res Function(WeekSchedule) _then;

/// Create a copy of WeekSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekStart = null,Object? weekNumber = null,Object? events = null,Object? specialEvents = null,}) {
  return _then(_self.copyWith(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<ScheduleEvent>,specialEvents: null == specialEvents ? _self.specialEvents : specialEvents // ignore: cast_nullable_to_non_nullable
as List<SpecialEvent>,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekSchedule].
extension WeekSchedulePatterns on WeekSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekSchedule value)  $default,){
final _that = this;
switch (_that) {
case _WeekSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _WeekSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime weekStart,  int weekNumber,  List<ScheduleEvent> events,  List<SpecialEvent> specialEvents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekSchedule() when $default != null:
return $default(_that.weekStart,_that.weekNumber,_that.events,_that.specialEvents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime weekStart,  int weekNumber,  List<ScheduleEvent> events,  List<SpecialEvent> specialEvents)  $default,) {final _that = this;
switch (_that) {
case _WeekSchedule():
return $default(_that.weekStart,_that.weekNumber,_that.events,_that.specialEvents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime weekStart,  int weekNumber,  List<ScheduleEvent> events,  List<SpecialEvent> specialEvents)?  $default,) {final _that = this;
switch (_that) {
case _WeekSchedule() when $default != null:
return $default(_that.weekStart,_that.weekNumber,_that.events,_that.specialEvents);case _:
  return null;

}
}

}

/// @nodoc


class _WeekSchedule implements WeekSchedule {
  const _WeekSchedule({required this.weekStart, required this.weekNumber, final  List<ScheduleEvent> events = const <ScheduleEvent>[], final  List<SpecialEvent> specialEvents = const <SpecialEvent>[]}): _events = events,_specialEvents = specialEvents;
  

@override final  DateTime weekStart;
@override final  int weekNumber;
 final  List<ScheduleEvent> _events;
@override@JsonKey() List<ScheduleEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

 final  List<SpecialEvent> _specialEvents;
@override@JsonKey() List<SpecialEvent> get specialEvents {
  if (_specialEvents is EqualUnmodifiableListView) return _specialEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specialEvents);
}


/// Create a copy of WeekSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekScheduleCopyWith<_WeekSchedule> get copyWith => __$WeekScheduleCopyWithImpl<_WeekSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekSchedule&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&const DeepCollectionEquality().equals(other._events, _events)&&const DeepCollectionEquality().equals(other._specialEvents, _specialEvents));
}


@override
int get hashCode => Object.hash(runtimeType,weekStart,weekNumber,const DeepCollectionEquality().hash(_events),const DeepCollectionEquality().hash(_specialEvents));

@override
String toString() {
  return 'WeekSchedule(weekStart: $weekStart, weekNumber: $weekNumber, events: $events, specialEvents: $specialEvents)';
}


}

/// @nodoc
abstract mixin class _$WeekScheduleCopyWith<$Res> implements $WeekScheduleCopyWith<$Res> {
  factory _$WeekScheduleCopyWith(_WeekSchedule value, $Res Function(_WeekSchedule) _then) = __$WeekScheduleCopyWithImpl;
@override @useResult
$Res call({
 DateTime weekStart, int weekNumber, List<ScheduleEvent> events, List<SpecialEvent> specialEvents
});




}
/// @nodoc
class __$WeekScheduleCopyWithImpl<$Res>
    implements _$WeekScheduleCopyWith<$Res> {
  __$WeekScheduleCopyWithImpl(this._self, this._then);

  final _WeekSchedule _self;
  final $Res Function(_WeekSchedule) _then;

/// Create a copy of WeekSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekStart = null,Object? weekNumber = null,Object? events = null,Object? specialEvents = null,}) {
  return _then(_WeekSchedule(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<ScheduleEvent>,specialEvents: null == specialEvents ? _self._specialEvents : specialEvents // ignore: cast_nullable_to_non_nullable
as List<SpecialEvent>,
  ));
}


}

// dart format on
