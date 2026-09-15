// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'display_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DisplayState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplayState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DisplayState()';
}


}

/// @nodoc
class $DisplayStateCopyWith<$Res>  {
$DisplayStateCopyWith(DisplayState _, $Res Function(DisplayState) __);
}


/// Adds pattern-matching-related methods to [DisplayState].
extension DisplayStatePatterns on DisplayState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DisplayReleased value)?  released,TResult Function( DisplayAwake value)?  awake,TResult Function( DisplayDimmed value)?  dimmed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DisplayReleased() when released != null:
return released(_that);case DisplayAwake() when awake != null:
return awake(_that);case DisplayDimmed() when dimmed != null:
return dimmed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DisplayReleased value)  released,required TResult Function( DisplayAwake value)  awake,required TResult Function( DisplayDimmed value)  dimmed,}){
final _that = this;
switch (_that) {
case DisplayReleased():
return released(_that);case DisplayAwake():
return awake(_that);case DisplayDimmed():
return dimmed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DisplayReleased value)?  released,TResult? Function( DisplayAwake value)?  awake,TResult? Function( DisplayDimmed value)?  dimmed,}){
final _that = this;
switch (_that) {
case DisplayReleased() when released != null:
return released(_that);case DisplayAwake() when awake != null:
return awake(_that);case DisplayDimmed() when dimmed != null:
return dimmed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  released,TResult Function()?  awake,TResult Function( DisplayDimLevel level)?  dimmed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DisplayReleased() when released != null:
return released();case DisplayAwake() when awake != null:
return awake();case DisplayDimmed() when dimmed != null:
return dimmed(_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  released,required TResult Function()  awake,required TResult Function( DisplayDimLevel level)  dimmed,}) {final _that = this;
switch (_that) {
case DisplayReleased():
return released();case DisplayAwake():
return awake();case DisplayDimmed():
return dimmed(_that.level);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  released,TResult? Function()?  awake,TResult? Function( DisplayDimLevel level)?  dimmed,}) {final _that = this;
switch (_that) {
case DisplayReleased() when released != null:
return released();case DisplayAwake() when awake != null:
return awake();case DisplayDimmed() when dimmed != null:
return dimmed(_that.level);case _:
  return null;

}
}

}

/// @nodoc


class DisplayReleased implements DisplayState {
  const DisplayReleased();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplayReleased);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DisplayState.released()';
}


}




/// @nodoc


class DisplayAwake implements DisplayState {
  const DisplayAwake();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplayAwake);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DisplayState.awake()';
}


}




/// @nodoc


class DisplayDimmed implements DisplayState {
  const DisplayDimmed(this.level);
  

 final  DisplayDimLevel level;

/// Create a copy of DisplayState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisplayDimmedCopyWith<DisplayDimmed> get copyWith => _$DisplayDimmedCopyWithImpl<DisplayDimmed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplayDimmed&&(identical(other.level, level) || other.level == level));
}


@override
int get hashCode => Object.hash(runtimeType,level);

@override
String toString() {
  return 'DisplayState.dimmed(level: $level)';
}


}

/// @nodoc
abstract mixin class $DisplayDimmedCopyWith<$Res> implements $DisplayStateCopyWith<$Res> {
  factory $DisplayDimmedCopyWith(DisplayDimmed value, $Res Function(DisplayDimmed) _then) = _$DisplayDimmedCopyWithImpl;
@useResult
$Res call({
 DisplayDimLevel level
});




}
/// @nodoc
class _$DisplayDimmedCopyWithImpl<$Res>
    implements $DisplayDimmedCopyWith<$Res> {
  _$DisplayDimmedCopyWithImpl(this._self, this._then);

  final DisplayDimmed _self;
  final $Res Function(DisplayDimmed) _then;

/// Create a copy of DisplayState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? level = null,}) {
  return _then(DisplayDimmed(
null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as DisplayDimLevel,
  ));
}


}

// dart format on
