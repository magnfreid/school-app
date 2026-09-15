// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'display_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DisplayEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplayEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DisplayEvent()';
}


}

/// @nodoc
class $DisplayEventCopyWith<$Res>  {
$DisplayEventCopyWith(DisplayEvent _, $Res Function(DisplayEvent) __);
}


/// Adds pattern-matching-related methods to [DisplayEvent].
extension DisplayEventPatterns on DisplayEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DisplayStarted value)?  started,TResult Function( DisplayPowerChanged value)?  powerChanged,TResult Function( DisplayUserInteracted value)?  userInteracted,TResult Function( DisplayIdleTimeoutElapsed value)?  idleTimeoutElapsed,TResult Function( DisplayDimLevelChecked value)?  dimLevelChecked,TResult Function( DisplayForegroundChanged value)?  foregroundChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DisplayStarted() when started != null:
return started(_that);case DisplayPowerChanged() when powerChanged != null:
return powerChanged(_that);case DisplayUserInteracted() when userInteracted != null:
return userInteracted(_that);case DisplayIdleTimeoutElapsed() when idleTimeoutElapsed != null:
return idleTimeoutElapsed(_that);case DisplayDimLevelChecked() when dimLevelChecked != null:
return dimLevelChecked(_that);case DisplayForegroundChanged() when foregroundChanged != null:
return foregroundChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DisplayStarted value)  started,required TResult Function( DisplayPowerChanged value)  powerChanged,required TResult Function( DisplayUserInteracted value)  userInteracted,required TResult Function( DisplayIdleTimeoutElapsed value)  idleTimeoutElapsed,required TResult Function( DisplayDimLevelChecked value)  dimLevelChecked,required TResult Function( DisplayForegroundChanged value)  foregroundChanged,}){
final _that = this;
switch (_that) {
case DisplayStarted():
return started(_that);case DisplayPowerChanged():
return powerChanged(_that);case DisplayUserInteracted():
return userInteracted(_that);case DisplayIdleTimeoutElapsed():
return idleTimeoutElapsed(_that);case DisplayDimLevelChecked():
return dimLevelChecked(_that);case DisplayForegroundChanged():
return foregroundChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DisplayStarted value)?  started,TResult? Function( DisplayPowerChanged value)?  powerChanged,TResult? Function( DisplayUserInteracted value)?  userInteracted,TResult? Function( DisplayIdleTimeoutElapsed value)?  idleTimeoutElapsed,TResult? Function( DisplayDimLevelChecked value)?  dimLevelChecked,TResult? Function( DisplayForegroundChanged value)?  foregroundChanged,}){
final _that = this;
switch (_that) {
case DisplayStarted() when started != null:
return started(_that);case DisplayPowerChanged() when powerChanged != null:
return powerChanged(_that);case DisplayUserInteracted() when userInteracted != null:
return userInteracted(_that);case DisplayIdleTimeoutElapsed() when idleTimeoutElapsed != null:
return idleTimeoutElapsed(_that);case DisplayDimLevelChecked() when dimLevelChecked != null:
return dimLevelChecked(_that);case DisplayForegroundChanged() when foregroundChanged != null:
return foregroundChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( bool isExternallyPowered)?  powerChanged,TResult Function()?  userInteracted,TResult Function()?  idleTimeoutElapsed,TResult Function()?  dimLevelChecked,TResult Function( bool isForeground)?  foregroundChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DisplayStarted() when started != null:
return started();case DisplayPowerChanged() when powerChanged != null:
return powerChanged(_that.isExternallyPowered);case DisplayUserInteracted() when userInteracted != null:
return userInteracted();case DisplayIdleTimeoutElapsed() when idleTimeoutElapsed != null:
return idleTimeoutElapsed();case DisplayDimLevelChecked() when dimLevelChecked != null:
return dimLevelChecked();case DisplayForegroundChanged() when foregroundChanged != null:
return foregroundChanged(_that.isForeground);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( bool isExternallyPowered)  powerChanged,required TResult Function()  userInteracted,required TResult Function()  idleTimeoutElapsed,required TResult Function()  dimLevelChecked,required TResult Function( bool isForeground)  foregroundChanged,}) {final _that = this;
switch (_that) {
case DisplayStarted():
return started();case DisplayPowerChanged():
return powerChanged(_that.isExternallyPowered);case DisplayUserInteracted():
return userInteracted();case DisplayIdleTimeoutElapsed():
return idleTimeoutElapsed();case DisplayDimLevelChecked():
return dimLevelChecked();case DisplayForegroundChanged():
return foregroundChanged(_that.isForeground);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( bool isExternallyPowered)?  powerChanged,TResult? Function()?  userInteracted,TResult? Function()?  idleTimeoutElapsed,TResult? Function()?  dimLevelChecked,TResult? Function( bool isForeground)?  foregroundChanged,}) {final _that = this;
switch (_that) {
case DisplayStarted() when started != null:
return started();case DisplayPowerChanged() when powerChanged != null:
return powerChanged(_that.isExternallyPowered);case DisplayUserInteracted() when userInteracted != null:
return userInteracted();case DisplayIdleTimeoutElapsed() when idleTimeoutElapsed != null:
return idleTimeoutElapsed();case DisplayDimLevelChecked() when dimLevelChecked != null:
return dimLevelChecked();case DisplayForegroundChanged() when foregroundChanged != null:
return foregroundChanged(_that.isForeground);case _:
  return null;

}
}

}

/// @nodoc


class DisplayStarted implements DisplayEvent {
  const DisplayStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplayStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DisplayEvent.started()';
}


}




/// @nodoc


class DisplayPowerChanged implements DisplayEvent {
  const DisplayPowerChanged({required this.isExternallyPowered});
  

 final  bool isExternallyPowered;

/// Create a copy of DisplayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisplayPowerChangedCopyWith<DisplayPowerChanged> get copyWith => _$DisplayPowerChangedCopyWithImpl<DisplayPowerChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplayPowerChanged&&(identical(other.isExternallyPowered, isExternallyPowered) || other.isExternallyPowered == isExternallyPowered));
}


@override
int get hashCode => Object.hash(runtimeType,isExternallyPowered);

@override
String toString() {
  return 'DisplayEvent.powerChanged(isExternallyPowered: $isExternallyPowered)';
}


}

/// @nodoc
abstract mixin class $DisplayPowerChangedCopyWith<$Res> implements $DisplayEventCopyWith<$Res> {
  factory $DisplayPowerChangedCopyWith(DisplayPowerChanged value, $Res Function(DisplayPowerChanged) _then) = _$DisplayPowerChangedCopyWithImpl;
@useResult
$Res call({
 bool isExternallyPowered
});




}
/// @nodoc
class _$DisplayPowerChangedCopyWithImpl<$Res>
    implements $DisplayPowerChangedCopyWith<$Res> {
  _$DisplayPowerChangedCopyWithImpl(this._self, this._then);

  final DisplayPowerChanged _self;
  final $Res Function(DisplayPowerChanged) _then;

/// Create a copy of DisplayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isExternallyPowered = null,}) {
  return _then(DisplayPowerChanged(
isExternallyPowered: null == isExternallyPowered ? _self.isExternallyPowered : isExternallyPowered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class DisplayUserInteracted implements DisplayEvent {
  const DisplayUserInteracted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplayUserInteracted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DisplayEvent.userInteracted()';
}


}




/// @nodoc


class DisplayIdleTimeoutElapsed implements DisplayEvent {
  const DisplayIdleTimeoutElapsed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplayIdleTimeoutElapsed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DisplayEvent.idleTimeoutElapsed()';
}


}




/// @nodoc


class DisplayDimLevelChecked implements DisplayEvent {
  const DisplayDimLevelChecked();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplayDimLevelChecked);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DisplayEvent.dimLevelChecked()';
}


}




/// @nodoc


class DisplayForegroundChanged implements DisplayEvent {
  const DisplayForegroundChanged({required this.isForeground});
  

 final  bool isForeground;

/// Create a copy of DisplayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisplayForegroundChangedCopyWith<DisplayForegroundChanged> get copyWith => _$DisplayForegroundChangedCopyWithImpl<DisplayForegroundChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplayForegroundChanged&&(identical(other.isForeground, isForeground) || other.isForeground == isForeground));
}


@override
int get hashCode => Object.hash(runtimeType,isForeground);

@override
String toString() {
  return 'DisplayEvent.foregroundChanged(isForeground: $isForeground)';
}


}

/// @nodoc
abstract mixin class $DisplayForegroundChangedCopyWith<$Res> implements $DisplayEventCopyWith<$Res> {
  factory $DisplayForegroundChangedCopyWith(DisplayForegroundChanged value, $Res Function(DisplayForegroundChanged) _then) = _$DisplayForegroundChangedCopyWithImpl;
@useResult
$Res call({
 bool isForeground
});




}
/// @nodoc
class _$DisplayForegroundChangedCopyWithImpl<$Res>
    implements $DisplayForegroundChangedCopyWith<$Res> {
  _$DisplayForegroundChangedCopyWithImpl(this._self, this._then);

  final DisplayForegroundChanged _self;
  final $Res Function(DisplayForegroundChanged) _then;

/// Create a copy of DisplayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isForeground = null,}) {
  return _then(DisplayForegroundChanged(
isForeground: null == isForeground ? _self.isForeground : isForeground // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
