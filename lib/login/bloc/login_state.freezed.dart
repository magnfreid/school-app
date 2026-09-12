// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState()';
}


}

/// @nodoc
class $LoginStateCopyWith<$Res>  {
$LoginStateCopyWith(LoginState _, $Res Function(LoginState) __);
}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoginStateInitial value)?  initial,TResult Function( LoginStateLoading value)?  loading,TResult Function( LoginStateSuccess value)?  success,TResult Function( LoginStateFailure value)?  failure,TResult Function( LoginStateUnexpectedFailure value)?  unexpectedFailure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoginStateInitial() when initial != null:
return initial(_that);case LoginStateLoading() when loading != null:
return loading(_that);case LoginStateSuccess() when success != null:
return success(_that);case LoginStateFailure() when failure != null:
return failure(_that);case LoginStateUnexpectedFailure() when unexpectedFailure != null:
return unexpectedFailure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoginStateInitial value)  initial,required TResult Function( LoginStateLoading value)  loading,required TResult Function( LoginStateSuccess value)  success,required TResult Function( LoginStateFailure value)  failure,required TResult Function( LoginStateUnexpectedFailure value)  unexpectedFailure,}){
final _that = this;
switch (_that) {
case LoginStateInitial():
return initial(_that);case LoginStateLoading():
return loading(_that);case LoginStateSuccess():
return success(_that);case LoginStateFailure():
return failure(_that);case LoginStateUnexpectedFailure():
return unexpectedFailure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoginStateInitial value)?  initial,TResult? Function( LoginStateLoading value)?  loading,TResult? Function( LoginStateSuccess value)?  success,TResult? Function( LoginStateFailure value)?  failure,TResult? Function( LoginStateUnexpectedFailure value)?  unexpectedFailure,}){
final _that = this;
switch (_that) {
case LoginStateInitial() when initial != null:
return initial(_that);case LoginStateLoading() when loading != null:
return loading(_that);case LoginStateSuccess() when success != null:
return success(_that);case LoginStateFailure() when failure != null:
return failure(_that);case LoginStateUnexpectedFailure() when unexpectedFailure != null:
return unexpectedFailure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  success,TResult Function()?  failure,TResult Function()?  unexpectedFailure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoginStateInitial() when initial != null:
return initial();case LoginStateLoading() when loading != null:
return loading();case LoginStateSuccess() when success != null:
return success();case LoginStateFailure() when failure != null:
return failure();case LoginStateUnexpectedFailure() when unexpectedFailure != null:
return unexpectedFailure();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  success,required TResult Function()  failure,required TResult Function()  unexpectedFailure,}) {final _that = this;
switch (_that) {
case LoginStateInitial():
return initial();case LoginStateLoading():
return loading();case LoginStateSuccess():
return success();case LoginStateFailure():
return failure();case LoginStateUnexpectedFailure():
return unexpectedFailure();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  success,TResult? Function()?  failure,TResult? Function()?  unexpectedFailure,}) {final _that = this;
switch (_that) {
case LoginStateInitial() when initial != null:
return initial();case LoginStateLoading() when loading != null:
return loading();case LoginStateSuccess() when success != null:
return success();case LoginStateFailure() when failure != null:
return failure();case LoginStateUnexpectedFailure() when unexpectedFailure != null:
return unexpectedFailure();case _:
  return null;

}
}

}

/// @nodoc


class LoginStateInitial implements LoginState {
  const LoginStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState.initial()';
}


}




/// @nodoc


class LoginStateLoading implements LoginState {
  const LoginStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState.loading()';
}


}




/// @nodoc


class LoginStateSuccess implements LoginState {
  const LoginStateSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState.success()';
}


}




/// @nodoc


class LoginStateFailure implements LoginState {
  const LoginStateFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState.failure()';
}


}




/// @nodoc


class LoginStateUnexpectedFailure implements LoginState {
  const LoginStateUnexpectedFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateUnexpectedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginState.unexpectedFailure()';
}


}




// dart format on
