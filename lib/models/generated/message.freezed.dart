// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommonMessage implements DiagnosticableTreeMixin {

 String get id; String get text; MessageLevel get level; Duration get duration; MessageActionState? get actionState;
/// Create a copy of CommonMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommonMessageCopyWith<CommonMessage> get copyWith => _$CommonMessageCopyWithImpl<CommonMessage>(this as CommonMessage, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as CommonMessage;
  properties
    ..add(DiagnosticsProperty('type', 'CommonMessage'))
    ..add(DiagnosticsProperty('id', _this.id))..add(DiagnosticsProperty('text', _this.text))..add(DiagnosticsProperty('level', _this.level))..add(DiagnosticsProperty('duration', _this.duration))..add(DiagnosticsProperty('actionState', _this.actionState));
}

@override
bool operator ==(Object other) {
  final _this = this as CommonMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommonMessage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.actionState, _this.actionState) || other.actionState == _this.actionState));
}


@override
int get hashCode {
  final _this = this as CommonMessage;
  return Object.hash(runtimeType,_this.id,_this.text,_this.level,_this.duration,_this.actionState);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as CommonMessage;
  return 'CommonMessage(id: ${_this.id}, text: ${_this.text}, level: ${_this.level}, duration: ${_this.duration}, actionState: ${_this.actionState})';
}


}

/// @nodoc
abstract mixin class $CommonMessageCopyWith<$Res>  {
  factory $CommonMessageCopyWith(CommonMessage value, $Res Function(CommonMessage) _then) = _$CommonMessageCopyWithImpl;
@useResult
$Res call({
 String id, String text, MessageLevel level, Duration duration, MessageActionState? actionState
});


$MessageActionStateCopyWith<$Res>? get actionState;

}
/// @nodoc
class _$CommonMessageCopyWithImpl<$Res>
    implements $CommonMessageCopyWith<$Res> {
  _$CommonMessageCopyWithImpl(this._self, this._then);

  final CommonMessage _self;
  final $Res Function(CommonMessage) _then;

/// Create a copy of CommonMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? level = null,Object? duration = null,Object? actionState = freezed,}) {
  return _then(CommonMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as MessageLevel,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,actionState: freezed == actionState ? _self.actionState : actionState // ignore: cast_nullable_to_non_nullable
as MessageActionState?,
  ));
}
/// Create a copy of CommonMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageActionStateCopyWith<$Res>? get actionState {
    if (_self.actionState == null) {
    return null;
  }

  return $MessageActionStateCopyWith<$Res>(_self.actionState!, (value) {
    return _then(_self.copyWith(actionState: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommonMessage].
extension CommonMessagePatterns on CommonMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommonMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommonMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommonMessage value)  $default,){
final _that = this;
switch (_that) {
case _CommonMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommonMessage value)?  $default,){
final _that = this;
switch (_that) {
case _CommonMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  MessageLevel level,  Duration duration,  MessageActionState? actionState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommonMessage() when $default != null:
return $default(_that.id,_that.text,_that.level,_that.duration,_that.actionState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  MessageLevel level,  Duration duration,  MessageActionState? actionState)  $default,) {final _that = this;
switch (_that) {
case _CommonMessage():
return $default(_that.id,_that.text,_that.level,_that.duration,_that.actionState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  MessageLevel level,  Duration duration,  MessageActionState? actionState)?  $default,) {final _that = this;
switch (_that) {
case _CommonMessage() when $default != null:
return $default(_that.id,_that.text,_that.level,_that.duration,_that.actionState);case _:
  return null;

}
}

}

/// @nodoc


class _CommonMessage with DiagnosticableTreeMixin implements CommonMessage {
  const _CommonMessage({required this.id, required this.text, this.level = MessageLevel.info, this.duration = const Duration(seconds: 3), this.actionState});
  

@override final  String id;
@override final  String text;
@override@JsonKey() final  MessageLevel level;
@override@JsonKey() final  Duration duration;
@override final  MessageActionState? actionState;

/// Create a copy of CommonMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommonMessageCopyWith<_CommonMessage> get copyWith => __$CommonMessageCopyWithImpl<_CommonMessage>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'CommonMessage'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('text', text))..add(DiagnosticsProperty('level', level))..add(DiagnosticsProperty('duration', duration))..add(DiagnosticsProperty('actionState', actionState));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommonMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.level, level) || other.level == level)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.actionState, actionState) || other.actionState == actionState));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,text,level,duration,actionState);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'CommonMessage(id: $id, text: $text, level: $level, duration: $duration, actionState: $actionState)';
}


}

/// @nodoc
abstract mixin class _$CommonMessageCopyWith<$Res> implements $CommonMessageCopyWith<$Res> {
  factory _$CommonMessageCopyWith(_CommonMessage value, $Res Function(_CommonMessage) _then) = __$CommonMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, MessageLevel level, Duration duration, MessageActionState? actionState
});


@override $MessageActionStateCopyWith<$Res>? get actionState;

}
/// @nodoc
class __$CommonMessageCopyWithImpl<$Res>
    implements _$CommonMessageCopyWith<$Res> {
  __$CommonMessageCopyWithImpl(this._self, this._then);

  final _CommonMessage _self;
  final $Res Function(_CommonMessage) _then;

/// Create a copy of CommonMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? level = null,Object? duration = null,Object? actionState = freezed,}) {
  return _then(_CommonMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as MessageLevel,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,actionState: freezed == actionState ? _self.actionState : actionState // ignore: cast_nullable_to_non_nullable
as MessageActionState?,
  ));
}

/// Create a copy of CommonMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageActionStateCopyWith<$Res>? get actionState {
    if (_self.actionState == null) {
    return null;
  }

  return $MessageActionStateCopyWith<$Res>(_self.actionState!, (value) {
    return _then(_self.copyWith(actionState: value));
  });
}
}

/// @nodoc
mixin _$MessageActionState implements DiagnosticableTreeMixin {

 String get actionText; VoidCallback get action;
/// Create a copy of MessageActionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageActionStateCopyWith<MessageActionState> get copyWith => _$MessageActionStateCopyWithImpl<MessageActionState>(this as MessageActionState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as MessageActionState;
  properties
    ..add(DiagnosticsProperty('type', 'MessageActionState'))
    ..add(DiagnosticsProperty('actionText', _this.actionText))..add(DiagnosticsProperty('action', _this.action));
}

@override
bool operator ==(Object other) {
  final _this = this as MessageActionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageActionState&&(identical(other.actionText, _this.actionText) || other.actionText == _this.actionText)&&(identical(other.action, _this.action) || other.action == _this.action));
}


@override
int get hashCode {
  final _this = this as MessageActionState;
  return Object.hash(runtimeType,_this.actionText,_this.action);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as MessageActionState;
  return 'MessageActionState(actionText: ${_this.actionText}, action: ${_this.action})';
}


}

/// @nodoc
abstract mixin class $MessageActionStateCopyWith<$Res>  {
  factory $MessageActionStateCopyWith(MessageActionState value, $Res Function(MessageActionState) _then) = _$MessageActionStateCopyWithImpl;
@useResult
$Res call({
 String actionText, VoidCallback action
});




}
/// @nodoc
class _$MessageActionStateCopyWithImpl<$Res>
    implements $MessageActionStateCopyWith<$Res> {
  _$MessageActionStateCopyWithImpl(this._self, this._then);

  final MessageActionState _self;
  final $Res Function(MessageActionState) _then;

/// Create a copy of MessageActionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actionText = null,Object? action = null,}) {
  return _then(MessageActionState(
actionText: null == actionText ? _self.actionText : actionText // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as VoidCallback,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageActionState].
extension MessageActionStatePatterns on MessageActionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageActionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageActionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageActionState value)  $default,){
final _that = this;
switch (_that) {
case _MessageActionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageActionState value)?  $default,){
final _that = this;
switch (_that) {
case _MessageActionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String actionText,  VoidCallback action)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageActionState() when $default != null:
return $default(_that.actionText,_that.action);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String actionText,  VoidCallback action)  $default,) {final _that = this;
switch (_that) {
case _MessageActionState():
return $default(_that.actionText,_that.action);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String actionText,  VoidCallback action)?  $default,) {final _that = this;
switch (_that) {
case _MessageActionState() when $default != null:
return $default(_that.actionText,_that.action);case _:
  return null;

}
}

}

/// @nodoc


class _MessageActionState with DiagnosticableTreeMixin implements MessageActionState {
  const _MessageActionState({required this.actionText, required this.action});
  

@override final  String actionText;
@override final  VoidCallback action;

/// Create a copy of MessageActionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageActionStateCopyWith<_MessageActionState> get copyWith => __$MessageActionStateCopyWithImpl<_MessageActionState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'MessageActionState'))
    ..add(DiagnosticsProperty('actionText', actionText))..add(DiagnosticsProperty('action', action));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageActionState&&(identical(other.actionText, actionText) || other.actionText == actionText)&&(identical(other.action, action) || other.action == action));
}


@override
int get hashCode {
    return Object.hash(runtimeType,actionText,action);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'MessageActionState(actionText: $actionText, action: $action)';
}


}

/// @nodoc
abstract mixin class _$MessageActionStateCopyWith<$Res> implements $MessageActionStateCopyWith<$Res> {
  factory _$MessageActionStateCopyWith(_MessageActionState value, $Res Function(_MessageActionState) _then) = __$MessageActionStateCopyWithImpl;
@override @useResult
$Res call({
 String actionText, VoidCallback action
});




}
/// @nodoc
class __$MessageActionStateCopyWithImpl<$Res>
    implements _$MessageActionStateCopyWith<$Res> {
  __$MessageActionStateCopyWithImpl(this._self, this._then);

  final _MessageActionState _self;
  final $Res Function(_MessageActionState) _then;

/// Create a copy of MessageActionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actionText = null,Object? action = null,}) {
  return _then(_MessageActionState(
actionText: null == actionText ? _self.actionText : actionText // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as VoidCallback,
  ));
}


}

// dart format on
