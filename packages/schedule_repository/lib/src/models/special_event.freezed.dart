// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'special_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpecialEvent {

 String get title; SpecialEventColorPreset get colorPreset;
/// Create a copy of SpecialEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecialEventCopyWith<SpecialEvent> get copyWith => _$SpecialEventCopyWithImpl<SpecialEvent>(this as SpecialEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecialEvent&&(identical(other.title, title) || other.title == title)&&(identical(other.colorPreset, colorPreset) || other.colorPreset == colorPreset));
}


@override
int get hashCode => Object.hash(runtimeType,title,colorPreset);

@override
String toString() {
  return 'SpecialEvent(title: $title, colorPreset: $colorPreset)';
}


}

/// @nodoc
abstract mixin class $SpecialEventCopyWith<$Res>  {
  factory $SpecialEventCopyWith(SpecialEvent value, $Res Function(SpecialEvent) _then) = _$SpecialEventCopyWithImpl;
@useResult
$Res call({
 String title, SpecialEventColorPreset colorPreset
});




}
/// @nodoc
class _$SpecialEventCopyWithImpl<$Res>
    implements $SpecialEventCopyWith<$Res> {
  _$SpecialEventCopyWithImpl(this._self, this._then);

  final SpecialEvent _self;
  final $Res Function(SpecialEvent) _then;

/// Create a copy of SpecialEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? colorPreset = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,colorPreset: null == colorPreset ? _self.colorPreset : colorPreset // ignore: cast_nullable_to_non_nullable
as SpecialEventColorPreset,
  ));
}

}


/// Adds pattern-matching-related methods to [SpecialEvent].
extension SpecialEventPatterns on SpecialEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SpecialEventWholeWeek value)?  wholeWeek,TResult Function( SpecialEventDay value)?  day,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SpecialEventWholeWeek() when wholeWeek != null:
return wholeWeek(_that);case SpecialEventDay() when day != null:
return day(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SpecialEventWholeWeek value)  wholeWeek,required TResult Function( SpecialEventDay value)  day,}){
final _that = this;
switch (_that) {
case SpecialEventWholeWeek():
return wholeWeek(_that);case SpecialEventDay():
return day(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SpecialEventWholeWeek value)?  wholeWeek,TResult? Function( SpecialEventDay value)?  day,}){
final _that = this;
switch (_that) {
case SpecialEventWholeWeek() when wholeWeek != null:
return wholeWeek(_that);case SpecialEventDay() when day != null:
return day(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String title,  SpecialEventColorPreset colorPreset)?  wholeWeek,TResult Function( String title,  SpecialEventColorPreset colorPreset,  DateTime date)?  day,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SpecialEventWholeWeek() when wholeWeek != null:
return wholeWeek(_that.title,_that.colorPreset);case SpecialEventDay() when day != null:
return day(_that.title,_that.colorPreset,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String title,  SpecialEventColorPreset colorPreset)  wholeWeek,required TResult Function( String title,  SpecialEventColorPreset colorPreset,  DateTime date)  day,}) {final _that = this;
switch (_that) {
case SpecialEventWholeWeek():
return wholeWeek(_that.title,_that.colorPreset);case SpecialEventDay():
return day(_that.title,_that.colorPreset,_that.date);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String title,  SpecialEventColorPreset colorPreset)?  wholeWeek,TResult? Function( String title,  SpecialEventColorPreset colorPreset,  DateTime date)?  day,}) {final _that = this;
switch (_that) {
case SpecialEventWholeWeek() when wholeWeek != null:
return wholeWeek(_that.title,_that.colorPreset);case SpecialEventDay() when day != null:
return day(_that.title,_that.colorPreset,_that.date);case _:
  return null;

}
}

}

/// @nodoc


class SpecialEventWholeWeek implements SpecialEvent {
  const SpecialEventWholeWeek({required this.title, required this.colorPreset});
  

@override final  String title;
@override final  SpecialEventColorPreset colorPreset;

/// Create a copy of SpecialEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecialEventWholeWeekCopyWith<SpecialEventWholeWeek> get copyWith => _$SpecialEventWholeWeekCopyWithImpl<SpecialEventWholeWeek>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecialEventWholeWeek&&(identical(other.title, title) || other.title == title)&&(identical(other.colorPreset, colorPreset) || other.colorPreset == colorPreset));
}


@override
int get hashCode => Object.hash(runtimeType,title,colorPreset);

@override
String toString() {
  return 'SpecialEvent.wholeWeek(title: $title, colorPreset: $colorPreset)';
}


}

/// @nodoc
abstract mixin class $SpecialEventWholeWeekCopyWith<$Res> implements $SpecialEventCopyWith<$Res> {
  factory $SpecialEventWholeWeekCopyWith(SpecialEventWholeWeek value, $Res Function(SpecialEventWholeWeek) _then) = _$SpecialEventWholeWeekCopyWithImpl;
@override @useResult
$Res call({
 String title, SpecialEventColorPreset colorPreset
});




}
/// @nodoc
class _$SpecialEventWholeWeekCopyWithImpl<$Res>
    implements $SpecialEventWholeWeekCopyWith<$Res> {
  _$SpecialEventWholeWeekCopyWithImpl(this._self, this._then);

  final SpecialEventWholeWeek _self;
  final $Res Function(SpecialEventWholeWeek) _then;

/// Create a copy of SpecialEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? colorPreset = null,}) {
  return _then(SpecialEventWholeWeek(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,colorPreset: null == colorPreset ? _self.colorPreset : colorPreset // ignore: cast_nullable_to_non_nullable
as SpecialEventColorPreset,
  ));
}


}

/// @nodoc


class SpecialEventDay implements SpecialEvent {
  const SpecialEventDay({required this.title, required this.colorPreset, required this.date});
  

@override final  String title;
@override final  SpecialEventColorPreset colorPreset;
 final  DateTime date;

/// Create a copy of SpecialEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpecialEventDayCopyWith<SpecialEventDay> get copyWith => _$SpecialEventDayCopyWithImpl<SpecialEventDay>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpecialEventDay&&(identical(other.title, title) || other.title == title)&&(identical(other.colorPreset, colorPreset) || other.colorPreset == colorPreset)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,title,colorPreset,date);

@override
String toString() {
  return 'SpecialEvent.day(title: $title, colorPreset: $colorPreset, date: $date)';
}


}

/// @nodoc
abstract mixin class $SpecialEventDayCopyWith<$Res> implements $SpecialEventCopyWith<$Res> {
  factory $SpecialEventDayCopyWith(SpecialEventDay value, $Res Function(SpecialEventDay) _then) = _$SpecialEventDayCopyWithImpl;
@override @useResult
$Res call({
 String title, SpecialEventColorPreset colorPreset, DateTime date
});




}
/// @nodoc
class _$SpecialEventDayCopyWithImpl<$Res>
    implements $SpecialEventDayCopyWith<$Res> {
  _$SpecialEventDayCopyWithImpl(this._self, this._then);

  final SpecialEventDay _self;
  final $Res Function(SpecialEventDay) _then;

/// Create a copy of SpecialEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? colorPreset = null,Object? date = null,}) {
  return _then(SpecialEventDay(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,colorPreset: null == colorPreset ? _self.colorPreset : colorPreset // ignore: cast_nullable_to_non_nullable
as SpecialEventColorPreset,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
