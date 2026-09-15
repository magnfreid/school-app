// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_window.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleWindow {

 List<WeekSchedule> get weeks; DateTime get lastSyncedAt;
/// Create a copy of ScheduleWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleWindowCopyWith<ScheduleWindow> get copyWith => _$ScheduleWindowCopyWithImpl<ScheduleWindow>(this as ScheduleWindow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleWindow&&const DeepCollectionEquality().equals(other.weeks, weeks)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(weeks),lastSyncedAt);

@override
String toString() {
  return 'ScheduleWindow(weeks: $weeks, lastSyncedAt: $lastSyncedAt)';
}


}

/// @nodoc
abstract mixin class $ScheduleWindowCopyWith<$Res>  {
  factory $ScheduleWindowCopyWith(ScheduleWindow value, $Res Function(ScheduleWindow) _then) = _$ScheduleWindowCopyWithImpl;
@useResult
$Res call({
 List<WeekSchedule> weeks, DateTime lastSyncedAt
});




}
/// @nodoc
class _$ScheduleWindowCopyWithImpl<$Res>
    implements $ScheduleWindowCopyWith<$Res> {
  _$ScheduleWindowCopyWithImpl(this._self, this._then);

  final ScheduleWindow _self;
  final $Res Function(ScheduleWindow) _then;

/// Create a copy of ScheduleWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weeks = null,Object? lastSyncedAt = null,}) {
  return _then(_self.copyWith(
weeks: null == weeks ? _self.weeks : weeks // ignore: cast_nullable_to_non_nullable
as List<WeekSchedule>,lastSyncedAt: null == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleWindow].
extension ScheduleWindowPatterns on ScheduleWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleWindow value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleWindow value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WeekSchedule> weeks,  DateTime lastSyncedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleWindow() when $default != null:
return $default(_that.weeks,_that.lastSyncedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WeekSchedule> weeks,  DateTime lastSyncedAt)  $default,) {final _that = this;
switch (_that) {
case _ScheduleWindow():
return $default(_that.weeks,_that.lastSyncedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WeekSchedule> weeks,  DateTime lastSyncedAt)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleWindow() when $default != null:
return $default(_that.weeks,_that.lastSyncedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleWindow implements ScheduleWindow {
  const _ScheduleWindow({required final  List<WeekSchedule> weeks, required this.lastSyncedAt}): _weeks = weeks;
  

 final  List<WeekSchedule> _weeks;
@override List<WeekSchedule> get weeks {
  if (_weeks is EqualUnmodifiableListView) return _weeks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeks);
}

@override final  DateTime lastSyncedAt;

/// Create a copy of ScheduleWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleWindowCopyWith<_ScheduleWindow> get copyWith => __$ScheduleWindowCopyWithImpl<_ScheduleWindow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleWindow&&const DeepCollectionEquality().equals(other._weeks, _weeks)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_weeks),lastSyncedAt);

@override
String toString() {
  return 'ScheduleWindow(weeks: $weeks, lastSyncedAt: $lastSyncedAt)';
}


}

/// @nodoc
abstract mixin class _$ScheduleWindowCopyWith<$Res> implements $ScheduleWindowCopyWith<$Res> {
  factory _$ScheduleWindowCopyWith(_ScheduleWindow value, $Res Function(_ScheduleWindow) _then) = __$ScheduleWindowCopyWithImpl;
@override @useResult
$Res call({
 List<WeekSchedule> weeks, DateTime lastSyncedAt
});




}
/// @nodoc
class __$ScheduleWindowCopyWithImpl<$Res>
    implements _$ScheduleWindowCopyWith<$Res> {
  __$ScheduleWindowCopyWithImpl(this._self, this._then);

  final _ScheduleWindow _self;
  final $Res Function(_ScheduleWindow) _then;

/// Create a copy of ScheduleWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weeks = null,Object? lastSyncedAt = null,}) {
  return _then(_ScheduleWindow(
weeks: null == weeks ? _self._weeks : weeks // ignore: cast_nullable_to_non_nullable
as List<WeekSchedule>,lastSyncedAt: null == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
