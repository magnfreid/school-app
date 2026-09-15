// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CalendarConfig {

 String get calendarId; ServiceAccountKey get serviceAccountKey;
/// Create a copy of CalendarConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarConfigCopyWith<CalendarConfig> get copyWith => _$CalendarConfigCopyWithImpl<CalendarConfig>(this as CalendarConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarConfig&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.serviceAccountKey, serviceAccountKey) || other.serviceAccountKey == serviceAccountKey));
}


@override
int get hashCode => Object.hash(runtimeType,calendarId,serviceAccountKey);

@override
String toString() {
  return 'CalendarConfig(calendarId: $calendarId, serviceAccountKey: $serviceAccountKey)';
}


}

/// @nodoc
abstract mixin class $CalendarConfigCopyWith<$Res>  {
  factory $CalendarConfigCopyWith(CalendarConfig value, $Res Function(CalendarConfig) _then) = _$CalendarConfigCopyWithImpl;
@useResult
$Res call({
 String calendarId, ServiceAccountKey serviceAccountKey
});




}
/// @nodoc
class _$CalendarConfigCopyWithImpl<$Res>
    implements $CalendarConfigCopyWith<$Res> {
  _$CalendarConfigCopyWithImpl(this._self, this._then);

  final CalendarConfig _self;
  final $Res Function(CalendarConfig) _then;

/// Create a copy of CalendarConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? calendarId = null,Object? serviceAccountKey = null,}) {
  return _then(_self.copyWith(
calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,serviceAccountKey: null == serviceAccountKey ? _self.serviceAccountKey : serviceAccountKey // ignore: cast_nullable_to_non_nullable
as ServiceAccountKey,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarConfig].
extension CalendarConfigPatterns on CalendarConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarConfig value)  $default,){
final _that = this;
switch (_that) {
case _CalendarConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarConfig value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String calendarId,  ServiceAccountKey serviceAccountKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarConfig() when $default != null:
return $default(_that.calendarId,_that.serviceAccountKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String calendarId,  ServiceAccountKey serviceAccountKey)  $default,) {final _that = this;
switch (_that) {
case _CalendarConfig():
return $default(_that.calendarId,_that.serviceAccountKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String calendarId,  ServiceAccountKey serviceAccountKey)?  $default,) {final _that = this;
switch (_that) {
case _CalendarConfig() when $default != null:
return $default(_that.calendarId,_that.serviceAccountKey);case _:
  return null;

}
}

}

/// @nodoc


class _CalendarConfig implements CalendarConfig {
  const _CalendarConfig({required this.calendarId, required this.serviceAccountKey});
  

@override final  String calendarId;
@override final  ServiceAccountKey serviceAccountKey;

/// Create a copy of CalendarConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarConfigCopyWith<_CalendarConfig> get copyWith => __$CalendarConfigCopyWithImpl<_CalendarConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarConfig&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.serviceAccountKey, serviceAccountKey) || other.serviceAccountKey == serviceAccountKey));
}


@override
int get hashCode => Object.hash(runtimeType,calendarId,serviceAccountKey);

@override
String toString() {
  return 'CalendarConfig(calendarId: $calendarId, serviceAccountKey: $serviceAccountKey)';
}


}

/// @nodoc
abstract mixin class _$CalendarConfigCopyWith<$Res> implements $CalendarConfigCopyWith<$Res> {
  factory _$CalendarConfigCopyWith(_CalendarConfig value, $Res Function(_CalendarConfig) _then) = __$CalendarConfigCopyWithImpl;
@override @useResult
$Res call({
 String calendarId, ServiceAccountKey serviceAccountKey
});




}
/// @nodoc
class __$CalendarConfigCopyWithImpl<$Res>
    implements _$CalendarConfigCopyWith<$Res> {
  __$CalendarConfigCopyWithImpl(this._self, this._then);

  final _CalendarConfig _self;
  final $Res Function(_CalendarConfig) _then;

/// Create a copy of CalendarConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calendarId = null,Object? serviceAccountKey = null,}) {
  return _then(_CalendarConfig(
calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,serviceAccountKey: null == serviceAccountKey ? _self.serviceAccountKey : serviceAccountKey // ignore: cast_nullable_to_non_nullable
as ServiceAccountKey,
  ));
}


}

// dart format on
