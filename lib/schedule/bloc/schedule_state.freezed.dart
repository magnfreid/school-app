// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NextEvent {

 ScheduleEvent get event; int get daysUntil; RelativeDay get relativeDay;
/// Create a copy of NextEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NextEventCopyWith<NextEvent> get copyWith => _$NextEventCopyWithImpl<NextEvent>(this as NextEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NextEvent&&(identical(other.event, event) || other.event == event)&&(identical(other.daysUntil, daysUntil) || other.daysUntil == daysUntil)&&(identical(other.relativeDay, relativeDay) || other.relativeDay == relativeDay));
}


@override
int get hashCode => Object.hash(runtimeType,event,daysUntil,relativeDay);

@override
String toString() {
  return 'NextEvent(event: $event, daysUntil: $daysUntil, relativeDay: $relativeDay)';
}


}

/// @nodoc
abstract mixin class $NextEventCopyWith<$Res>  {
  factory $NextEventCopyWith(NextEvent value, $Res Function(NextEvent) _then) = _$NextEventCopyWithImpl;
@useResult
$Res call({
 ScheduleEvent event, int daysUntil, RelativeDay relativeDay
});


$ScheduleEventCopyWith<$Res> get event;

}
/// @nodoc
class _$NextEventCopyWithImpl<$Res>
    implements $NextEventCopyWith<$Res> {
  _$NextEventCopyWithImpl(this._self, this._then);

  final NextEvent _self;
  final $Res Function(NextEvent) _then;

/// Create a copy of NextEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? event = null,Object? daysUntil = null,Object? relativeDay = null,}) {
  return _then(_self.copyWith(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as ScheduleEvent,daysUntil: null == daysUntil ? _self.daysUntil : daysUntil // ignore: cast_nullable_to_non_nullable
as int,relativeDay: null == relativeDay ? _self.relativeDay : relativeDay // ignore: cast_nullable_to_non_nullable
as RelativeDay,
  ));
}
/// Create a copy of NextEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleEventCopyWith<$Res> get event {
  
  return $ScheduleEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// Adds pattern-matching-related methods to [NextEvent].
extension NextEventPatterns on NextEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NextEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NextEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NextEvent value)  $default,){
final _that = this;
switch (_that) {
case _NextEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NextEvent value)?  $default,){
final _that = this;
switch (_that) {
case _NextEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScheduleEvent event,  int daysUntil,  RelativeDay relativeDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NextEvent() when $default != null:
return $default(_that.event,_that.daysUntil,_that.relativeDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScheduleEvent event,  int daysUntil,  RelativeDay relativeDay)  $default,) {final _that = this;
switch (_that) {
case _NextEvent():
return $default(_that.event,_that.daysUntil,_that.relativeDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScheduleEvent event,  int daysUntil,  RelativeDay relativeDay)?  $default,) {final _that = this;
switch (_that) {
case _NextEvent() when $default != null:
return $default(_that.event,_that.daysUntil,_that.relativeDay);case _:
  return null;

}
}

}

/// @nodoc


class _NextEvent implements NextEvent {
  const _NextEvent({required this.event, required this.daysUntil, required this.relativeDay});
  

@override final  ScheduleEvent event;
@override final  int daysUntil;
@override final  RelativeDay relativeDay;

/// Create a copy of NextEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NextEventCopyWith<_NextEvent> get copyWith => __$NextEventCopyWithImpl<_NextEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextEvent&&(identical(other.event, event) || other.event == event)&&(identical(other.daysUntil, daysUntil) || other.daysUntil == daysUntil)&&(identical(other.relativeDay, relativeDay) || other.relativeDay == relativeDay));
}


@override
int get hashCode => Object.hash(runtimeType,event,daysUntil,relativeDay);

@override
String toString() {
  return 'NextEvent(event: $event, daysUntil: $daysUntil, relativeDay: $relativeDay)';
}


}

/// @nodoc
abstract mixin class _$NextEventCopyWith<$Res> implements $NextEventCopyWith<$Res> {
  factory _$NextEventCopyWith(_NextEvent value, $Res Function(_NextEvent) _then) = __$NextEventCopyWithImpl;
@override @useResult
$Res call({
 ScheduleEvent event, int daysUntil, RelativeDay relativeDay
});


@override $ScheduleEventCopyWith<$Res> get event;

}
/// @nodoc
class __$NextEventCopyWithImpl<$Res>
    implements _$NextEventCopyWith<$Res> {
  __$NextEventCopyWithImpl(this._self, this._then);

  final _NextEvent _self;
  final $Res Function(_NextEvent) _then;

/// Create a copy of NextEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? event = null,Object? daysUntil = null,Object? relativeDay = null,}) {
  return _then(_NextEvent(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as ScheduleEvent,daysUntil: null == daysUntil ? _self.daysUntil : daysUntil // ignore: cast_nullable_to_non_nullable
as int,relativeDay: null == relativeDay ? _self.relativeDay : relativeDay // ignore: cast_nullable_to_non_nullable
as RelativeDay,
  ));
}

/// Create a copy of NextEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleEventCopyWith<$Res> get event {
  
  return $ScheduleEventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

/// @nodoc
mixin _$ScheduleDay {

 DateTime get date; bool get isToday; List<ScheduleEvent> get events; SpecialEventDay? get special;
/// Create a copy of ScheduleDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleDayCopyWith<ScheduleDay> get copyWith => _$ScheduleDayCopyWithImpl<ScheduleDay>(this as ScheduleDay, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleDay&&(identical(other.date, date) || other.date == date)&&(identical(other.isToday, isToday) || other.isToday == isToday)&&const DeepCollectionEquality().equals(other.events, events)&&(identical(other.special, special) || other.special == special));
}


@override
int get hashCode => Object.hash(runtimeType,date,isToday,const DeepCollectionEquality().hash(events),special);

@override
String toString() {
  return 'ScheduleDay(date: $date, isToday: $isToday, events: $events, special: $special)';
}


}

/// @nodoc
abstract mixin class $ScheduleDayCopyWith<$Res>  {
  factory $ScheduleDayCopyWith(ScheduleDay value, $Res Function(ScheduleDay) _then) = _$ScheduleDayCopyWithImpl;
@useResult
$Res call({
 DateTime date, bool isToday, List<ScheduleEvent> events, SpecialEventDay? special
});




}
/// @nodoc
class _$ScheduleDayCopyWithImpl<$Res>
    implements $ScheduleDayCopyWith<$Res> {
  _$ScheduleDayCopyWithImpl(this._self, this._then);

  final ScheduleDay _self;
  final $Res Function(ScheduleDay) _then;

/// Create a copy of ScheduleDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? isToday = null,Object? events = null,Object? special = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isToday: null == isToday ? _self.isToday : isToday // ignore: cast_nullable_to_non_nullable
as bool,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<ScheduleEvent>,special: freezed == special ? _self.special : special // ignore: cast_nullable_to_non_nullable
as SpecialEventDay?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleDay].
extension ScheduleDayPatterns on ScheduleDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleDay value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleDay value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  bool isToday,  List<ScheduleEvent> events,  SpecialEventDay? special)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleDay() when $default != null:
return $default(_that.date,_that.isToday,_that.events,_that.special);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  bool isToday,  List<ScheduleEvent> events,  SpecialEventDay? special)  $default,) {final _that = this;
switch (_that) {
case _ScheduleDay():
return $default(_that.date,_that.isToday,_that.events,_that.special);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  bool isToday,  List<ScheduleEvent> events,  SpecialEventDay? special)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleDay() when $default != null:
return $default(_that.date,_that.isToday,_that.events,_that.special);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleDay implements ScheduleDay {
  const _ScheduleDay({required this.date, required this.isToday, final  List<ScheduleEvent> events = const <ScheduleEvent>[], this.special}): _events = events;
  

@override final  DateTime date;
@override final  bool isToday;
 final  List<ScheduleEvent> _events;
@override@JsonKey() List<ScheduleEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

@override final  SpecialEventDay? special;

/// Create a copy of ScheduleDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleDayCopyWith<_ScheduleDay> get copyWith => __$ScheduleDayCopyWithImpl<_ScheduleDay>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleDay&&(identical(other.date, date) || other.date == date)&&(identical(other.isToday, isToday) || other.isToday == isToday)&&const DeepCollectionEquality().equals(other._events, _events)&&(identical(other.special, special) || other.special == special));
}


@override
int get hashCode => Object.hash(runtimeType,date,isToday,const DeepCollectionEquality().hash(_events),special);

@override
String toString() {
  return 'ScheduleDay(date: $date, isToday: $isToday, events: $events, special: $special)';
}


}

/// @nodoc
abstract mixin class _$ScheduleDayCopyWith<$Res> implements $ScheduleDayCopyWith<$Res> {
  factory _$ScheduleDayCopyWith(_ScheduleDay value, $Res Function(_ScheduleDay) _then) = __$ScheduleDayCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, bool isToday, List<ScheduleEvent> events, SpecialEventDay? special
});




}
/// @nodoc
class __$ScheduleDayCopyWithImpl<$Res>
    implements _$ScheduleDayCopyWith<$Res> {
  __$ScheduleDayCopyWithImpl(this._self, this._then);

  final _ScheduleDay _self;
  final $Res Function(_ScheduleDay) _then;

/// Create a copy of ScheduleDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? isToday = null,Object? events = null,Object? special = freezed,}) {
  return _then(_ScheduleDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,isToday: null == isToday ? _self.isToday : isToday // ignore: cast_nullable_to_non_nullable
as bool,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<ScheduleEvent>,special: freezed == special ? _self.special : special // ignore: cast_nullable_to_non_nullable
as SpecialEventDay?,
  ));
}


}

/// @nodoc
mixin _$ScheduleState {

 int get weekOffset;
/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleStateCopyWith<ScheduleState> get copyWith => _$ScheduleStateCopyWithImpl<ScheduleState>(this as ScheduleState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleState&&(identical(other.weekOffset, weekOffset) || other.weekOffset == weekOffset));
}


@override
int get hashCode => Object.hash(runtimeType,weekOffset);

@override
String toString() {
  return 'ScheduleState(weekOffset: $weekOffset)';
}


}

/// @nodoc
abstract mixin class $ScheduleStateCopyWith<$Res>  {
  factory $ScheduleStateCopyWith(ScheduleState value, $Res Function(ScheduleState) _then) = _$ScheduleStateCopyWithImpl;
@useResult
$Res call({
 int weekOffset
});




}
/// @nodoc
class _$ScheduleStateCopyWithImpl<$Res>
    implements $ScheduleStateCopyWith<$Res> {
  _$ScheduleStateCopyWithImpl(this._self, this._then);

  final ScheduleState _self;
  final $Res Function(ScheduleState) _then;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekOffset = null,}) {
  return _then(_self.copyWith(
weekOffset: null == weekOffset ? _self.weekOffset : weekOffset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleState].
extension ScheduleStatePatterns on ScheduleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ScheduleInitial value)?  initial,TResult Function( ScheduleLoading value)?  loading,TResult Function( ScheduleLoaded value)?  loaded,TResult Function( ScheduleFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ScheduleInitial() when initial != null:
return initial(_that);case ScheduleLoading() when loading != null:
return loading(_that);case ScheduleLoaded() when loaded != null:
return loaded(_that);case ScheduleFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ScheduleInitial value)  initial,required TResult Function( ScheduleLoading value)  loading,required TResult Function( ScheduleLoaded value)  loaded,required TResult Function( ScheduleFailure value)  failure,}){
final _that = this;
switch (_that) {
case ScheduleInitial():
return initial(_that);case ScheduleLoading():
return loading(_that);case ScheduleLoaded():
return loaded(_that);case ScheduleFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ScheduleInitial value)?  initial,TResult? Function( ScheduleLoading value)?  loading,TResult? Function( ScheduleLoaded value)?  loaded,TResult? Function( ScheduleFailure value)?  failure,}){
final _that = this;
switch (_that) {
case ScheduleInitial() when initial != null:
return initial(_that);case ScheduleLoading() when loading != null:
return loading(_that);case ScheduleLoaded() when loaded != null:
return loaded(_that);case ScheduleFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int weekOffset)?  initial,TResult Function( int weekOffset)?  loading,TResult Function( int weekOffset,  WeekSchedule week,  DateTime lastSyncedAt,  ScheduleSyncHealth syncHealth,  List<ScheduleDay> days,  NextEvent? nextEvent,  SpecialEventWholeWeek? weekSpecial)?  loaded,TResult Function( int weekOffset)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ScheduleInitial() when initial != null:
return initial(_that.weekOffset);case ScheduleLoading() when loading != null:
return loading(_that.weekOffset);case ScheduleLoaded() when loaded != null:
return loaded(_that.weekOffset,_that.week,_that.lastSyncedAt,_that.syncHealth,_that.days,_that.nextEvent,_that.weekSpecial);case ScheduleFailure() when failure != null:
return failure(_that.weekOffset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int weekOffset)  initial,required TResult Function( int weekOffset)  loading,required TResult Function( int weekOffset,  WeekSchedule week,  DateTime lastSyncedAt,  ScheduleSyncHealth syncHealth,  List<ScheduleDay> days,  NextEvent? nextEvent,  SpecialEventWholeWeek? weekSpecial)  loaded,required TResult Function( int weekOffset)  failure,}) {final _that = this;
switch (_that) {
case ScheduleInitial():
return initial(_that.weekOffset);case ScheduleLoading():
return loading(_that.weekOffset);case ScheduleLoaded():
return loaded(_that.weekOffset,_that.week,_that.lastSyncedAt,_that.syncHealth,_that.days,_that.nextEvent,_that.weekSpecial);case ScheduleFailure():
return failure(_that.weekOffset);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int weekOffset)?  initial,TResult? Function( int weekOffset)?  loading,TResult? Function( int weekOffset,  WeekSchedule week,  DateTime lastSyncedAt,  ScheduleSyncHealth syncHealth,  List<ScheduleDay> days,  NextEvent? nextEvent,  SpecialEventWholeWeek? weekSpecial)?  loaded,TResult? Function( int weekOffset)?  failure,}) {final _that = this;
switch (_that) {
case ScheduleInitial() when initial != null:
return initial(_that.weekOffset);case ScheduleLoading() when loading != null:
return loading(_that.weekOffset);case ScheduleLoaded() when loaded != null:
return loaded(_that.weekOffset,_that.week,_that.lastSyncedAt,_that.syncHealth,_that.days,_that.nextEvent,_that.weekSpecial);case ScheduleFailure() when failure != null:
return failure(_that.weekOffset);case _:
  return null;

}
}

}

/// @nodoc


class ScheduleInitial implements ScheduleState {
  const ScheduleInitial({this.weekOffset = 0});
  

@override@JsonKey() final  int weekOffset;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleInitialCopyWith<ScheduleInitial> get copyWith => _$ScheduleInitialCopyWithImpl<ScheduleInitial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleInitial&&(identical(other.weekOffset, weekOffset) || other.weekOffset == weekOffset));
}


@override
int get hashCode => Object.hash(runtimeType,weekOffset);

@override
String toString() {
  return 'ScheduleState.initial(weekOffset: $weekOffset)';
}


}

/// @nodoc
abstract mixin class $ScheduleInitialCopyWith<$Res> implements $ScheduleStateCopyWith<$Res> {
  factory $ScheduleInitialCopyWith(ScheduleInitial value, $Res Function(ScheduleInitial) _then) = _$ScheduleInitialCopyWithImpl;
@override @useResult
$Res call({
 int weekOffset
});




}
/// @nodoc
class _$ScheduleInitialCopyWithImpl<$Res>
    implements $ScheduleInitialCopyWith<$Res> {
  _$ScheduleInitialCopyWithImpl(this._self, this._then);

  final ScheduleInitial _self;
  final $Res Function(ScheduleInitial) _then;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekOffset = null,}) {
  return _then(ScheduleInitial(
weekOffset: null == weekOffset ? _self.weekOffset : weekOffset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ScheduleLoading implements ScheduleState {
  const ScheduleLoading({this.weekOffset = 0});
  

@override@JsonKey() final  int weekOffset;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleLoadingCopyWith<ScheduleLoading> get copyWith => _$ScheduleLoadingCopyWithImpl<ScheduleLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleLoading&&(identical(other.weekOffset, weekOffset) || other.weekOffset == weekOffset));
}


@override
int get hashCode => Object.hash(runtimeType,weekOffset);

@override
String toString() {
  return 'ScheduleState.loading(weekOffset: $weekOffset)';
}


}

/// @nodoc
abstract mixin class $ScheduleLoadingCopyWith<$Res> implements $ScheduleStateCopyWith<$Res> {
  factory $ScheduleLoadingCopyWith(ScheduleLoading value, $Res Function(ScheduleLoading) _then) = _$ScheduleLoadingCopyWithImpl;
@override @useResult
$Res call({
 int weekOffset
});




}
/// @nodoc
class _$ScheduleLoadingCopyWithImpl<$Res>
    implements $ScheduleLoadingCopyWith<$Res> {
  _$ScheduleLoadingCopyWithImpl(this._self, this._then);

  final ScheduleLoading _self;
  final $Res Function(ScheduleLoading) _then;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekOffset = null,}) {
  return _then(ScheduleLoading(
weekOffset: null == weekOffset ? _self.weekOffset : weekOffset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ScheduleLoaded implements ScheduleState {
  const ScheduleLoaded({required this.weekOffset, required this.week, required this.lastSyncedAt, required this.syncHealth, required final  List<ScheduleDay> days, this.nextEvent, this.weekSpecial}): _days = days;
  

@override final  int weekOffset;
 final  WeekSchedule week;
 final  DateTime lastSyncedAt;
 final  ScheduleSyncHealth syncHealth;
 final  List<ScheduleDay> _days;
 List<ScheduleDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

 final  NextEvent? nextEvent;
 final  SpecialEventWholeWeek? weekSpecial;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleLoadedCopyWith<ScheduleLoaded> get copyWith => _$ScheduleLoadedCopyWithImpl<ScheduleLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleLoaded&&(identical(other.weekOffset, weekOffset) || other.weekOffset == weekOffset)&&(identical(other.week, week) || other.week == week)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt)&&(identical(other.syncHealth, syncHealth) || other.syncHealth == syncHealth)&&const DeepCollectionEquality().equals(other._days, _days)&&(identical(other.nextEvent, nextEvent) || other.nextEvent == nextEvent)&&(identical(other.weekSpecial, weekSpecial) || other.weekSpecial == weekSpecial));
}


@override
int get hashCode => Object.hash(runtimeType,weekOffset,week,lastSyncedAt,syncHealth,const DeepCollectionEquality().hash(_days),nextEvent,weekSpecial);

@override
String toString() {
  return 'ScheduleState.loaded(weekOffset: $weekOffset, week: $week, lastSyncedAt: $lastSyncedAt, syncHealth: $syncHealth, days: $days, nextEvent: $nextEvent, weekSpecial: $weekSpecial)';
}


}

/// @nodoc
abstract mixin class $ScheduleLoadedCopyWith<$Res> implements $ScheduleStateCopyWith<$Res> {
  factory $ScheduleLoadedCopyWith(ScheduleLoaded value, $Res Function(ScheduleLoaded) _then) = _$ScheduleLoadedCopyWithImpl;
@override @useResult
$Res call({
 int weekOffset, WeekSchedule week, DateTime lastSyncedAt, ScheduleSyncHealth syncHealth, List<ScheduleDay> days, NextEvent? nextEvent, SpecialEventWholeWeek? weekSpecial
});


$WeekScheduleCopyWith<$Res> get week;$NextEventCopyWith<$Res>? get nextEvent;

}
/// @nodoc
class _$ScheduleLoadedCopyWithImpl<$Res>
    implements $ScheduleLoadedCopyWith<$Res> {
  _$ScheduleLoadedCopyWithImpl(this._self, this._then);

  final ScheduleLoaded _self;
  final $Res Function(ScheduleLoaded) _then;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekOffset = null,Object? week = null,Object? lastSyncedAt = null,Object? syncHealth = null,Object? days = null,Object? nextEvent = freezed,Object? weekSpecial = freezed,}) {
  return _then(ScheduleLoaded(
weekOffset: null == weekOffset ? _self.weekOffset : weekOffset // ignore: cast_nullable_to_non_nullable
as int,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as WeekSchedule,lastSyncedAt: null == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime,syncHealth: null == syncHealth ? _self.syncHealth : syncHealth // ignore: cast_nullable_to_non_nullable
as ScheduleSyncHealth,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<ScheduleDay>,nextEvent: freezed == nextEvent ? _self.nextEvent : nextEvent // ignore: cast_nullable_to_non_nullable
as NextEvent?,weekSpecial: freezed == weekSpecial ? _self.weekSpecial : weekSpecial // ignore: cast_nullable_to_non_nullable
as SpecialEventWholeWeek?,
  ));
}

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeekScheduleCopyWith<$Res> get week {
  
  return $WeekScheduleCopyWith<$Res>(_self.week, (value) {
    return _then(_self.copyWith(week: value));
  });
}/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NextEventCopyWith<$Res>? get nextEvent {
    if (_self.nextEvent == null) {
    return null;
  }

  return $NextEventCopyWith<$Res>(_self.nextEvent!, (value) {
    return _then(_self.copyWith(nextEvent: value));
  });
}
}

/// @nodoc


class ScheduleFailure implements ScheduleState {
  const ScheduleFailure({this.weekOffset = 0});
  

@override@JsonKey() final  int weekOffset;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleFailureCopyWith<ScheduleFailure> get copyWith => _$ScheduleFailureCopyWithImpl<ScheduleFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleFailure&&(identical(other.weekOffset, weekOffset) || other.weekOffset == weekOffset));
}


@override
int get hashCode => Object.hash(runtimeType,weekOffset);

@override
String toString() {
  return 'ScheduleState.failure(weekOffset: $weekOffset)';
}


}

/// @nodoc
abstract mixin class $ScheduleFailureCopyWith<$Res> implements $ScheduleStateCopyWith<$Res> {
  factory $ScheduleFailureCopyWith(ScheduleFailure value, $Res Function(ScheduleFailure) _then) = _$ScheduleFailureCopyWithImpl;
@override @useResult
$Res call({
 int weekOffset
});




}
/// @nodoc
class _$ScheduleFailureCopyWithImpl<$Res>
    implements $ScheduleFailureCopyWith<$Res> {
  _$ScheduleFailureCopyWithImpl(this._self, this._then);

  final ScheduleFailure _self;
  final $Res Function(ScheduleFailure) _then;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekOffset = null,}) {
  return _then(ScheduleFailure(
weekOffset: null == weekOffset ? _self.weekOffset : weekOffset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
