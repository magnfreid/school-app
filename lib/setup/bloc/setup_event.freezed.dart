// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setup_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SetupEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SetupEvent()';
}


}

/// @nodoc
class $SetupEventCopyWith<$Res>  {
$SetupEventCopyWith(SetupEvent _, $Res Function(SetupEvent) __);
}


/// Adds pattern-matching-related methods to [SetupEvent].
extension SetupEventPatterns on SetupEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SetupCalendarIdChanged value)?  calendarIdChanged,TResult Function( SetupServiceAccountKeyChanged value)?  serviceAccountKeyChanged,TResult Function( SetupSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SetupCalendarIdChanged() when calendarIdChanged != null:
return calendarIdChanged(_that);case SetupServiceAccountKeyChanged() when serviceAccountKeyChanged != null:
return serviceAccountKeyChanged(_that);case SetupSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SetupCalendarIdChanged value)  calendarIdChanged,required TResult Function( SetupServiceAccountKeyChanged value)  serviceAccountKeyChanged,required TResult Function( SetupSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case SetupCalendarIdChanged():
return calendarIdChanged(_that);case SetupServiceAccountKeyChanged():
return serviceAccountKeyChanged(_that);case SetupSubmitted():
return submitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SetupCalendarIdChanged value)?  calendarIdChanged,TResult? Function( SetupServiceAccountKeyChanged value)?  serviceAccountKeyChanged,TResult? Function( SetupSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case SetupCalendarIdChanged() when calendarIdChanged != null:
return calendarIdChanged(_that);case SetupServiceAccountKeyChanged() when serviceAccountKeyChanged != null:
return serviceAccountKeyChanged(_that);case SetupSubmitted() when submitted != null:
return submitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  calendarIdChanged,TResult Function( String value)?  serviceAccountKeyChanged,TResult Function()?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SetupCalendarIdChanged() when calendarIdChanged != null:
return calendarIdChanged(_that.value);case SetupServiceAccountKeyChanged() when serviceAccountKeyChanged != null:
return serviceAccountKeyChanged(_that.value);case SetupSubmitted() when submitted != null:
return submitted();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  calendarIdChanged,required TResult Function( String value)  serviceAccountKeyChanged,required TResult Function()  submitted,}) {final _that = this;
switch (_that) {
case SetupCalendarIdChanged():
return calendarIdChanged(_that.value);case SetupServiceAccountKeyChanged():
return serviceAccountKeyChanged(_that.value);case SetupSubmitted():
return submitted();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  calendarIdChanged,TResult? Function( String value)?  serviceAccountKeyChanged,TResult? Function()?  submitted,}) {final _that = this;
switch (_that) {
case SetupCalendarIdChanged() when calendarIdChanged != null:
return calendarIdChanged(_that.value);case SetupServiceAccountKeyChanged() when serviceAccountKeyChanged != null:
return serviceAccountKeyChanged(_that.value);case SetupSubmitted() when submitted != null:
return submitted();case _:
  return null;

}
}

}

/// @nodoc


class SetupCalendarIdChanged implements SetupEvent {
  const SetupCalendarIdChanged(this.value);
  

 final  String value;

/// Create a copy of SetupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupCalendarIdChangedCopyWith<SetupCalendarIdChanged> get copyWith => _$SetupCalendarIdChangedCopyWithImpl<SetupCalendarIdChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupCalendarIdChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'SetupEvent.calendarIdChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $SetupCalendarIdChangedCopyWith<$Res> implements $SetupEventCopyWith<$Res> {
  factory $SetupCalendarIdChangedCopyWith(SetupCalendarIdChanged value, $Res Function(SetupCalendarIdChanged) _then) = _$SetupCalendarIdChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$SetupCalendarIdChangedCopyWithImpl<$Res>
    implements $SetupCalendarIdChangedCopyWith<$Res> {
  _$SetupCalendarIdChangedCopyWithImpl(this._self, this._then);

  final SetupCalendarIdChanged _self;
  final $Res Function(SetupCalendarIdChanged) _then;

/// Create a copy of SetupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(SetupCalendarIdChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SetupServiceAccountKeyChanged implements SetupEvent {
  const SetupServiceAccountKeyChanged(this.value);
  

 final  String value;

/// Create a copy of SetupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetupServiceAccountKeyChangedCopyWith<SetupServiceAccountKeyChanged> get copyWith => _$SetupServiceAccountKeyChangedCopyWithImpl<SetupServiceAccountKeyChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupServiceAccountKeyChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'SetupEvent.serviceAccountKeyChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $SetupServiceAccountKeyChangedCopyWith<$Res> implements $SetupEventCopyWith<$Res> {
  factory $SetupServiceAccountKeyChangedCopyWith(SetupServiceAccountKeyChanged value, $Res Function(SetupServiceAccountKeyChanged) _then) = _$SetupServiceAccountKeyChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$SetupServiceAccountKeyChangedCopyWithImpl<$Res>
    implements $SetupServiceAccountKeyChangedCopyWith<$Res> {
  _$SetupServiceAccountKeyChangedCopyWithImpl(this._self, this._then);

  final SetupServiceAccountKeyChanged _self;
  final $Res Function(SetupServiceAccountKeyChanged) _then;

/// Create a copy of SetupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(SetupServiceAccountKeyChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SetupSubmitted implements SetupEvent {
  const SetupSubmitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetupSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SetupEvent.submitted()';
}


}




// dart format on
