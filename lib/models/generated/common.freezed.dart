// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../common.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NavigationItem {

 Glyph get glyph; PageLabel get label; WidgetBuilder get builder; String? get path; List<NavigationItemMode> get modes;
/// Create a copy of NavigationItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigationItemCopyWith<NavigationItem> get copyWith => _$NavigationItemCopyWithImpl<NavigationItem>(this as NavigationItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NavigationItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigationItem&&(identical(other.glyph, _this.glyph) || other.glyph == _this.glyph)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.builder, _this.builder) || other.builder == _this.builder)&&(identical(other.path, _this.path) || other.path == _this.path)&&const DeepCollectionEquality().equals(other.modes, _this.modes));
}


@override
int get hashCode {
  final _this = this as NavigationItem;
  return Object.hash(runtimeType,_this.glyph,_this.label,_this.builder,_this.path,const DeepCollectionEquality().hash(_this.modes));
}

@override
String toString() {
  final _this = this as NavigationItem;
  return 'NavigationItem(glyph: ${_this.glyph}, label: ${_this.label}, builder: ${_this.builder}, path: ${_this.path}, modes: ${_this.modes})';
}


}

/// @nodoc
abstract mixin class $NavigationItemCopyWith<$Res>  {
  factory $NavigationItemCopyWith(NavigationItem value, $Res Function(NavigationItem) _then) = _$NavigationItemCopyWithImpl;
@useResult
$Res call({
 Glyph glyph, PageLabel label, WidgetBuilder builder, String? path, List<NavigationItemMode> modes
});




}
/// @nodoc
class _$NavigationItemCopyWithImpl<$Res>
    implements $NavigationItemCopyWith<$Res> {
  _$NavigationItemCopyWithImpl(this._self, this._then);

  final NavigationItem _self;
  final $Res Function(NavigationItem) _then;

/// Create a copy of NavigationItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? glyph = null,Object? label = null,Object? builder = null,Object? path = freezed,Object? modes = null,}) {
  return _then(NavigationItem(
glyph: null == glyph ? _self.glyph : glyph // ignore: cast_nullable_to_non_nullable
as Glyph,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as PageLabel,builder: null == builder ? _self.builder : builder // ignore: cast_nullable_to_non_nullable
as WidgetBuilder,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,modes: null == modes ? _self.modes : modes // ignore: cast_nullable_to_non_nullable
as List<NavigationItemMode>,
  ));
}

}


/// Adds pattern-matching-related methods to [NavigationItem].
extension NavigationItemPatterns on NavigationItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavigationItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavigationItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavigationItem value)  $default,){
final _that = this;
switch (_that) {
case _NavigationItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavigationItem value)?  $default,){
final _that = this;
switch (_that) {
case _NavigationItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Glyph glyph,  PageLabel label,  WidgetBuilder builder,  String? path,  List<NavigationItemMode> modes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavigationItem() when $default != null:
return $default(_that.glyph,_that.label,_that.builder,_that.path,_that.modes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Glyph glyph,  PageLabel label,  WidgetBuilder builder,  String? path,  List<NavigationItemMode> modes)  $default,) {final _that = this;
switch (_that) {
case _NavigationItem():
return $default(_that.glyph,_that.label,_that.builder,_that.path,_that.modes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Glyph glyph,  PageLabel label,  WidgetBuilder builder,  String? path,  List<NavigationItemMode> modes)?  $default,) {final _that = this;
switch (_that) {
case _NavigationItem() when $default != null:
return $default(_that.glyph,_that.label,_that.builder,_that.path,_that.modes);case _:
  return null;

}
}

}

/// @nodoc


class _NavigationItem implements NavigationItem {
  const _NavigationItem({required this.glyph, required this.label, required this.builder, this.path,  List<NavigationItemMode> modes = const [NavigationItemMode.mobile, NavigationItemMode.desktop]}): _modes = modes;
  

@override final  Glyph glyph;
@override final  PageLabel label;
@override final  WidgetBuilder builder;
@override final  String? path;
 final  List<NavigationItemMode> _modes;
@override@JsonKey() List<NavigationItemMode> get modes {
  if (_modes is EqualUnmodifiableListView) return _modes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modes);
}


/// Create a copy of NavigationItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavigationItemCopyWith<_NavigationItem> get copyWith => __$NavigationItemCopyWithImpl<_NavigationItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigationItem&&(identical(other.glyph, glyph) || other.glyph == glyph)&&(identical(other.label, label) || other.label == label)&&(identical(other.builder, builder) || other.builder == builder)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other.modes, _modes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,glyph,label,builder,path,const DeepCollectionEquality().hash(_modes));
}

@override
String toString() {
    return 'NavigationItem(glyph: $glyph, label: $label, builder: $builder, path: $path, modes: $modes)';
}


}

/// @nodoc
abstract mixin class _$NavigationItemCopyWith<$Res> implements $NavigationItemCopyWith<$Res> {
  factory _$NavigationItemCopyWith(_NavigationItem value, $Res Function(_NavigationItem) _then) = __$NavigationItemCopyWithImpl;
@override @useResult
$Res call({
 Glyph glyph, PageLabel label, WidgetBuilder builder, String? path, List<NavigationItemMode> modes
});




}
/// @nodoc
class __$NavigationItemCopyWithImpl<$Res>
    implements _$NavigationItemCopyWith<$Res> {
  __$NavigationItemCopyWithImpl(this._self, this._then);

  final _NavigationItem _self;
  final $Res Function(_NavigationItem) _then;

/// Create a copy of NavigationItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? glyph = null,Object? label = null,Object? builder = null,Object? path = freezed,Object? modes = null,}) {
  return _then(_NavigationItem(
glyph: null == glyph ? _self.glyph : glyph // ignore: cast_nullable_to_non_nullable
as Glyph,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as PageLabel,builder: null == builder ? _self.builder : builder // ignore: cast_nullable_to_non_nullable
as WidgetBuilder,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,modes: null == modes ? _self._modes : modes // ignore: cast_nullable_to_non_nullable
as List<NavigationItemMode>,
  ));
}


}


/// @nodoc
mixin _$Package {

 String get packageName; String get label; bool get system; bool get internet; int get lastUpdateTime;
/// Create a copy of Package
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageCopyWith<Package> get copyWith => _$PackageCopyWithImpl<Package>(this as Package, _$identity);

  /// Serializes this Package to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Package;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Package&&(identical(other.packageName, _this.packageName) || other.packageName == _this.packageName)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.system, _this.system) || other.system == _this.system)&&(identical(other.internet, _this.internet) || other.internet == _this.internet)&&(identical(other.lastUpdateTime, _this.lastUpdateTime) || other.lastUpdateTime == _this.lastUpdateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Package;
  return Object.hash(runtimeType,_this.packageName,_this.label,_this.system,_this.internet,_this.lastUpdateTime);
}

@override
String toString() {
  final _this = this as Package;
  return 'Package(packageName: ${_this.packageName}, label: ${_this.label}, system: ${_this.system}, internet: ${_this.internet}, lastUpdateTime: ${_this.lastUpdateTime})';
}


}

/// @nodoc
abstract mixin class $PackageCopyWith<$Res>  {
  factory $PackageCopyWith(Package value, $Res Function(Package) _then) = _$PackageCopyWithImpl;
@useResult
$Res call({
 String packageName, String label, bool system, bool internet, int lastUpdateTime
});




}
/// @nodoc
class _$PackageCopyWithImpl<$Res>
    implements $PackageCopyWith<$Res> {
  _$PackageCopyWithImpl(this._self, this._then);

  final Package _self;
  final $Res Function(Package) _then;

/// Create a copy of Package
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? packageName = null,Object? label = null,Object? system = null,Object? internet = null,Object? lastUpdateTime = null,}) {
  return _then(Package(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,system: null == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as bool,internet: null == internet ? _self.internet : internet // ignore: cast_nullable_to_non_nullable
as bool,lastUpdateTime: null == lastUpdateTime ? _self.lastUpdateTime : lastUpdateTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Package].
extension PackagePatterns on Package {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Package value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Package() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Package value)  $default,){
final _that = this;
switch (_that) {
case _Package():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Package value)?  $default,){
final _that = this;
switch (_that) {
case _Package() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String packageName,  String label,  bool system,  bool internet,  int lastUpdateTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Package() when $default != null:
return $default(_that.packageName,_that.label,_that.system,_that.internet,_that.lastUpdateTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String packageName,  String label,  bool system,  bool internet,  int lastUpdateTime)  $default,) {final _that = this;
switch (_that) {
case _Package():
return $default(_that.packageName,_that.label,_that.system,_that.internet,_that.lastUpdateTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String packageName,  String label,  bool system,  bool internet,  int lastUpdateTime)?  $default,) {final _that = this;
switch (_that) {
case _Package() when $default != null:
return $default(_that.packageName,_that.label,_that.system,_that.internet,_that.lastUpdateTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Package implements Package {
  const _Package({required this.packageName, required this.label, required this.system, required this.internet, required this.lastUpdateTime});
  factory _Package.fromJson(Map<String, dynamic> json) => _$PackageFromJson(json);

@override final  String packageName;
@override final  String label;
@override final  bool system;
@override final  bool internet;
@override final  int lastUpdateTime;

/// Create a copy of Package
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageCopyWith<_Package> get copyWith => __$PackageCopyWithImpl<_Package>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Package&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.label, label) || other.label == label)&&(identical(other.system, system) || other.system == system)&&(identical(other.internet, internet) || other.internet == internet)&&(identical(other.lastUpdateTime, lastUpdateTime) || other.lastUpdateTime == lastUpdateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,packageName,label,system,internet,lastUpdateTime);
}

@override
String toString() {
    return 'Package(packageName: $packageName, label: $label, system: $system, internet: $internet, lastUpdateTime: $lastUpdateTime)';
}


}

/// @nodoc
abstract mixin class _$PackageCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$PackageCopyWith(_Package value, $Res Function(_Package) _then) = __$PackageCopyWithImpl;
@override @useResult
$Res call({
 String packageName, String label, bool system, bool internet, int lastUpdateTime
});




}
/// @nodoc
class __$PackageCopyWithImpl<$Res>
    implements _$PackageCopyWith<$Res> {
  __$PackageCopyWithImpl(this._self, this._then);

  final _Package _self;
  final $Res Function(_Package) _then;

/// Create a copy of Package
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? packageName = null,Object? label = null,Object? system = null,Object? internet = null,Object? lastUpdateTime = null,}) {
  return _then(_Package(
packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,system: null == system ? _self.system : system // ignore: cast_nullable_to_non_nullable
as bool,internet: null == internet ? _self.internet : internet // ignore: cast_nullable_to_non_nullable
as bool,lastUpdateTime: null == lastUpdateTime ? _self.lastUpdateTime : lastUpdateTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Log {

@JsonKey(name: 'LogLevel') LogLevel get logLevel;@JsonKey(name: 'Payload') String get payload;@JsonKey(fromJson: _logDateTime) String get dateTime;
/// Create a copy of Log
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogCopyWith<Log> get copyWith => _$LogCopyWithImpl<Log>(this as Log, _$identity);

  /// Serializes this Log to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Log;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Log&&(identical(other.logLevel, _this.logLevel) || other.logLevel == _this.logLevel)&&(identical(other.payload, _this.payload) || other.payload == _this.payload)&&(identical(other.dateTime, _this.dateTime) || other.dateTime == _this.dateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Log;
  return Object.hash(runtimeType,_this.logLevel,_this.payload,_this.dateTime);
}

@override
String toString() {
  final _this = this as Log;
  return 'Log(logLevel: ${_this.logLevel}, payload: ${_this.payload}, dateTime: ${_this.dateTime})';
}


}

/// @nodoc
abstract mixin class $LogCopyWith<$Res>  {
  factory $LogCopyWith(Log value, $Res Function(Log) _then) = _$LogCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'LogLevel') LogLevel logLevel,@JsonKey(name: 'Payload') String payload,@JsonKey(fromJson: _logDateTime) String dateTime
});




}
/// @nodoc
class _$LogCopyWithImpl<$Res>
    implements $LogCopyWith<$Res> {
  _$LogCopyWithImpl(this._self, this._then);

  final Log _self;
  final $Res Function(Log) _then;

/// Create a copy of Log
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? logLevel = null,Object? payload = null,Object? dateTime = null,}) {
  return _then(Log(
logLevel: null == logLevel ? _self.logLevel : logLevel // ignore: cast_nullable_to_non_nullable
as LogLevel,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,dateTime: null == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Log].
extension LogPatterns on Log {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Log value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Log() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Log value)  $default,){
final _that = this;
switch (_that) {
case _Log():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Log value)?  $default,){
final _that = this;
switch (_that) {
case _Log() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'LogLevel')  LogLevel logLevel, @JsonKey(name: 'Payload')  String payload, @JsonKey(fromJson: _logDateTime)  String dateTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Log() when $default != null:
return $default(_that.logLevel,_that.payload,_that.dateTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'LogLevel')  LogLevel logLevel, @JsonKey(name: 'Payload')  String payload, @JsonKey(fromJson: _logDateTime)  String dateTime)  $default,) {final _that = this;
switch (_that) {
case _Log():
return $default(_that.logLevel,_that.payload,_that.dateTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'LogLevel')  LogLevel logLevel, @JsonKey(name: 'Payload')  String payload, @JsonKey(fromJson: _logDateTime)  String dateTime)?  $default,) {final _that = this;
switch (_that) {
case _Log() when $default != null:
return $default(_that.logLevel,_that.payload,_that.dateTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Log implements Log {
  const _Log({@JsonKey(name: 'LogLevel') this.logLevel = LogLevel.info, @JsonKey(name: 'Payload') this.payload = '', @JsonKey(fromJson: _logDateTime) required this.dateTime});
  factory _Log.fromJson(Map<String, dynamic> json) => _$LogFromJson(json);

@override@JsonKey(name: 'LogLevel') final  LogLevel logLevel;
@override@JsonKey(name: 'Payload') final  String payload;
@override@JsonKey(fromJson: _logDateTime) final  String dateTime;

/// Create a copy of Log
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogCopyWith<_Log> get copyWith => __$LogCopyWithImpl<_Log>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Log&&(identical(other.logLevel, logLevel) || other.logLevel == logLevel)&&(identical(other.payload, payload) || other.payload == payload)&&(identical(other.dateTime, dateTime) || other.dateTime == dateTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,logLevel,payload,dateTime);
}

@override
String toString() {
    return 'Log(logLevel: $logLevel, payload: $payload, dateTime: $dateTime)';
}


}

/// @nodoc
abstract mixin class _$LogCopyWith<$Res> implements $LogCopyWith<$Res> {
  factory _$LogCopyWith(_Log value, $Res Function(_Log) _then) = __$LogCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'LogLevel') LogLevel logLevel,@JsonKey(name: 'Payload') String payload,@JsonKey(fromJson: _logDateTime) String dateTime
});




}
/// @nodoc
class __$LogCopyWithImpl<$Res>
    implements _$LogCopyWith<$Res> {
  __$LogCopyWithImpl(this._self, this._then);

  final _Log _self;
  final $Res Function(_Log) _then;

/// Create a copy of Log
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? logLevel = null,Object? payload = null,Object? dateTime = null,}) {
  return _then(_Log(
logLevel: null == logLevel ? _self.logLevel : logLevel // ignore: cast_nullable_to_non_nullable
as LogLevel,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,dateTime: null == dateTime ? _self.dateTime : dateTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$LogsState {

 List<Log> get logs; List<String> get keywords; String get query; bool get autoScrollToEnd;
/// Create a copy of LogsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogsStateCopyWith<LogsState> get copyWith => _$LogsStateCopyWithImpl<LogsState>(this as LogsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LogsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogsState&&const DeepCollectionEquality().equals(other.logs, _this.logs)&&const DeepCollectionEquality().equals(other.keywords, _this.keywords)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.autoScrollToEnd, _this.autoScrollToEnd) || other.autoScrollToEnd == _this.autoScrollToEnd));
}


@override
int get hashCode {
  final _this = this as LogsState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.logs),const DeepCollectionEquality().hash(_this.keywords),_this.query,_this.autoScrollToEnd);
}

@override
String toString() {
  final _this = this as LogsState;
  return 'LogsState(logs: ${_this.logs}, keywords: ${_this.keywords}, query: ${_this.query}, autoScrollToEnd: ${_this.autoScrollToEnd})';
}


}

/// @nodoc
abstract mixin class $LogsStateCopyWith<$Res>  {
  factory $LogsStateCopyWith(LogsState value, $Res Function(LogsState) _then) = _$LogsStateCopyWithImpl;
@useResult
$Res call({
 List<Log> logs, List<String> keywords, String query, bool autoScrollToEnd
});




}
/// @nodoc
class _$LogsStateCopyWithImpl<$Res>
    implements $LogsStateCopyWith<$Res> {
  _$LogsStateCopyWithImpl(this._self, this._then);

  final LogsState _self;
  final $Res Function(LogsState) _then;

/// Create a copy of LogsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? logs = null,Object? keywords = null,Object? query = null,Object? autoScrollToEnd = null,}) {
  return _then(LogsState(
logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as List<Log>,keywords: null == keywords ? _self.keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<String>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,autoScrollToEnd: null == autoScrollToEnd ? _self.autoScrollToEnd : autoScrollToEnd // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LogsState].
extension LogsStatePatterns on LogsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LogsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LogsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LogsState value)  $default,){
final _that = this;
switch (_that) {
case _LogsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LogsState value)?  $default,){
final _that = this;
switch (_that) {
case _LogsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Log> logs,  List<String> keywords,  String query,  bool autoScrollToEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LogsState() when $default != null:
return $default(_that.logs,_that.keywords,_that.query,_that.autoScrollToEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Log> logs,  List<String> keywords,  String query,  bool autoScrollToEnd)  $default,) {final _that = this;
switch (_that) {
case _LogsState():
return $default(_that.logs,_that.keywords,_that.query,_that.autoScrollToEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Log> logs,  List<String> keywords,  String query,  bool autoScrollToEnd)?  $default,) {final _that = this;
switch (_that) {
case _LogsState() when $default != null:
return $default(_that.logs,_that.keywords,_that.query,_that.autoScrollToEnd);case _:
  return null;

}
}

}

/// @nodoc


class _LogsState implements LogsState {
  const _LogsState({ List<Log> logs = const [],  List<String> keywords = const [], this.query = '', this.autoScrollToEnd = true}): _logs = logs,_keywords = keywords;
  

 final  List<Log> _logs;
@override@JsonKey() List<Log> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}

 final  List<String> _keywords;
@override@JsonKey() List<String> get keywords {
  if (_keywords is EqualUnmodifiableListView) return _keywords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keywords);
}

@override@JsonKey() final  String query;
@override@JsonKey() final  bool autoScrollToEnd;

/// Create a copy of LogsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LogsStateCopyWith<_LogsState> get copyWith => __$LogsStateCopyWithImpl<_LogsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogsState&&const DeepCollectionEquality().equals(other.logs, _logs)&&const DeepCollectionEquality().equals(other.keywords, _keywords)&&(identical(other.query, query) || other.query == query)&&(identical(other.autoScrollToEnd, autoScrollToEnd) || other.autoScrollToEnd == autoScrollToEnd));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_logs),const DeepCollectionEquality().hash(_keywords),query,autoScrollToEnd);
}

@override
String toString() {
    return 'LogsState(logs: $logs, keywords: $keywords, query: $query, autoScrollToEnd: $autoScrollToEnd)';
}


}

/// @nodoc
abstract mixin class _$LogsStateCopyWith<$Res> implements $LogsStateCopyWith<$Res> {
  factory _$LogsStateCopyWith(_LogsState value, $Res Function(_LogsState) _then) = __$LogsStateCopyWithImpl;
@override @useResult
$Res call({
 List<Log> logs, List<String> keywords, String query, bool autoScrollToEnd
});




}
/// @nodoc
class __$LogsStateCopyWithImpl<$Res>
    implements _$LogsStateCopyWith<$Res> {
  __$LogsStateCopyWithImpl(this._self, this._then);

  final _LogsState _self;
  final $Res Function(_LogsState) _then;

/// Create a copy of LogsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? logs = null,Object? keywords = null,Object? query = null,Object? autoScrollToEnd = null,}) {
  return _then(_LogsState(
logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<Log>,keywords: null == keywords ? _self._keywords : keywords // ignore: cast_nullable_to_non_nullable
as List<String>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,autoScrollToEnd: null == autoScrollToEnd ? _self.autoScrollToEnd : autoScrollToEnd // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DAVProps {

 String get uri; String get user;@JsonKey(fromJson: _decodeDavPassword, toJson: _encodeDavPassword) String get password; String get fileName;
/// Create a copy of DAVProps
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DAVPropsCopyWith<DAVProps> get copyWith => _$DAVPropsCopyWithImpl<DAVProps>(this as DAVProps, _$identity);

  /// Serializes this DAVProps to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DAVProps;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DAVProps&&(identical(other.uri, _this.uri) || other.uri == _this.uri)&&(identical(other.user, _this.user) || other.user == _this.user)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DAVProps;
  return Object.hash(runtimeType,_this.uri,_this.user,_this.password,_this.fileName);
}



}

/// @nodoc
abstract mixin class $DAVPropsCopyWith<$Res>  {
  factory $DAVPropsCopyWith(DAVProps value, $Res Function(DAVProps) _then) = _$DAVPropsCopyWithImpl;
@useResult
$Res call({
 String uri, String user,@JsonKey(fromJson: _decodeDavPassword, toJson: _encodeDavPassword) String password, String fileName
});




}
/// @nodoc
class _$DAVPropsCopyWithImpl<$Res>
    implements $DAVPropsCopyWith<$Res> {
  _$DAVPropsCopyWithImpl(this._self, this._then);

  final DAVProps _self;
  final $Res Function(DAVProps) _then;

/// Create a copy of DAVProps
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uri = null,Object? user = null,Object? password = null,Object? fileName = null,}) {
  return _then(DAVProps(
uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DAVProps].
extension DAVPropsPatterns on DAVProps {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DAVProps value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DAVProps() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DAVProps value)  $default,){
final _that = this;
switch (_that) {
case _DAVProps():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DAVProps value)?  $default,){
final _that = this;
switch (_that) {
case _DAVProps() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uri,  String user, @JsonKey(fromJson: _decodeDavPassword, toJson: _encodeDavPassword)  String password,  String fileName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DAVProps() when $default != null:
return $default(_that.uri,_that.user,_that.password,_that.fileName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uri,  String user, @JsonKey(fromJson: _decodeDavPassword, toJson: _encodeDavPassword)  String password,  String fileName)  $default,) {final _that = this;
switch (_that) {
case _DAVProps():
return $default(_that.uri,_that.user,_that.password,_that.fileName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uri,  String user, @JsonKey(fromJson: _decodeDavPassword, toJson: _encodeDavPassword)  String password,  String fileName)?  $default,) {final _that = this;
switch (_that) {
case _DAVProps() when $default != null:
return $default(_that.uri,_that.user,_that.password,_that.fileName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DAVProps extends DAVProps {
  const _DAVProps({required this.uri, required this.user, @JsonKey(fromJson: _decodeDavPassword, toJson: _encodeDavPassword) this.password = '', this.fileName = defaultDavFileName}): super._();
  factory _DAVProps.fromJson(Map<String, dynamic> json) => _$DAVPropsFromJson(json);

@override final  String uri;
@override final  String user;
@override@JsonKey(fromJson: _decodeDavPassword, toJson: _encodeDavPassword) final  String password;
@override@JsonKey() final  String fileName;

/// Create a copy of DAVProps
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DAVPropsCopyWith<_DAVProps> get copyWith => __$DAVPropsCopyWithImpl<_DAVProps>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DAVPropsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DAVProps&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.user, user) || other.user == user)&&(identical(other.password, password) || other.password == password)&&(identical(other.fileName, fileName) || other.fileName == fileName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,uri,user,password,fileName);
}



}

/// @nodoc
abstract mixin class _$DAVPropsCopyWith<$Res> implements $DAVPropsCopyWith<$Res> {
  factory _$DAVPropsCopyWith(_DAVProps value, $Res Function(_DAVProps) _then) = __$DAVPropsCopyWithImpl;
@override @useResult
$Res call({
 String uri, String user,@JsonKey(fromJson: _decodeDavPassword, toJson: _encodeDavPassword) String password, String fileName
});




}
/// @nodoc
class __$DAVPropsCopyWithImpl<$Res>
    implements _$DAVPropsCopyWith<$Res> {
  __$DAVPropsCopyWithImpl(this._self, this._then);

  final _DAVProps _self;
  final $Res Function(_DAVProps) _then;

/// Create a copy of DAVProps
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uri = null,Object? user = null,Object? password = null,Object? fileName = null,}) {
  return _then(_DAVProps(
uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$FileInfo {

 int get size; DateTime? get lastModified;
/// Create a copy of FileInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileInfoCopyWith<FileInfo> get copyWith => _$FileInfoCopyWithImpl<FileInfo>(this as FileInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FileInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileInfo&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.lastModified, _this.lastModified) || other.lastModified == _this.lastModified));
}


@override
int get hashCode {
  final _this = this as FileInfo;
  return Object.hash(runtimeType,_this.size,_this.lastModified);
}

@override
String toString() {
  final _this = this as FileInfo;
  return 'FileInfo(size: ${_this.size}, lastModified: ${_this.lastModified})';
}


}

/// @nodoc
abstract mixin class $FileInfoCopyWith<$Res>  {
  factory $FileInfoCopyWith(FileInfo value, $Res Function(FileInfo) _then) = _$FileInfoCopyWithImpl;
@useResult
$Res call({
 int size, DateTime? lastModified
});




}
/// @nodoc
class _$FileInfoCopyWithImpl<$Res>
    implements $FileInfoCopyWith<$Res> {
  _$FileInfoCopyWithImpl(this._self, this._then);

  final FileInfo _self;
  final $Res Function(FileInfo) _then;

/// Create a copy of FileInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? size = null,Object? lastModified = freezed,}) {
  return _then(FileInfo(
size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FileInfo].
extension FileInfoPatterns on FileInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileInfo value)  $default,){
final _that = this;
switch (_that) {
case _FileInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileInfo value)?  $default,){
final _that = this;
switch (_that) {
case _FileInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int size,  DateTime? lastModified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileInfo() when $default != null:
return $default(_that.size,_that.lastModified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int size,  DateTime? lastModified)  $default,) {final _that = this;
switch (_that) {
case _FileInfo():
return $default(_that.size,_that.lastModified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int size,  DateTime? lastModified)?  $default,) {final _that = this;
switch (_that) {
case _FileInfo() when $default != null:
return $default(_that.size,_that.lastModified);case _:
  return null;

}
}

}

/// @nodoc


class _FileInfo implements FileInfo {
  const _FileInfo({required this.size, this.lastModified});
  

@override final  int size;
@override final  DateTime? lastModified;

/// Create a copy of FileInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileInfoCopyWith<_FileInfo> get copyWith => __$FileInfoCopyWithImpl<_FileInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileInfo&&(identical(other.size, size) || other.size == size)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}


@override
int get hashCode {
    return Object.hash(runtimeType,size,lastModified);
}

@override
String toString() {
    return 'FileInfo(size: $size, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class _$FileInfoCopyWith<$Res> implements $FileInfoCopyWith<$Res> {
  factory _$FileInfoCopyWith(_FileInfo value, $Res Function(_FileInfo) _then) = __$FileInfoCopyWithImpl;
@override @useResult
$Res call({
 int size, DateTime? lastModified
});




}
/// @nodoc
class __$FileInfoCopyWithImpl<$Res>
    implements _$FileInfoCopyWith<$Res> {
  __$FileInfoCopyWithImpl(this._self, this._then);

  final _FileInfo _self;
  final $Res Function(_FileInfo) _then;

/// Create a copy of FileInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? size = null,Object? lastModified = freezed,}) {
  return _then(_FileInfo(
size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Traffic {

 num get up; num get down;
/// Create a copy of Traffic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrafficCopyWith<Traffic> get copyWith => _$TrafficCopyWithImpl<Traffic>(this as Traffic, _$identity);

  /// Serializes this Traffic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Traffic;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Traffic&&(identical(other.up, _this.up) || other.up == _this.up)&&(identical(other.down, _this.down) || other.down == _this.down));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Traffic;
  return Object.hash(runtimeType,_this.up,_this.down);
}

@override
String toString() {
  final _this = this as Traffic;
  return 'Traffic(up: ${_this.up}, down: ${_this.down})';
}


}

/// @nodoc
abstract mixin class $TrafficCopyWith<$Res>  {
  factory $TrafficCopyWith(Traffic value, $Res Function(Traffic) _then) = _$TrafficCopyWithImpl;
@useResult
$Res call({
 num up, num down
});




}
/// @nodoc
class _$TrafficCopyWithImpl<$Res>
    implements $TrafficCopyWith<$Res> {
  _$TrafficCopyWithImpl(this._self, this._then);

  final Traffic _self;
  final $Res Function(Traffic) _then;

/// Create a copy of Traffic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? up = null,Object? down = null,}) {
  return _then(Traffic(
up: null == up ? _self.up : up // ignore: cast_nullable_to_non_nullable
as num,down: null == down ? _self.down : down // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [Traffic].
extension TrafficPatterns on Traffic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Traffic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Traffic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Traffic value)  $default,){
final _that = this;
switch (_that) {
case _Traffic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Traffic value)?  $default,){
final _that = this;
switch (_that) {
case _Traffic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num up,  num down)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Traffic() when $default != null:
return $default(_that.up,_that.down);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num up,  num down)  $default,) {final _that = this;
switch (_that) {
case _Traffic():
return $default(_that.up,_that.down);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num up,  num down)?  $default,) {final _that = this;
switch (_that) {
case _Traffic() when $default != null:
return $default(_that.up,_that.down);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Traffic implements Traffic {
  const _Traffic({this.up = 0, this.down = 0});
  factory _Traffic.fromJson(Map<String, dynamic> json) => _$TrafficFromJson(json);

@override@JsonKey() final  num up;
@override@JsonKey() final  num down;

/// Create a copy of Traffic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrafficCopyWith<_Traffic> get copyWith => __$TrafficCopyWithImpl<_Traffic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrafficToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Traffic&&(identical(other.up, up) || other.up == up)&&(identical(other.down, down) || other.down == down));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,up,down);
}

@override
String toString() {
    return 'Traffic(up: $up, down: $down)';
}


}

/// @nodoc
abstract mixin class _$TrafficCopyWith<$Res> implements $TrafficCopyWith<$Res> {
  factory _$TrafficCopyWith(_Traffic value, $Res Function(_Traffic) _then) = __$TrafficCopyWithImpl;
@override @useResult
$Res call({
 num up, num down
});




}
/// @nodoc
class __$TrafficCopyWithImpl<$Res>
    implements _$TrafficCopyWith<$Res> {
  __$TrafficCopyWithImpl(this._self, this._then);

  final _Traffic _self;
  final $Res Function(_Traffic) _then;

/// Create a copy of Traffic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? up = null,Object? down = null,}) {
  return _then(_Traffic(
up: null == up ? _self.up : up // ignore: cast_nullable_to_non_nullable
as num,down: null == down ? _self.down : down // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

/// @nodoc
mixin _$IpInfo {

 String get ip; String get countryCode;
/// Create a copy of IpInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IpInfoCopyWith<IpInfo> get copyWith => _$IpInfoCopyWithImpl<IpInfo>(this as IpInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as IpInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IpInfo&&(identical(other.ip, _this.ip) || other.ip == _this.ip)&&(identical(other.countryCode, _this.countryCode) || other.countryCode == _this.countryCode));
}


@override
int get hashCode {
  final _this = this as IpInfo;
  return Object.hash(runtimeType,_this.ip,_this.countryCode);
}

@override
String toString() {
  final _this = this as IpInfo;
  return 'IpInfo(ip: ${_this.ip}, countryCode: ${_this.countryCode})';
}


}

/// @nodoc
abstract mixin class $IpInfoCopyWith<$Res>  {
  factory $IpInfoCopyWith(IpInfo value, $Res Function(IpInfo) _then) = _$IpInfoCopyWithImpl;
@useResult
$Res call({
 String ip, String countryCode
});




}
/// @nodoc
class _$IpInfoCopyWithImpl<$Res>
    implements $IpInfoCopyWith<$Res> {
  _$IpInfoCopyWithImpl(this._self, this._then);

  final IpInfo _self;
  final $Res Function(IpInfo) _then;

/// Create a copy of IpInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ip = null,Object? countryCode = null,}) {
  return _then(IpInfo(
ip: null == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IpInfo].
extension IpInfoPatterns on IpInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IpInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IpInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IpInfo value)  $default,){
final _that = this;
switch (_that) {
case _IpInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IpInfo value)?  $default,){
final _that = this;
switch (_that) {
case _IpInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ip,  String countryCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IpInfo() when $default != null:
return $default(_that.ip,_that.countryCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ip,  String countryCode)  $default,) {final _that = this;
switch (_that) {
case _IpInfo():
return $default(_that.ip,_that.countryCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ip,  String countryCode)?  $default,) {final _that = this;
switch (_that) {
case _IpInfo() when $default != null:
return $default(_that.ip,_that.countryCode);case _:
  return null;

}
}

}

/// @nodoc


class _IpInfo implements IpInfo {
  const _IpInfo({required this.ip, required this.countryCode});
  

@override final  String ip;
@override final  String countryCode;

/// Create a copy of IpInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IpInfoCopyWith<_IpInfo> get copyWith => __$IpInfoCopyWithImpl<_IpInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IpInfo&&(identical(other.ip, ip) || other.ip == ip)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}


@override
int get hashCode {
    return Object.hash(runtimeType,ip,countryCode);
}

@override
String toString() {
    return 'IpInfo(ip: $ip, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class _$IpInfoCopyWith<$Res> implements $IpInfoCopyWith<$Res> {
  factory _$IpInfoCopyWith(_IpInfo value, $Res Function(_IpInfo) _then) = __$IpInfoCopyWithImpl;
@override @useResult
$Res call({
 String ip, String countryCode
});




}
/// @nodoc
class __$IpInfoCopyWithImpl<$Res>
    implements _$IpInfoCopyWith<$Res> {
  __$IpInfoCopyWithImpl(this._self, this._then);

  final _IpInfo _self;
  final $Res Function(_IpInfo) _then;

/// Create a copy of IpInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ip = null,Object? countryCode = null,}) {
  return _then(_IpInfo(
ip: null == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HotKeyAction {

 HotAction get action; int? get key; Set<KeyboardModifier> get modifiers;
/// Create a copy of HotKeyAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotKeyActionCopyWith<HotKeyAction> get copyWith => _$HotKeyActionCopyWithImpl<HotKeyAction>(this as HotKeyAction, _$identity);

  /// Serializes this HotKeyAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HotKeyAction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotKeyAction&&(identical(other.action, _this.action) || other.action == _this.action)&&(identical(other.key, _this.key) || other.key == _this.key)&&const DeepCollectionEquality().equals(other.modifiers, _this.modifiers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HotKeyAction;
  return Object.hash(runtimeType,_this.action,_this.key,const DeepCollectionEquality().hash(_this.modifiers));
}

@override
String toString() {
  final _this = this as HotKeyAction;
  return 'HotKeyAction(action: ${_this.action}, key: ${_this.key}, modifiers: ${_this.modifiers})';
}


}

/// @nodoc
abstract mixin class $HotKeyActionCopyWith<$Res>  {
  factory $HotKeyActionCopyWith(HotKeyAction value, $Res Function(HotKeyAction) _then) = _$HotKeyActionCopyWithImpl;
@useResult
$Res call({
 HotAction action, int? key, Set<KeyboardModifier> modifiers
});




}
/// @nodoc
class _$HotKeyActionCopyWithImpl<$Res>
    implements $HotKeyActionCopyWith<$Res> {
  _$HotKeyActionCopyWithImpl(this._self, this._then);

  final HotKeyAction _self;
  final $Res Function(HotKeyAction) _then;

/// Create a copy of HotKeyAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? key = freezed,Object? modifiers = null,}) {
  return _then(HotKeyAction(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as HotAction,key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as int?,modifiers: null == modifiers ? _self.modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as Set<KeyboardModifier>,
  ));
}

}


/// Adds pattern-matching-related methods to [HotKeyAction].
extension HotKeyActionPatterns on HotKeyAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotKeyAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotKeyAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotKeyAction value)  $default,){
final _that = this;
switch (_that) {
case _HotKeyAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotKeyAction value)?  $default,){
final _that = this;
switch (_that) {
case _HotKeyAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HotAction action,  int? key,  Set<KeyboardModifier> modifiers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotKeyAction() when $default != null:
return $default(_that.action,_that.key,_that.modifiers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HotAction action,  int? key,  Set<KeyboardModifier> modifiers)  $default,) {final _that = this;
switch (_that) {
case _HotKeyAction():
return $default(_that.action,_that.key,_that.modifiers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HotAction action,  int? key,  Set<KeyboardModifier> modifiers)?  $default,) {final _that = this;
switch (_that) {
case _HotKeyAction() when $default != null:
return $default(_that.action,_that.key,_that.modifiers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotKeyAction implements HotKeyAction {
  const _HotKeyAction({required this.action, this.key,  Set<KeyboardModifier> modifiers = const {}}): _modifiers = modifiers;
  factory _HotKeyAction.fromJson(Map<String, dynamic> json) => _$HotKeyActionFromJson(json);

@override final  HotAction action;
@override final  int? key;
 final  Set<KeyboardModifier> _modifiers;
@override@JsonKey() Set<KeyboardModifier> get modifiers {
  if (_modifiers is EqualUnmodifiableSetView) return _modifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_modifiers);
}


/// Create a copy of HotKeyAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotKeyActionCopyWith<_HotKeyAction> get copyWith => __$HotKeyActionCopyWithImpl<_HotKeyAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotKeyActionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotKeyAction&&(identical(other.action, action) || other.action == action)&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other.modifiers, _modifiers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,action,key,const DeepCollectionEquality().hash(_modifiers));
}

@override
String toString() {
    return 'HotKeyAction(action: $action, key: $key, modifiers: $modifiers)';
}


}

/// @nodoc
abstract mixin class _$HotKeyActionCopyWith<$Res> implements $HotKeyActionCopyWith<$Res> {
  factory _$HotKeyActionCopyWith(_HotKeyAction value, $Res Function(_HotKeyAction) _then) = __$HotKeyActionCopyWithImpl;
@override @useResult
$Res call({
 HotAction action, int? key, Set<KeyboardModifier> modifiers
});




}
/// @nodoc
class __$HotKeyActionCopyWithImpl<$Res>
    implements _$HotKeyActionCopyWith<$Res> {
  __$HotKeyActionCopyWithImpl(this._self, this._then);

  final _HotKeyAction _self;
  final $Res Function(_HotKeyAction) _then;

/// Create a copy of HotKeyAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? key = freezed,Object? modifiers = null,}) {
  return _then(_HotKeyAction(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as HotAction,key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as int?,modifiers: null == modifiers ? _self._modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as Set<KeyboardModifier>,
  ));
}


}

/// @nodoc
mixin _$Field {

 String get label; String get value; Validator? get validator;
/// Create a copy of Field
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldCopyWith<Field> get copyWith => _$FieldCopyWithImpl<Field>(this as Field, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Field;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Field&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.validator, _this.validator) || other.validator == _this.validator));
}


@override
int get hashCode {
  final _this = this as Field;
  return Object.hash(runtimeType,_this.label,_this.value,_this.validator);
}

@override
String toString() {
  final _this = this as Field;
  return 'Field(label: ${_this.label}, value: ${_this.value}, validator: ${_this.validator})';
}


}

/// @nodoc
abstract mixin class $FieldCopyWith<$Res>  {
  factory $FieldCopyWith(Field value, $Res Function(Field) _then) = _$FieldCopyWithImpl;
@useResult
$Res call({
 String label, String value, Validator? validator
});




}
/// @nodoc
class _$FieldCopyWithImpl<$Res>
    implements $FieldCopyWith<$Res> {
  _$FieldCopyWithImpl(this._self, this._then);

  final Field _self;
  final $Res Function(Field) _then;

/// Create a copy of Field
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? value = null,Object? validator = freezed,}) {
  return _then(Field(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,validator: freezed == validator ? _self.validator : validator // ignore: cast_nullable_to_non_nullable
as Validator?,
  ));
}

}


/// Adds pattern-matching-related methods to [Field].
extension FieldPatterns on Field {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Field value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Field() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Field value)  $default,){
final _that = this;
switch (_that) {
case _Field():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Field value)?  $default,){
final _that = this;
switch (_that) {
case _Field() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String value,  Validator? validator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Field() when $default != null:
return $default(_that.label,_that.value,_that.validator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String value,  Validator? validator)  $default,) {final _that = this;
switch (_that) {
case _Field():
return $default(_that.label,_that.value,_that.validator);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String value,  Validator? validator)?  $default,) {final _that = this;
switch (_that) {
case _Field() when $default != null:
return $default(_that.label,_that.value,_that.validator);case _:
  return null;

}
}

}

/// @nodoc


class _Field implements Field {
  const _Field({required this.label, required this.value, this.validator});
  

@override final  String label;
@override final  String value;
@override final  Validator? validator;

/// Create a copy of Field
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldCopyWith<_Field> get copyWith => __$FieldCopyWithImpl<_Field>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Field&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.validator, validator) || other.validator == validator));
}


@override
int get hashCode {
    return Object.hash(runtimeType,label,value,validator);
}

@override
String toString() {
    return 'Field(label: $label, value: $value, validator: $validator)';
}


}

/// @nodoc
abstract mixin class _$FieldCopyWith<$Res> implements $FieldCopyWith<$Res> {
  factory _$FieldCopyWith(_Field value, $Res Function(_Field) _then) = __$FieldCopyWithImpl;
@override @useResult
$Res call({
 String label, String value, Validator? validator
});




}
/// @nodoc
class __$FieldCopyWithImpl<$Res>
    implements _$FieldCopyWith<$Res> {
  __$FieldCopyWithImpl(this._self, this._then);

  final _Field _self;
  final $Res Function(_Field) _then;

/// Create a copy of Field
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,Object? validator = freezed,}) {
  return _then(_Field(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,validator: freezed == validator ? _self.validator : validator // ignore: cast_nullable_to_non_nullable
as Validator?,
  ));
}


}

/// @nodoc
mixin _$Result<T> {

 T? get data; ResultType get type; String get message;
/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResultCopyWith<T, Result<T>> get copyWith => _$ResultCopyWithImpl<T, Result<T>>(this as Result<T>, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Result<T>;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Result<T>&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.message, _this.message) || other.message == _this.message));
}


@override
int get hashCode {
  final _this = this as Result<T>;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.data),_this.type,_this.message);
}

@override
String toString() {
  final _this = this as Result<T>;
  return 'Result<$T>(data: ${_this.data}, type: ${_this.type}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $ResultCopyWith<T,$Res>  {
  factory $ResultCopyWith(Result<T> value, $Res Function(Result<T>) _then) = _$ResultCopyWithImpl;
@useResult
$Res call({
 T? data, ResultType type, String message
});




}
/// @nodoc
class _$ResultCopyWithImpl<T,$Res>
    implements $ResultCopyWith<T, $Res> {
  _$ResultCopyWithImpl(this._self, this._then);

  final Result<T> _self;
  final $Res Function(Result<T>) _then;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,Object? type = null,Object? message = null,}) {
  return _then(Result(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ResultType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Result].
extension ResultPatterns<T> on Result<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Result<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Result() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Result<T> value)  $default,){
final _that = this;
switch (_that) {
case _Result():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Result<T> value)?  $default,){
final _that = this;
switch (_that) {
case _Result() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( T? data,  ResultType type,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Result() when $default != null:
return $default(_that.data,_that.type,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( T? data,  ResultType type,  String message)  $default,) {final _that = this;
switch (_that) {
case _Result():
return $default(_that.data,_that.type,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( T? data,  ResultType type,  String message)?  $default,) {final _that = this;
switch (_that) {
case _Result() when $default != null:
return $default(_that.data,_that.type,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Result<T> implements Result<T> {
  const _Result({required this.data, required this.type, required this.message});
  

@override final  T? data;
@override final  ResultType type;
@override final  String message;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResultCopyWith<T, _Result<T>> get copyWith => __$ResultCopyWithImpl<T, _Result<T>>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Result<T>&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.type, type) || other.type == type)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(data),type,message);
}

@override
String toString() {
    return 'Result<$T>(data: $data, type: $type, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ResultCopyWith<T,$Res> implements $ResultCopyWith<T, $Res> {
  factory _$ResultCopyWith(_Result<T> value, $Res Function(_Result<T>) _then) = __$ResultCopyWithImpl;
@override @useResult
$Res call({
 T? data, ResultType type, String message
});




}
/// @nodoc
class __$ResultCopyWithImpl<T,$Res>
    implements _$ResultCopyWith<T, $Res> {
  __$ResultCopyWithImpl(this._self, this._then);

  final _Result<T> _self;
  final $Res Function(_Result<T>) _then;

/// Create a copy of Result
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,Object? type = null,Object? message = null,}) {
  return _then(_Result<T>(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ResultType,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Script {

 int get id; String get label; DateTime get lastUpdateTime; String? get url; int? get order;
/// Create a copy of Script
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScriptCopyWith<Script> get copyWith => _$ScriptCopyWithImpl<Script>(this as Script, _$identity);

  /// Serializes this Script to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Script;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Script&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.lastUpdateTime, _this.lastUpdateTime) || other.lastUpdateTime == _this.lastUpdateTime)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.order, _this.order) || other.order == _this.order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Script;
  return Object.hash(runtimeType,_this.id,_this.label,_this.lastUpdateTime,_this.url,_this.order);
}

@override
String toString() {
  final _this = this as Script;
  return 'Script(id: ${_this.id}, label: ${_this.label}, lastUpdateTime: ${_this.lastUpdateTime}, url: ${_this.url}, order: ${_this.order})';
}


}

/// @nodoc
abstract mixin class $ScriptCopyWith<$Res>  {
  factory $ScriptCopyWith(Script value, $Res Function(Script) _then) = _$ScriptCopyWithImpl;
@useResult
$Res call({
 int id, String label, DateTime lastUpdateTime, String? url, int? order
});




}
/// @nodoc
class _$ScriptCopyWithImpl<$Res>
    implements $ScriptCopyWith<$Res> {
  _$ScriptCopyWithImpl(this._self, this._then);

  final Script _self;
  final $Res Function(Script) _then;

/// Create a copy of Script
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? lastUpdateTime = null,Object? url = freezed,Object? order = freezed,}) {
  return _then(Script(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,lastUpdateTime: null == lastUpdateTime ? _self.lastUpdateTime : lastUpdateTime // ignore: cast_nullable_to_non_nullable
as DateTime,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Script].
extension ScriptPatterns on Script {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Script value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Script() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Script value)  $default,){
final _that = this;
switch (_that) {
case _Script():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Script value)?  $default,){
final _that = this;
switch (_that) {
case _Script() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String label,  DateTime lastUpdateTime,  String? url,  int? order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Script() when $default != null:
return $default(_that.id,_that.label,_that.lastUpdateTime,_that.url,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String label,  DateTime lastUpdateTime,  String? url,  int? order)  $default,) {final _that = this;
switch (_that) {
case _Script():
return $default(_that.id,_that.label,_that.lastUpdateTime,_that.url,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String label,  DateTime lastUpdateTime,  String? url,  int? order)?  $default,) {final _that = this;
switch (_that) {
case _Script() when $default != null:
return $default(_that.id,_that.label,_that.lastUpdateTime,_that.url,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Script implements Script {
  const _Script({required this.id, required this.label, required this.lastUpdateTime, this.url, this.order});
  factory _Script.fromJson(Map<String, dynamic> json) => _$ScriptFromJson(json);

@override final  int id;
@override final  String label;
@override final  DateTime lastUpdateTime;
@override final  String? url;
@override final  int? order;

/// Create a copy of Script
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScriptCopyWith<_Script> get copyWith => __$ScriptCopyWithImpl<_Script>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScriptToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Script&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.lastUpdateTime, lastUpdateTime) || other.lastUpdateTime == lastUpdateTime)&&(identical(other.url, url) || other.url == url)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,label,lastUpdateTime,url,order);
}

@override
String toString() {
    return 'Script(id: $id, label: $label, lastUpdateTime: $lastUpdateTime, url: $url, order: $order)';
}


}

/// @nodoc
abstract mixin class _$ScriptCopyWith<$Res> implements $ScriptCopyWith<$Res> {
  factory _$ScriptCopyWith(_Script value, $Res Function(_Script) _then) = __$ScriptCopyWithImpl;
@override @useResult
$Res call({
 int id, String label, DateTime lastUpdateTime, String? url, int? order
});




}
/// @nodoc
class __$ScriptCopyWithImpl<$Res>
    implements _$ScriptCopyWith<$Res> {
  __$ScriptCopyWithImpl(this._self, this._then);

  final _Script _self;
  final $Res Function(_Script) _then;

/// Create a copy of Script
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? lastUpdateTime = null,Object? url = freezed,Object? order = freezed,}) {
  return _then(_Script(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,lastUpdateTime: null == lastUpdateTime ? _self.lastUpdateTime : lastUpdateTime // ignore: cast_nullable_to_non_nullable
as DateTime,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$ClashProvider {

 int get id; String get label; String get url; RuleProviderBehavior get behavior; RuleProviderFormat get format; int? get order;
/// Create a copy of ClashProvider
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClashProviderCopyWith<ClashProvider> get copyWith => _$ClashProviderCopyWithImpl<ClashProvider>(this as ClashProvider, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ClashProvider;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClashProvider&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.behavior, _this.behavior) || other.behavior == _this.behavior)&&(identical(other.format, _this.format) || other.format == _this.format)&&(identical(other.order, _this.order) || other.order == _this.order));
}


@override
int get hashCode {
  final _this = this as ClashProvider;
  return Object.hash(runtimeType,_this.id,_this.label,_this.url,_this.behavior,_this.format,_this.order);
}

@override
String toString() {
  final _this = this as ClashProvider;
  return 'ClashProvider(id: ${_this.id}, label: ${_this.label}, url: ${_this.url}, behavior: ${_this.behavior}, format: ${_this.format}, order: ${_this.order})';
}


}

/// @nodoc
abstract mixin class $ClashProviderCopyWith<$Res>  {
  factory $ClashProviderCopyWith(ClashProvider value, $Res Function(ClashProvider) _then) = _$ClashProviderCopyWithImpl;
@useResult
$Res call({
 int id, String label, String url, RuleProviderBehavior behavior, RuleProviderFormat format, int? order
});




}
/// @nodoc
class _$ClashProviderCopyWithImpl<$Res>
    implements $ClashProviderCopyWith<$Res> {
  _$ClashProviderCopyWithImpl(this._self, this._then);

  final ClashProvider _self;
  final $Res Function(ClashProvider) _then;

/// Create a copy of ClashProvider
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? url = null,Object? behavior = null,Object? format = null,Object? order = freezed,}) {
  return _then(ClashProvider(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,behavior: null == behavior ? _self.behavior : behavior // ignore: cast_nullable_to_non_nullable
as RuleProviderBehavior,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as RuleProviderFormat,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClashProvider].
extension ClashProviderPatterns on ClashProvider {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClashProvider value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClashProvider() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClashProvider value)  $default,){
final _that = this;
switch (_that) {
case _ClashProvider():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClashProvider value)?  $default,){
final _that = this;
switch (_that) {
case _ClashProvider() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String label,  String url,  RuleProviderBehavior behavior,  RuleProviderFormat format,  int? order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClashProvider() when $default != null:
return $default(_that.id,_that.label,_that.url,_that.behavior,_that.format,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String label,  String url,  RuleProviderBehavior behavior,  RuleProviderFormat format,  int? order)  $default,) {final _that = this;
switch (_that) {
case _ClashProvider():
return $default(_that.id,_that.label,_that.url,_that.behavior,_that.format,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String label,  String url,  RuleProviderBehavior behavior,  RuleProviderFormat format,  int? order)?  $default,) {final _that = this;
switch (_that) {
case _ClashProvider() when $default != null:
return $default(_that.id,_that.label,_that.url,_that.behavior,_that.format,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _ClashProvider implements ClashProvider {
  const _ClashProvider({required this.id, required this.label, this.url = '', this.behavior = RuleProviderBehavior.classical, this.format = RuleProviderFormat.yaml, this.order});
  

@override final  int id;
@override final  String label;
@override@JsonKey() final  String url;
@override@JsonKey() final  RuleProviderBehavior behavior;
@override@JsonKey() final  RuleProviderFormat format;
@override final  int? order;

/// Create a copy of ClashProvider
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClashProviderCopyWith<_ClashProvider> get copyWith => __$ClashProviderCopyWithImpl<_ClashProvider>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClashProvider&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url)&&(identical(other.behavior, behavior) || other.behavior == behavior)&&(identical(other.format, format) || other.format == format)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,label,url,behavior,format,order);
}

@override
String toString() {
    return 'ClashProvider(id: $id, label: $label, url: $url, behavior: $behavior, format: $format, order: $order)';
}


}

/// @nodoc
abstract mixin class _$ClashProviderCopyWith<$Res> implements $ClashProviderCopyWith<$Res> {
  factory _$ClashProviderCopyWith(_ClashProvider value, $Res Function(_ClashProvider) _then) = __$ClashProviderCopyWithImpl;
@override @useResult
$Res call({
 int id, String label, String url, RuleProviderBehavior behavior, RuleProviderFormat format, int? order
});




}
/// @nodoc
class __$ClashProviderCopyWithImpl<$Res>
    implements _$ClashProviderCopyWith<$Res> {
  __$ClashProviderCopyWithImpl(this._self, this._then);

  final _ClashProvider _self;
  final $Res Function(_ClashProvider) _then;

/// Create a copy of ClashProvider
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? url = null,Object? behavior = null,Object? format = null,Object? order = freezed,}) {
  return _then(_ClashProvider(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,behavior: null == behavior ? _self.behavior : behavior // ignore: cast_nullable_to_non_nullable
as RuleProviderBehavior,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as RuleProviderFormat,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$IconSetIcon {

 String get name; String get url;
/// Create a copy of IconSetIcon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IconSetIconCopyWith<IconSetIcon> get copyWith => _$IconSetIconCopyWithImpl<IconSetIcon>(this as IconSetIcon, _$identity);

  /// Serializes this IconSetIcon to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as IconSetIcon;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IconSetIcon&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.url, _this.url) || other.url == _this.url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as IconSetIcon;
  return Object.hash(runtimeType,_this.name,_this.url);
}

@override
String toString() {
  final _this = this as IconSetIcon;
  return 'IconSetIcon(name: ${_this.name}, url: ${_this.url})';
}


}

/// @nodoc
abstract mixin class $IconSetIconCopyWith<$Res>  {
  factory $IconSetIconCopyWith(IconSetIcon value, $Res Function(IconSetIcon) _then) = _$IconSetIconCopyWithImpl;
@useResult
$Res call({
 String name, String url
});




}
/// @nodoc
class _$IconSetIconCopyWithImpl<$Res>
    implements $IconSetIconCopyWith<$Res> {
  _$IconSetIconCopyWithImpl(this._self, this._then);

  final IconSetIcon _self;
  final $Res Function(IconSetIcon) _then;

/// Create a copy of IconSetIcon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? url = null,}) {
  return _then(IconSetIcon(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IconSetIcon].
extension IconSetIconPatterns on IconSetIcon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IconSetIcon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IconSetIcon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IconSetIcon value)  $default,){
final _that = this;
switch (_that) {
case _IconSetIcon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IconSetIcon value)?  $default,){
final _that = this;
switch (_that) {
case _IconSetIcon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IconSetIcon() when $default != null:
return $default(_that.name,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String url)  $default,) {final _that = this;
switch (_that) {
case _IconSetIcon():
return $default(_that.name,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String url)?  $default,) {final _that = this;
switch (_that) {
case _IconSetIcon() when $default != null:
return $default(_that.name,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IconSetIcon implements IconSetIcon {
  const _IconSetIcon({required this.name, required this.url});
  factory _IconSetIcon.fromJson(Map<String, dynamic> json) => _$IconSetIconFromJson(json);

@override final  String name;
@override final  String url;

/// Create a copy of IconSetIcon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IconSetIconCopyWith<_IconSetIcon> get copyWith => __$IconSetIconCopyWithImpl<_IconSetIcon>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IconSetIconToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IconSetIcon&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,url);
}

@override
String toString() {
    return 'IconSetIcon(name: $name, url: $url)';
}


}

/// @nodoc
abstract mixin class _$IconSetIconCopyWith<$Res> implements $IconSetIconCopyWith<$Res> {
  factory _$IconSetIconCopyWith(_IconSetIcon value, $Res Function(_IconSetIcon) _then) = __$IconSetIconCopyWithImpl;
@override @useResult
$Res call({
 String name, String url
});




}
/// @nodoc
class __$IconSetIconCopyWithImpl<$Res>
    implements _$IconSetIconCopyWith<$Res> {
  __$IconSetIconCopyWithImpl(this._self, this._then);

  final _IconSetIcon _self;
  final $Res Function(_IconSetIcon) _then;

/// Create a copy of IconSetIcon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? url = null,}) {
  return _then(_IconSetIcon(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$IconSet {

 int get id; String get name; String get url; List<IconSetIcon> get icons; DateTime? get lastUpdateTime; int? get order;
/// Create a copy of IconSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IconSetCopyWith<IconSet> get copyWith => _$IconSetCopyWithImpl<IconSet>(this as IconSet, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as IconSet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IconSet&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.url, _this.url) || other.url == _this.url)&&const DeepCollectionEquality().equals(other.icons, _this.icons)&&(identical(other.lastUpdateTime, _this.lastUpdateTime) || other.lastUpdateTime == _this.lastUpdateTime)&&(identical(other.order, _this.order) || other.order == _this.order));
}


@override
int get hashCode {
  final _this = this as IconSet;
  return Object.hash(runtimeType,_this.id,_this.name,_this.url,const DeepCollectionEquality().hash(_this.icons),_this.lastUpdateTime,_this.order);
}

@override
String toString() {
  final _this = this as IconSet;
  return 'IconSet(id: ${_this.id}, name: ${_this.name}, url: ${_this.url}, icons: ${_this.icons}, lastUpdateTime: ${_this.lastUpdateTime}, order: ${_this.order})';
}


}

/// @nodoc
abstract mixin class $IconSetCopyWith<$Res>  {
  factory $IconSetCopyWith(IconSet value, $Res Function(IconSet) _then) = _$IconSetCopyWithImpl;
@useResult
$Res call({
 int id, String name, String url, List<IconSetIcon> icons, DateTime? lastUpdateTime, int? order
});




}
/// @nodoc
class _$IconSetCopyWithImpl<$Res>
    implements $IconSetCopyWith<$Res> {
  _$IconSetCopyWithImpl(this._self, this._then);

  final IconSet _self;
  final $Res Function(IconSet) _then;

/// Create a copy of IconSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? url = null,Object? icons = null,Object? lastUpdateTime = freezed,Object? order = freezed,}) {
  return _then(IconSet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,icons: null == icons ? _self.icons : icons // ignore: cast_nullable_to_non_nullable
as List<IconSetIcon>,lastUpdateTime: freezed == lastUpdateTime ? _self.lastUpdateTime : lastUpdateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [IconSet].
extension IconSetPatterns on IconSet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IconSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IconSet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IconSet value)  $default,){
final _that = this;
switch (_that) {
case _IconSet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IconSet value)?  $default,){
final _that = this;
switch (_that) {
case _IconSet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String url,  List<IconSetIcon> icons,  DateTime? lastUpdateTime,  int? order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IconSet() when $default != null:
return $default(_that.id,_that.name,_that.url,_that.icons,_that.lastUpdateTime,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String url,  List<IconSetIcon> icons,  DateTime? lastUpdateTime,  int? order)  $default,) {final _that = this;
switch (_that) {
case _IconSet():
return $default(_that.id,_that.name,_that.url,_that.icons,_that.lastUpdateTime,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String url,  List<IconSetIcon> icons,  DateTime? lastUpdateTime,  int? order)?  $default,) {final _that = this;
switch (_that) {
case _IconSet() when $default != null:
return $default(_that.id,_that.name,_that.url,_that.icons,_that.lastUpdateTime,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _IconSet implements IconSet {
  const _IconSet({required this.id, required this.name, this.url = '',  List<IconSetIcon> icons = const [], this.lastUpdateTime, this.order}): _icons = icons;
  

@override final  int id;
@override final  String name;
@override@JsonKey() final  String url;
 final  List<IconSetIcon> _icons;
@override@JsonKey() List<IconSetIcon> get icons {
  if (_icons is EqualUnmodifiableListView) return _icons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_icons);
}

@override final  DateTime? lastUpdateTime;
@override final  int? order;

/// Create a copy of IconSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IconSetCopyWith<_IconSet> get copyWith => __$IconSetCopyWithImpl<_IconSet>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _IconSet&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.icons, _icons)&&(identical(other.lastUpdateTime, lastUpdateTime) || other.lastUpdateTime == lastUpdateTime)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,url,const DeepCollectionEquality().hash(_icons),lastUpdateTime,order);
}

@override
String toString() {
    return 'IconSet(id: $id, name: $name, url: $url, icons: $icons, lastUpdateTime: $lastUpdateTime, order: $order)';
}


}

/// @nodoc
abstract mixin class _$IconSetCopyWith<$Res> implements $IconSetCopyWith<$Res> {
  factory _$IconSetCopyWith(_IconSet value, $Res Function(_IconSet) _then) = __$IconSetCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String url, List<IconSetIcon> icons, DateTime? lastUpdateTime, int? order
});




}
/// @nodoc
class __$IconSetCopyWithImpl<$Res>
    implements _$IconSetCopyWith<$Res> {
  __$IconSetCopyWithImpl(this._self, this._then);

  final _IconSet _self;
  final $Res Function(_IconSet) _then;

/// Create a copy of IconSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? url = null,Object? icons = null,Object? lastUpdateTime = freezed,Object? order = freezed,}) {
  return _then(_IconSet(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,icons: null == icons ? _self._icons : icons // ignore: cast_nullable_to_non_nullable
as List<IconSetIcon>,lastUpdateTime: freezed == lastUpdateTime ? _self.lastUpdateTime : lastUpdateTime // ignore: cast_nullable_to_non_nullable
as DateTime?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$UpdatingMessage {

 String get label; String get message;
/// Create a copy of UpdatingMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatingMessageCopyWith<UpdatingMessage> get copyWith => _$UpdatingMessageCopyWithImpl<UpdatingMessage>(this as UpdatingMessage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UpdatingMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatingMessage&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.message, _this.message) || other.message == _this.message));
}


@override
int get hashCode {
  final _this = this as UpdatingMessage;
  return Object.hash(runtimeType,_this.label,_this.message);
}

@override
String toString() {
  final _this = this as UpdatingMessage;
  return 'UpdatingMessage(label: ${_this.label}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $UpdatingMessageCopyWith<$Res>  {
  factory $UpdatingMessageCopyWith(UpdatingMessage value, $Res Function(UpdatingMessage) _then) = _$UpdatingMessageCopyWithImpl;
@useResult
$Res call({
 String label, String message
});




}
/// @nodoc
class _$UpdatingMessageCopyWithImpl<$Res>
    implements $UpdatingMessageCopyWith<$Res> {
  _$UpdatingMessageCopyWithImpl(this._self, this._then);

  final UpdatingMessage _self;
  final $Res Function(UpdatingMessage) _then;

/// Create a copy of UpdatingMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? message = null,}) {
  return _then(UpdatingMessage(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdatingMessage].
extension UpdatingMessagePatterns on UpdatingMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdatingMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdatingMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdatingMessage value)  $default,){
final _that = this;
switch (_that) {
case _UpdatingMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdatingMessage value)?  $default,){
final _that = this;
switch (_that) {
case _UpdatingMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdatingMessage() when $default != null:
return $default(_that.label,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String message)  $default,) {final _that = this;
switch (_that) {
case _UpdatingMessage():
return $default(_that.label,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String message)?  $default,) {final _that = this;
switch (_that) {
case _UpdatingMessage() when $default != null:
return $default(_that.label,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _UpdatingMessage implements UpdatingMessage {
  const _UpdatingMessage({required this.label, required this.message});
  

@override final  String label;
@override final  String message;

/// Create a copy of UpdatingMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatingMessageCopyWith<_UpdatingMessage> get copyWith => __$UpdatingMessageCopyWithImpl<_UpdatingMessage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatingMessage&&(identical(other.label, label) || other.label == label)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,label,message);
}

@override
String toString() {
    return 'UpdatingMessage(label: $label, message: $message)';
}


}

/// @nodoc
abstract mixin class _$UpdatingMessageCopyWith<$Res> implements $UpdatingMessageCopyWith<$Res> {
  factory _$UpdatingMessageCopyWith(_UpdatingMessage value, $Res Function(_UpdatingMessage) _then) = __$UpdatingMessageCopyWithImpl;
@override @useResult
$Res call({
 String label, String message
});




}
/// @nodoc
class __$UpdatingMessageCopyWithImpl<$Res>
    implements _$UpdatingMessageCopyWith<$Res> {
  __$UpdatingMessageCopyWithImpl(this._self, this._then);

  final _UpdatingMessage _self;
  final $Res Function(_UpdatingMessage) _then;

/// Create a copy of UpdatingMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? message = null,}) {
  return _then(_UpdatingMessage(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
