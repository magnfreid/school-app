// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_config_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CalendarConfigState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarConfigState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CalendarConfigState()';
}


}

/// @nodoc
class $CalendarConfigStateCopyWith<$Res>  {
$CalendarConfigStateCopyWith(CalendarConfigState _, $Res Function(CalendarConfigState) __);
}


/// Adds pattern-matching-related methods to [CalendarConfigState].
extension CalendarConfigStatePatterns on CalendarConfigState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CalendarConfigStateUnknown value)?  unknown,TResult Function( CalendarConfigStateConfigured value)?  configured,TResult Function( CalendarConfigStateUnconfigured value)?  unconfigured,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CalendarConfigStateUnknown() when unknown != null:
return unknown(_that);case CalendarConfigStateConfigured() when configured != null:
return configured(_that);case CalendarConfigStateUnconfigured() when unconfigured != null:
return unconfigured(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CalendarConfigStateUnknown value)  unknown,required TResult Function( CalendarConfigStateConfigured value)  configured,required TResult Function( CalendarConfigStateUnconfigured value)  unconfigured,}){
final _that = this;
switch (_that) {
case CalendarConfigStateUnknown():
return unknown(_that);case CalendarConfigStateConfigured():
return configured(_that);case CalendarConfigStateUnconfigured():
return unconfigured(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CalendarConfigStateUnknown value)?  unknown,TResult? Function( CalendarConfigStateConfigured value)?  configured,TResult? Function( CalendarConfigStateUnconfigured value)?  unconfigured,}){
final _that = this;
switch (_that) {
case CalendarConfigStateUnknown() when unknown != null:
return unknown(_that);case CalendarConfigStateConfigured() when configured != null:
return configured(_that);case CalendarConfigStateUnconfigured() when unconfigured != null:
return unconfigured(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unknown,TResult Function( CalendarConfig config)?  configured,TResult Function()?  unconfigured,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CalendarConfigStateUnknown() when unknown != null:
return unknown();case CalendarConfigStateConfigured() when configured != null:
return configured(_that.config);case CalendarConfigStateUnconfigured() when unconfigured != null:
return unconfigured();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unknown,required TResult Function( CalendarConfig config)  configured,required TResult Function()  unconfigured,}) {final _that = this;
switch (_that) {
case CalendarConfigStateUnknown():
return unknown();case CalendarConfigStateConfigured():
return configured(_that.config);case CalendarConfigStateUnconfigured():
return unconfigured();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unknown,TResult? Function( CalendarConfig config)?  configured,TResult? Function()?  unconfigured,}) {final _that = this;
switch (_that) {
case CalendarConfigStateUnknown() when unknown != null:
return unknown();case CalendarConfigStateConfigured() when configured != null:
return configured(_that.config);case CalendarConfigStateUnconfigured() when unconfigured != null:
return unconfigured();case _:
  return null;

}
}

}

/// @nodoc


class CalendarConfigStateUnknown implements CalendarConfigState {
  const CalendarConfigStateUnknown();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarConfigStateUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CalendarConfigState.unknown()';
}


}




/// @nodoc


class CalendarConfigStateConfigured implements CalendarConfigState {
  const CalendarConfigStateConfigured(this.config);
  

 final  CalendarConfig config;

/// Create a copy of CalendarConfigState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarConfigStateConfiguredCopyWith<CalendarConfigStateConfigured> get copyWith => _$CalendarConfigStateConfiguredCopyWithImpl<CalendarConfigStateConfigured>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarConfigStateConfigured&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,config);

@override
String toString() {
  return 'CalendarConfigState.configured(config: $config)';
}


}

/// @nodoc
abstract mixin class $CalendarConfigStateConfiguredCopyWith<$Res> implements $CalendarConfigStateCopyWith<$Res> {
  factory $CalendarConfigStateConfiguredCopyWith(CalendarConfigStateConfigured value, $Res Function(CalendarConfigStateConfigured) _then) = _$CalendarConfigStateConfiguredCopyWithImpl;
@useResult
$Res call({
 CalendarConfig config
});


$CalendarConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$CalendarConfigStateConfiguredCopyWithImpl<$Res>
    implements $CalendarConfigStateConfiguredCopyWith<$Res> {
  _$CalendarConfigStateConfiguredCopyWithImpl(this._self, this._then);

  final CalendarConfigStateConfigured _self;
  final $Res Function(CalendarConfigStateConfigured) _then;

/// Create a copy of CalendarConfigState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? config = null,}) {
  return _then(CalendarConfigStateConfigured(
null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as CalendarConfig,
  ));
}

/// Create a copy of CalendarConfigState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarConfigCopyWith<$Res> get config {
  
  return $CalendarConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

/// @nodoc


class CalendarConfigStateUnconfigured implements CalendarConfigState {
  const CalendarConfigStateUnconfigured();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarConfigStateUnconfigured);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CalendarConfigState.unconfigured()';
}


}




// dart format on
