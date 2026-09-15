// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsState()';
}


}

/// @nodoc
class $SettingsStateCopyWith<$Res>  {
$SettingsStateCopyWith(SettingsState _, $Res Function(SettingsState) __);
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingsIdle value)?  idle,TResult Function( SettingsUnsubscribing value)?  unsubscribing,TResult Function( SettingsFailure value)?  failure,TResult Function( SettingsUnsubscribed value)?  unsubscribed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingsIdle() when idle != null:
return idle(_that);case SettingsUnsubscribing() when unsubscribing != null:
return unsubscribing(_that);case SettingsFailure() when failure != null:
return failure(_that);case SettingsUnsubscribed() when unsubscribed != null:
return unsubscribed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingsIdle value)  idle,required TResult Function( SettingsUnsubscribing value)  unsubscribing,required TResult Function( SettingsFailure value)  failure,required TResult Function( SettingsUnsubscribed value)  unsubscribed,}){
final _that = this;
switch (_that) {
case SettingsIdle():
return idle(_that);case SettingsUnsubscribing():
return unsubscribing(_that);case SettingsFailure():
return failure(_that);case SettingsUnsubscribed():
return unsubscribed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingsIdle value)?  idle,TResult? Function( SettingsUnsubscribing value)?  unsubscribing,TResult? Function( SettingsFailure value)?  failure,TResult? Function( SettingsUnsubscribed value)?  unsubscribed,}){
final _that = this;
switch (_that) {
case SettingsIdle() when idle != null:
return idle(_that);case SettingsUnsubscribing() when unsubscribing != null:
return unsubscribing(_that);case SettingsFailure() when failure != null:
return failure(_that);case SettingsUnsubscribed() when unsubscribed != null:
return unsubscribed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  unsubscribing,TResult Function()?  failure,TResult Function()?  unsubscribed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingsIdle() when idle != null:
return idle();case SettingsUnsubscribing() when unsubscribing != null:
return unsubscribing();case SettingsFailure() when failure != null:
return failure();case SettingsUnsubscribed() when unsubscribed != null:
return unsubscribed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  unsubscribing,required TResult Function()  failure,required TResult Function()  unsubscribed,}) {final _that = this;
switch (_that) {
case SettingsIdle():
return idle();case SettingsUnsubscribing():
return unsubscribing();case SettingsFailure():
return failure();case SettingsUnsubscribed():
return unsubscribed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  unsubscribing,TResult? Function()?  failure,TResult? Function()?  unsubscribed,}) {final _that = this;
switch (_that) {
case SettingsIdle() when idle != null:
return idle();case SettingsUnsubscribing() when unsubscribing != null:
return unsubscribing();case SettingsFailure() when failure != null:
return failure();case SettingsUnsubscribed() when unsubscribed != null:
return unsubscribed();case _:
  return null;

}
}

}

/// @nodoc


class SettingsIdle implements SettingsState {
  const SettingsIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsState.idle()';
}


}




/// @nodoc


class SettingsUnsubscribing implements SettingsState {
  const SettingsUnsubscribing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUnsubscribing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsState.unsubscribing()';
}


}




/// @nodoc


class SettingsFailure implements SettingsState {
  const SettingsFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsState.failure()';
}


}




/// @nodoc


class SettingsUnsubscribed implements SettingsState {
  const SettingsUnsubscribed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUnsubscribed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsState.unsubscribed()';
}


}




// dart format on
