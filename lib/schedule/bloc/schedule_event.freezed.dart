// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleBlocEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleBlocEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScheduleBlocEvent()';
}


}

/// @nodoc
class $ScheduleBlocEventCopyWith<$Res>  {
$ScheduleBlocEventCopyWith(ScheduleBlocEvent _, $Res Function(ScheduleBlocEvent) __);
}


/// Adds pattern-matching-related methods to [ScheduleBlocEvent].
extension ScheduleBlocEventPatterns on ScheduleBlocEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ScheduleStarted value)?  started,TResult Function( ScheduleWeekChanged value)?  weekChanged,TResult Function( ScheduleRefreshRequested value)?  refreshRequested,TResult Function( ScheduleIdleTimeoutElapsed value)?  idleTimeoutElapsed,TResult Function( ScheduleAnchorChanged value)?  anchorChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ScheduleStarted() when started != null:
return started(_that);case ScheduleWeekChanged() when weekChanged != null:
return weekChanged(_that);case ScheduleRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case ScheduleIdleTimeoutElapsed() when idleTimeoutElapsed != null:
return idleTimeoutElapsed(_that);case ScheduleAnchorChanged() when anchorChanged != null:
return anchorChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ScheduleStarted value)  started,required TResult Function( ScheduleWeekChanged value)  weekChanged,required TResult Function( ScheduleRefreshRequested value)  refreshRequested,required TResult Function( ScheduleIdleTimeoutElapsed value)  idleTimeoutElapsed,required TResult Function( ScheduleAnchorChanged value)  anchorChanged,}){
final _that = this;
switch (_that) {
case ScheduleStarted():
return started(_that);case ScheduleWeekChanged():
return weekChanged(_that);case ScheduleRefreshRequested():
return refreshRequested(_that);case ScheduleIdleTimeoutElapsed():
return idleTimeoutElapsed(_that);case ScheduleAnchorChanged():
return anchorChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ScheduleStarted value)?  started,TResult? Function( ScheduleWeekChanged value)?  weekChanged,TResult? Function( ScheduleRefreshRequested value)?  refreshRequested,TResult? Function( ScheduleIdleTimeoutElapsed value)?  idleTimeoutElapsed,TResult? Function( ScheduleAnchorChanged value)?  anchorChanged,}){
final _that = this;
switch (_that) {
case ScheduleStarted() when started != null:
return started(_that);case ScheduleWeekChanged() when weekChanged != null:
return weekChanged(_that);case ScheduleRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case ScheduleIdleTimeoutElapsed() when idleTimeoutElapsed != null:
return idleTimeoutElapsed(_that);case ScheduleAnchorChanged() when anchorChanged != null:
return anchorChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( int offset)?  weekChanged,TResult Function()?  refreshRequested,TResult Function()?  idleTimeoutElapsed,TResult Function()?  anchorChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ScheduleStarted() when started != null:
return started();case ScheduleWeekChanged() when weekChanged != null:
return weekChanged(_that.offset);case ScheduleRefreshRequested() when refreshRequested != null:
return refreshRequested();case ScheduleIdleTimeoutElapsed() when idleTimeoutElapsed != null:
return idleTimeoutElapsed();case ScheduleAnchorChanged() when anchorChanged != null:
return anchorChanged();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( int offset)  weekChanged,required TResult Function()  refreshRequested,required TResult Function()  idleTimeoutElapsed,required TResult Function()  anchorChanged,}) {final _that = this;
switch (_that) {
case ScheduleStarted():
return started();case ScheduleWeekChanged():
return weekChanged(_that.offset);case ScheduleRefreshRequested():
return refreshRequested();case ScheduleIdleTimeoutElapsed():
return idleTimeoutElapsed();case ScheduleAnchorChanged():
return anchorChanged();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( int offset)?  weekChanged,TResult? Function()?  refreshRequested,TResult? Function()?  idleTimeoutElapsed,TResult? Function()?  anchorChanged,}) {final _that = this;
switch (_that) {
case ScheduleStarted() when started != null:
return started();case ScheduleWeekChanged() when weekChanged != null:
return weekChanged(_that.offset);case ScheduleRefreshRequested() when refreshRequested != null:
return refreshRequested();case ScheduleIdleTimeoutElapsed() when idleTimeoutElapsed != null:
return idleTimeoutElapsed();case ScheduleAnchorChanged() when anchorChanged != null:
return anchorChanged();case _:
  return null;

}
}

}

/// @nodoc


class ScheduleStarted implements ScheduleBlocEvent {
  const ScheduleStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScheduleBlocEvent.started()';
}


}




/// @nodoc


class ScheduleWeekChanged implements ScheduleBlocEvent {
  const ScheduleWeekChanged(this.offset);
  

 final  int offset;

/// Create a copy of ScheduleBlocEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleWeekChangedCopyWith<ScheduleWeekChanged> get copyWith => _$ScheduleWeekChangedCopyWithImpl<ScheduleWeekChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleWeekChanged&&(identical(other.offset, offset) || other.offset == offset));
}


@override
int get hashCode => Object.hash(runtimeType,offset);

@override
String toString() {
  return 'ScheduleBlocEvent.weekChanged(offset: $offset)';
}


}

/// @nodoc
abstract mixin class $ScheduleWeekChangedCopyWith<$Res> implements $ScheduleBlocEventCopyWith<$Res> {
  factory $ScheduleWeekChangedCopyWith(ScheduleWeekChanged value, $Res Function(ScheduleWeekChanged) _then) = _$ScheduleWeekChangedCopyWithImpl;
@useResult
$Res call({
 int offset
});




}
/// @nodoc
class _$ScheduleWeekChangedCopyWithImpl<$Res>
    implements $ScheduleWeekChangedCopyWith<$Res> {
  _$ScheduleWeekChangedCopyWithImpl(this._self, this._then);

  final ScheduleWeekChanged _self;
  final $Res Function(ScheduleWeekChanged) _then;

/// Create a copy of ScheduleBlocEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? offset = null,}) {
  return _then(ScheduleWeekChanged(
null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ScheduleRefreshRequested implements ScheduleBlocEvent {
  const ScheduleRefreshRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleRefreshRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScheduleBlocEvent.refreshRequested()';
}


}




/// @nodoc


class ScheduleIdleTimeoutElapsed implements ScheduleBlocEvent {
  const ScheduleIdleTimeoutElapsed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleIdleTimeoutElapsed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScheduleBlocEvent.idleTimeoutElapsed()';
}


}




/// @nodoc


class ScheduleAnchorChanged implements ScheduleBlocEvent {
  const ScheduleAnchorChanged();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleAnchorChanged);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScheduleBlocEvent.anchorChanged()';
}


}




// dart format on
