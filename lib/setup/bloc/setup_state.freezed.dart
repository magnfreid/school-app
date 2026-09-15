// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SetupState {

 String get calendarId; ServiceAccountKey get serviceAccountKey;
/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupStateCopyWith<SetupState> get copyWith => _$SetupStateCopyWithImpl<SetupState>(this as SetupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupState&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.serviceAccountKey, serviceAccountKey) || other.serviceAccountKey == serviceAccountKey));
}


@override
int get hashCode => Object.hash(runtimeType,calendarId,serviceAccountKey);

@override
String toString() {
  return 'SetupState(calendarId: $calendarId, serviceAccountKey: $serviceAccountKey)';
}


}

/// @nodoc
abstract mixin class $SetupStateCopyWith<$Res>  {
  factory $SetupStateCopyWith(SetupState value, $Res Function(SetupState) _then) = _$SetupStateCopyWithImpl;
@useResult
$Res call({
 String calendarId, ServiceAccountKey serviceAccountKey
});




}
/// @nodoc
class _$SetupStateCopyWithImpl<$Res>
    implements $SetupStateCopyWith<$Res> {
  _$SetupStateCopyWithImpl(this._self, this._then);

  final SetupState _self;
  final $Res Function(SetupState) _then;

/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? calendarId = null,Object? serviceAccountKey = null,}) {
  return _then(_self.copyWith(
calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,serviceAccountKey: null == serviceAccountKey ? _self.serviceAccountKey : serviceAccountKey // ignore: cast_nullable_to_non_nullable
as ServiceAccountKey,
  ));
}

}


/// Adds pattern-matching-related methods to [SetupState].
extension SetupStatePatterns on SetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SetupEditing value)?  editing,TResult Function( SetupSubmitting value)?  submitting,TResult Function( SetupFailure value)?  failure,TResult Function( SetupSaved value)?  saved,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SetupEditing() when editing != null:
return editing(_that);case SetupSubmitting() when submitting != null:
return submitting(_that);case SetupFailure() when failure != null:
return failure(_that);case SetupSaved() when saved != null:
return saved(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SetupEditing value)  editing,required TResult Function( SetupSubmitting value)  submitting,required TResult Function( SetupFailure value)  failure,required TResult Function( SetupSaved value)  saved,}){
final _that = this;
switch (_that) {
case SetupEditing():
return editing(_that);case SetupSubmitting():
return submitting(_that);case SetupFailure():
return failure(_that);case SetupSaved():
return saved(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SetupEditing value)?  editing,TResult? Function( SetupSubmitting value)?  submitting,TResult? Function( SetupFailure value)?  failure,TResult? Function( SetupSaved value)?  saved,}){
final _that = this;
switch (_that) {
case SetupEditing() when editing != null:
return editing(_that);case SetupSubmitting() when submitting != null:
return submitting(_that);case SetupFailure() when failure != null:
return failure(_that);case SetupSaved() when saved != null:
return saved(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String calendarId,  ServiceAccountKey serviceAccountKey,  SetupFieldError? calendarIdError,  SetupFieldError? serviceAccountKeyError)?  editing,TResult Function( String calendarId,  ServiceAccountKey serviceAccountKey)?  submitting,TResult Function( String calendarId,  ServiceAccountKey serviceAccountKey)?  failure,TResult Function( String calendarId,  ServiceAccountKey serviceAccountKey)?  saved,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SetupEditing() when editing != null:
return editing(_that.calendarId,_that.serviceAccountKey,_that.calendarIdError,_that.serviceAccountKeyError);case SetupSubmitting() when submitting != null:
return submitting(_that.calendarId,_that.serviceAccountKey);case SetupFailure() when failure != null:
return failure(_that.calendarId,_that.serviceAccountKey);case SetupSaved() when saved != null:
return saved(_that.calendarId,_that.serviceAccountKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String calendarId,  ServiceAccountKey serviceAccountKey,  SetupFieldError? calendarIdError,  SetupFieldError? serviceAccountKeyError)  editing,required TResult Function( String calendarId,  ServiceAccountKey serviceAccountKey)  submitting,required TResult Function( String calendarId,  ServiceAccountKey serviceAccountKey)  failure,required TResult Function( String calendarId,  ServiceAccountKey serviceAccountKey)  saved,}) {final _that = this;
switch (_that) {
case SetupEditing():
return editing(_that.calendarId,_that.serviceAccountKey,_that.calendarIdError,_that.serviceAccountKeyError);case SetupSubmitting():
return submitting(_that.calendarId,_that.serviceAccountKey);case SetupFailure():
return failure(_that.calendarId,_that.serviceAccountKey);case SetupSaved():
return saved(_that.calendarId,_that.serviceAccountKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String calendarId,  ServiceAccountKey serviceAccountKey,  SetupFieldError? calendarIdError,  SetupFieldError? serviceAccountKeyError)?  editing,TResult? Function( String calendarId,  ServiceAccountKey serviceAccountKey)?  submitting,TResult? Function( String calendarId,  ServiceAccountKey serviceAccountKey)?  failure,TResult? Function( String calendarId,  ServiceAccountKey serviceAccountKey)?  saved,}) {final _that = this;
switch (_that) {
case SetupEditing() when editing != null:
return editing(_that.calendarId,_that.serviceAccountKey,_that.calendarIdError,_that.serviceAccountKeyError);case SetupSubmitting() when submitting != null:
return submitting(_that.calendarId,_that.serviceAccountKey);case SetupFailure() when failure != null:
return failure(_that.calendarId,_that.serviceAccountKey);case SetupSaved() when saved != null:
return saved(_that.calendarId,_that.serviceAccountKey);case _:
  return null;

}
}

}

/// @nodoc


class SetupEditing implements SetupState {
  const SetupEditing({this.calendarId = '', this.serviceAccountKey = const ServiceAccountKey(''), this.calendarIdError, this.serviceAccountKeyError});
  

@override@JsonKey() final  String calendarId;
@override@JsonKey() final  ServiceAccountKey serviceAccountKey;
 final  SetupFieldError? calendarIdError;
 final  SetupFieldError? serviceAccountKeyError;

/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupEditingCopyWith<SetupEditing> get copyWith => _$SetupEditingCopyWithImpl<SetupEditing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupEditing&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.serviceAccountKey, serviceAccountKey) || other.serviceAccountKey == serviceAccountKey)&&(identical(other.calendarIdError, calendarIdError) || other.calendarIdError == calendarIdError)&&(identical(other.serviceAccountKeyError, serviceAccountKeyError) || other.serviceAccountKeyError == serviceAccountKeyError));
}


@override
int get hashCode => Object.hash(runtimeType,calendarId,serviceAccountKey,calendarIdError,serviceAccountKeyError);

@override
String toString() {
  return 'SetupState.editing(calendarId: $calendarId, serviceAccountKey: $serviceAccountKey, calendarIdError: $calendarIdError, serviceAccountKeyError: $serviceAccountKeyError)';
}


}

/// @nodoc
abstract mixin class $SetupEditingCopyWith<$Res> implements $SetupStateCopyWith<$Res> {
  factory $SetupEditingCopyWith(SetupEditing value, $Res Function(SetupEditing) _then) = _$SetupEditingCopyWithImpl;
@override @useResult
$Res call({
 String calendarId, ServiceAccountKey serviceAccountKey, SetupFieldError? calendarIdError, SetupFieldError? serviceAccountKeyError
});




}
/// @nodoc
class _$SetupEditingCopyWithImpl<$Res>
    implements $SetupEditingCopyWith<$Res> {
  _$SetupEditingCopyWithImpl(this._self, this._then);

  final SetupEditing _self;
  final $Res Function(SetupEditing) _then;

/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calendarId = null,Object? serviceAccountKey = null,Object? calendarIdError = freezed,Object? serviceAccountKeyError = freezed,}) {
  return _then(SetupEditing(
calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,serviceAccountKey: null == serviceAccountKey ? _self.serviceAccountKey : serviceAccountKey // ignore: cast_nullable_to_non_nullable
as ServiceAccountKey,calendarIdError: freezed == calendarIdError ? _self.calendarIdError : calendarIdError // ignore: cast_nullable_to_non_nullable
as SetupFieldError?,serviceAccountKeyError: freezed == serviceAccountKeyError ? _self.serviceAccountKeyError : serviceAccountKeyError // ignore: cast_nullable_to_non_nullable
as SetupFieldError?,
  ));
}


}

/// @nodoc


class SetupSubmitting implements SetupState {
  const SetupSubmitting({required this.calendarId, required this.serviceAccountKey});
  

@override final  String calendarId;
@override final  ServiceAccountKey serviceAccountKey;

/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupSubmittingCopyWith<SetupSubmitting> get copyWith => _$SetupSubmittingCopyWithImpl<SetupSubmitting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupSubmitting&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.serviceAccountKey, serviceAccountKey) || other.serviceAccountKey == serviceAccountKey));
}


@override
int get hashCode => Object.hash(runtimeType,calendarId,serviceAccountKey);

@override
String toString() {
  return 'SetupState.submitting(calendarId: $calendarId, serviceAccountKey: $serviceAccountKey)';
}


}

/// @nodoc
abstract mixin class $SetupSubmittingCopyWith<$Res> implements $SetupStateCopyWith<$Res> {
  factory $SetupSubmittingCopyWith(SetupSubmitting value, $Res Function(SetupSubmitting) _then) = _$SetupSubmittingCopyWithImpl;
@override @useResult
$Res call({
 String calendarId, ServiceAccountKey serviceAccountKey
});




}
/// @nodoc
class _$SetupSubmittingCopyWithImpl<$Res>
    implements $SetupSubmittingCopyWith<$Res> {
  _$SetupSubmittingCopyWithImpl(this._self, this._then);

  final SetupSubmitting _self;
  final $Res Function(SetupSubmitting) _then;

/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calendarId = null,Object? serviceAccountKey = null,}) {
  return _then(SetupSubmitting(
calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,serviceAccountKey: null == serviceAccountKey ? _self.serviceAccountKey : serviceAccountKey // ignore: cast_nullable_to_non_nullable
as ServiceAccountKey,
  ));
}


}

/// @nodoc


class SetupFailure implements SetupState {
  const SetupFailure({required this.calendarId, required this.serviceAccountKey});
  

@override final  String calendarId;
@override final  ServiceAccountKey serviceAccountKey;

/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupFailureCopyWith<SetupFailure> get copyWith => _$SetupFailureCopyWithImpl<SetupFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupFailure&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.serviceAccountKey, serviceAccountKey) || other.serviceAccountKey == serviceAccountKey));
}


@override
int get hashCode => Object.hash(runtimeType,calendarId,serviceAccountKey);

@override
String toString() {
  return 'SetupState.failure(calendarId: $calendarId, serviceAccountKey: $serviceAccountKey)';
}


}

/// @nodoc
abstract mixin class $SetupFailureCopyWith<$Res> implements $SetupStateCopyWith<$Res> {
  factory $SetupFailureCopyWith(SetupFailure value, $Res Function(SetupFailure) _then) = _$SetupFailureCopyWithImpl;
@override @useResult
$Res call({
 String calendarId, ServiceAccountKey serviceAccountKey
});




}
/// @nodoc
class _$SetupFailureCopyWithImpl<$Res>
    implements $SetupFailureCopyWith<$Res> {
  _$SetupFailureCopyWithImpl(this._self, this._then);

  final SetupFailure _self;
  final $Res Function(SetupFailure) _then;

/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calendarId = null,Object? serviceAccountKey = null,}) {
  return _then(SetupFailure(
calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,serviceAccountKey: null == serviceAccountKey ? _self.serviceAccountKey : serviceAccountKey // ignore: cast_nullable_to_non_nullable
as ServiceAccountKey,
  ));
}


}

/// @nodoc


class SetupSaved implements SetupState {
  const SetupSaved({required this.calendarId, required this.serviceAccountKey});
  

@override final  String calendarId;
@override final  ServiceAccountKey serviceAccountKey;

/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupSavedCopyWith<SetupSaved> get copyWith => _$SetupSavedCopyWithImpl<SetupSaved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupSaved&&(identical(other.calendarId, calendarId) || other.calendarId == calendarId)&&(identical(other.serviceAccountKey, serviceAccountKey) || other.serviceAccountKey == serviceAccountKey));
}


@override
int get hashCode => Object.hash(runtimeType,calendarId,serviceAccountKey);

@override
String toString() {
  return 'SetupState.saved(calendarId: $calendarId, serviceAccountKey: $serviceAccountKey)';
}


}

/// @nodoc
abstract mixin class $SetupSavedCopyWith<$Res> implements $SetupStateCopyWith<$Res> {
  factory $SetupSavedCopyWith(SetupSaved value, $Res Function(SetupSaved) _then) = _$SetupSavedCopyWithImpl;
@override @useResult
$Res call({
 String calendarId, ServiceAccountKey serviceAccountKey
});




}
/// @nodoc
class _$SetupSavedCopyWithImpl<$Res>
    implements $SetupSavedCopyWith<$Res> {
  _$SetupSavedCopyWithImpl(this._self, this._then);

  final SetupSaved _self;
  final $Res Function(SetupSaved) _then;

/// Create a copy of SetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calendarId = null,Object? serviceAccountKey = null,}) {
  return _then(SetupSaved(
calendarId: null == calendarId ? _self.calendarId : calendarId // ignore: cast_nullable_to_non_nullable
as String,serviceAccountKey: null == serviceAccountKey ? _self.serviceAccountKey : serviceAccountKey // ignore: cast_nullable_to_non_nullable
as ServiceAccountKey,
  ));
}


}

// dart format on
