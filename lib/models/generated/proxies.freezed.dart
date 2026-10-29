// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../proxies.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Group {

@JsonKey(fromJson: GroupType.parse) GroupType get type; List<Proxy> get all; String? get now; bool? get hidden; String? get testUrl; String get icon; String get name;
/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupCopyWith<Group> get copyWith => _$GroupCopyWithImpl<Group>(this as Group, _$identity);

  /// Serializes this Group to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Group;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Group&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.all, _this.all)&&(identical(other.now, _this.now) || other.now == _this.now)&&(identical(other.hidden, _this.hidden) || other.hidden == _this.hidden)&&(identical(other.testUrl, _this.testUrl) || other.testUrl == _this.testUrl)&&(identical(other.icon, _this.icon) || other.icon == _this.icon)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Group;
  return Object.hash(runtimeType,_this.type,const DeepCollectionEquality().hash(_this.all),_this.now,_this.hidden,_this.testUrl,_this.icon,_this.name);
}

@override
String toString() {
  final _this = this as Group;
  return 'Group(type: ${_this.type}, all: ${_this.all}, now: ${_this.now}, hidden: ${_this.hidden}, testUrl: ${_this.testUrl}, icon: ${_this.icon}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $GroupCopyWith<$Res>  {
  factory $GroupCopyWith(Group value, $Res Function(Group) _then) = _$GroupCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: GroupType.parse) GroupType type, List<Proxy> all, String? now, bool? hidden, String? testUrl, String icon, String name
});




}
/// @nodoc
class _$GroupCopyWithImpl<$Res>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._self, this._then);

  final Group _self;
  final $Res Function(Group) _then;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? all = null,Object? now = freezed,Object? hidden = freezed,Object? testUrl = freezed,Object? icon = null,Object? name = null,}) {
  return _then(Group(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GroupType,all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as List<Proxy>,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as String?,hidden: freezed == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as bool?,testUrl: freezed == testUrl ? _self.testUrl : testUrl // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Group].
extension GroupPatterns on Group {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Group value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Group() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Group value)  $default,){
final _that = this;
switch (_that) {
case _Group():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Group value)?  $default,){
final _that = this;
switch (_that) {
case _Group() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: GroupType.parse)  GroupType type,  List<Proxy> all,  String? now,  bool? hidden,  String? testUrl,  String icon,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Group() when $default != null:
return $default(_that.type,_that.all,_that.now,_that.hidden,_that.testUrl,_that.icon,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: GroupType.parse)  GroupType type,  List<Proxy> all,  String? now,  bool? hidden,  String? testUrl,  String icon,  String name)  $default,) {final _that = this;
switch (_that) {
case _Group():
return $default(_that.type,_that.all,_that.now,_that.hidden,_that.testUrl,_that.icon,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: GroupType.parse)  GroupType type,  List<Proxy> all,  String? now,  bool? hidden,  String? testUrl,  String icon,  String name)?  $default,) {final _that = this;
switch (_that) {
case _Group() when $default != null:
return $default(_that.type,_that.all,_that.now,_that.hidden,_that.testUrl,_that.icon,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Group implements Group {
  const _Group({@JsonKey(fromJson: GroupType.parse) required this.type,  List<Proxy> all = const [], this.now, this.hidden, this.testUrl, this.icon = '', required this.name}): _all = all;
  factory _Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

@override@JsonKey(fromJson: GroupType.parse) final  GroupType type;
 final  List<Proxy> _all;
@override@JsonKey() List<Proxy> get all {
  if (_all is EqualUnmodifiableListView) return _all;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_all);
}

@override final  String? now;
@override final  bool? hidden;
@override final  String? testUrl;
@override@JsonKey() final  String icon;
@override final  String name;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupCopyWith<_Group> get copyWith => __$GroupCopyWithImpl<_Group>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Group&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.all, _all)&&(identical(other.now, now) || other.now == now)&&(identical(other.hidden, hidden) || other.hidden == hidden)&&(identical(other.testUrl, testUrl) || other.testUrl == testUrl)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_all),now,hidden,testUrl,icon,name);
}

@override
String toString() {
    return 'Group(type: $type, all: $all, now: $now, hidden: $hidden, testUrl: $testUrl, icon: $icon, name: $name)';
}


}

/// @nodoc
abstract mixin class _$GroupCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$GroupCopyWith(_Group value, $Res Function(_Group) _then) = __$GroupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: GroupType.parse) GroupType type, List<Proxy> all, String? now, bool? hidden, String? testUrl, String icon, String name
});




}
/// @nodoc
class __$GroupCopyWithImpl<$Res>
    implements _$GroupCopyWith<$Res> {
  __$GroupCopyWithImpl(this._self, this._then);

  final _Group _self;
  final $Res Function(_Group) _then;

/// Create a copy of Group
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? all = null,Object? now = freezed,Object? hidden = freezed,Object? testUrl = freezed,Object? icon = null,Object? name = null,}) {
  return _then(_Group(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as GroupType,all: null == all ? _self._all : all // ignore: cast_nullable_to_non_nullable
as List<Proxy>,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as String?,hidden: freezed == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as bool?,testUrl: freezed == testUrl ? _self.testUrl : testUrl // ignore: cast_nullable_to_non_nullable
as String?,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Proxy {

 String get name; String get type; String? get now;@JsonKey(name: 'provider-name') String? get providerName;
/// Create a copy of Proxy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProxyCopyWith<Proxy> get copyWith => _$ProxyCopyWithImpl<Proxy>(this as Proxy, _$identity);

  /// Serializes this Proxy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Proxy;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Proxy&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.now, _this.now) || other.now == _this.now)&&(identical(other.providerName, _this.providerName) || other.providerName == _this.providerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Proxy;
  return Object.hash(runtimeType,_this.name,_this.type,_this.now,_this.providerName);
}

@override
String toString() {
  final _this = this as Proxy;
  return 'Proxy(name: ${_this.name}, type: ${_this.type}, now: ${_this.now}, providerName: ${_this.providerName})';
}


}

/// @nodoc
abstract mixin class $ProxyCopyWith<$Res>  {
  factory $ProxyCopyWith(Proxy value, $Res Function(Proxy) _then) = _$ProxyCopyWithImpl;
@useResult
$Res call({
 String name, String type, String? now,@JsonKey(name: 'provider-name') String? providerName
});




}
/// @nodoc
class _$ProxyCopyWithImpl<$Res>
    implements $ProxyCopyWith<$Res> {
  _$ProxyCopyWithImpl(this._self, this._then);

  final Proxy _self;
  final $Res Function(Proxy) _then;

/// Create a copy of Proxy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? now = freezed,Object? providerName = freezed,}) {
  return _then(Proxy(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as String?,providerName: freezed == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Proxy].
extension ProxyPatterns on Proxy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Proxy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Proxy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Proxy value)  $default,){
final _that = this;
switch (_that) {
case _Proxy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Proxy value)?  $default,){
final _that = this;
switch (_that) {
case _Proxy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String type,  String? now, @JsonKey(name: 'provider-name')  String? providerName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Proxy() when $default != null:
return $default(_that.name,_that.type,_that.now,_that.providerName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String type,  String? now, @JsonKey(name: 'provider-name')  String? providerName)  $default,) {final _that = this;
switch (_that) {
case _Proxy():
return $default(_that.name,_that.type,_that.now,_that.providerName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String type,  String? now, @JsonKey(name: 'provider-name')  String? providerName)?  $default,) {final _that = this;
switch (_that) {
case _Proxy() when $default != null:
return $default(_that.name,_that.type,_that.now,_that.providerName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Proxy implements Proxy {
  const _Proxy({required this.name, required this.type, this.now, @JsonKey(name: 'provider-name') this.providerName});
  factory _Proxy.fromJson(Map<String, dynamic> json) => _$ProxyFromJson(json);

@override final  String name;
@override final  String type;
@override final  String? now;
@override@JsonKey(name: 'provider-name') final  String? providerName;

/// Create a copy of Proxy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProxyCopyWith<_Proxy> get copyWith => __$ProxyCopyWithImpl<_Proxy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProxyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Proxy&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.now, now) || other.now == now)&&(identical(other.providerName, providerName) || other.providerName == providerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,type,now,providerName);
}

@override
String toString() {
    return 'Proxy(name: $name, type: $type, now: $now, providerName: $providerName)';
}


}

/// @nodoc
abstract mixin class _$ProxyCopyWith<$Res> implements $ProxyCopyWith<$Res> {
  factory _$ProxyCopyWith(_Proxy value, $Res Function(_Proxy) _then) = __$ProxyCopyWithImpl;
@override @useResult
$Res call({
 String name, String type, String? now,@JsonKey(name: 'provider-name') String? providerName
});




}
/// @nodoc
class __$ProxyCopyWithImpl<$Res>
    implements _$ProxyCopyWith<$Res> {
  __$ProxyCopyWithImpl(this._self, this._then);

  final _Proxy _self;
  final $Res Function(_Proxy) _then;

/// Create a copy of Proxy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? now = freezed,Object? providerName = freezed,}) {
  return _then(_Proxy(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as String?,providerName: freezed == providerName ? _self.providerName : providerName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProxiesStyleProps {

 ProxiesType get type; ProxiesSortType get sortType; ProxiesLayout get layout;@JsonKey(fromJson: proxiesIconStyleSafeFromJson) ProxiesIconStyle get iconStyle;@JsonKey(fromJson: proxyCardTypeSafeFromJson) ProxyCardType get cardType; bool get hideTimeoutProxies;
/// Create a copy of ProxiesStyleProps
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProxiesStylePropsCopyWith<ProxiesStyleProps> get copyWith => _$ProxiesStylePropsCopyWithImpl<ProxiesStyleProps>(this as ProxiesStyleProps, _$identity);

  /// Serializes this ProxiesStyleProps to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProxiesStyleProps;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProxiesStyleProps&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.sortType, _this.sortType) || other.sortType == _this.sortType)&&(identical(other.layout, _this.layout) || other.layout == _this.layout)&&(identical(other.iconStyle, _this.iconStyle) || other.iconStyle == _this.iconStyle)&&(identical(other.cardType, _this.cardType) || other.cardType == _this.cardType)&&(identical(other.hideTimeoutProxies, _this.hideTimeoutProxies) || other.hideTimeoutProxies == _this.hideTimeoutProxies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProxiesStyleProps;
  return Object.hash(runtimeType,_this.type,_this.sortType,_this.layout,_this.iconStyle,_this.cardType,_this.hideTimeoutProxies);
}

@override
String toString() {
  final _this = this as ProxiesStyleProps;
  return 'ProxiesStyleProps(type: ${_this.type}, sortType: ${_this.sortType}, layout: ${_this.layout}, iconStyle: ${_this.iconStyle}, cardType: ${_this.cardType}, hideTimeoutProxies: ${_this.hideTimeoutProxies})';
}


}

/// @nodoc
abstract mixin class $ProxiesStylePropsCopyWith<$Res>  {
  factory $ProxiesStylePropsCopyWith(ProxiesStyleProps value, $Res Function(ProxiesStyleProps) _then) = _$ProxiesStylePropsCopyWithImpl;
@useResult
$Res call({
 ProxiesType type, ProxiesSortType sortType, ProxiesLayout layout,@JsonKey(fromJson: proxiesIconStyleSafeFromJson) ProxiesIconStyle iconStyle,@JsonKey(fromJson: proxyCardTypeSafeFromJson) ProxyCardType cardType, bool hideTimeoutProxies
});




}
/// @nodoc
class _$ProxiesStylePropsCopyWithImpl<$Res>
    implements $ProxiesStylePropsCopyWith<$Res> {
  _$ProxiesStylePropsCopyWithImpl(this._self, this._then);

  final ProxiesStyleProps _self;
  final $Res Function(ProxiesStyleProps) _then;

/// Create a copy of ProxiesStyleProps
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? sortType = null,Object? layout = null,Object? iconStyle = null,Object? cardType = null,Object? hideTimeoutProxies = null,}) {
  return _then(ProxiesStyleProps(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProxiesType,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as ProxiesSortType,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as ProxiesLayout,iconStyle: null == iconStyle ? _self.iconStyle : iconStyle // ignore: cast_nullable_to_non_nullable
as ProxiesIconStyle,cardType: null == cardType ? _self.cardType : cardType // ignore: cast_nullable_to_non_nullable
as ProxyCardType,hideTimeoutProxies: null == hideTimeoutProxies ? _self.hideTimeoutProxies : hideTimeoutProxies // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProxiesStyleProps].
extension ProxiesStylePropsPatterns on ProxiesStyleProps {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProxiesStyleProps value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProxiesStyleProps() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProxiesStyleProps value)  $default,){
final _that = this;
switch (_that) {
case _ProxiesStyleProps():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProxiesStyleProps value)?  $default,){
final _that = this;
switch (_that) {
case _ProxiesStyleProps() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProxiesType type,  ProxiesSortType sortType,  ProxiesLayout layout, @JsonKey(fromJson: proxiesIconStyleSafeFromJson)  ProxiesIconStyle iconStyle, @JsonKey(fromJson: proxyCardTypeSafeFromJson)  ProxyCardType cardType,  bool hideTimeoutProxies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProxiesStyleProps() when $default != null:
return $default(_that.type,_that.sortType,_that.layout,_that.iconStyle,_that.cardType,_that.hideTimeoutProxies);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProxiesType type,  ProxiesSortType sortType,  ProxiesLayout layout, @JsonKey(fromJson: proxiesIconStyleSafeFromJson)  ProxiesIconStyle iconStyle, @JsonKey(fromJson: proxyCardTypeSafeFromJson)  ProxyCardType cardType,  bool hideTimeoutProxies)  $default,) {final _that = this;
switch (_that) {
case _ProxiesStyleProps():
return $default(_that.type,_that.sortType,_that.layout,_that.iconStyle,_that.cardType,_that.hideTimeoutProxies);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProxiesType type,  ProxiesSortType sortType,  ProxiesLayout layout, @JsonKey(fromJson: proxiesIconStyleSafeFromJson)  ProxiesIconStyle iconStyle, @JsonKey(fromJson: proxyCardTypeSafeFromJson)  ProxyCardType cardType,  bool hideTimeoutProxies)?  $default,) {final _that = this;
switch (_that) {
case _ProxiesStyleProps() when $default != null:
return $default(_that.type,_that.sortType,_that.layout,_that.iconStyle,_that.cardType,_that.hideTimeoutProxies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProxiesStyleProps implements ProxiesStyleProps {
  const _ProxiesStyleProps({this.type = ProxiesType.list, this.sortType = ProxiesSortType.none, this.layout = ProxiesLayout.standard, @JsonKey(fromJson: proxiesIconStyleSafeFromJson) this.iconStyle = ProxiesIconStyle.filled, @JsonKey(fromJson: proxyCardTypeSafeFromJson) this.cardType = ProxyCardType.standard, this.hideTimeoutProxies = false});
  factory _ProxiesStyleProps.fromJson(Map<String, dynamic> json) => _$ProxiesStylePropsFromJson(json);

@override@JsonKey() final  ProxiesType type;
@override@JsonKey() final  ProxiesSortType sortType;
@override@JsonKey() final  ProxiesLayout layout;
@override@JsonKey(fromJson: proxiesIconStyleSafeFromJson) final  ProxiesIconStyle iconStyle;
@override@JsonKey(fromJson: proxyCardTypeSafeFromJson) final  ProxyCardType cardType;
@override@JsonKey() final  bool hideTimeoutProxies;

/// Create a copy of ProxiesStyleProps
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProxiesStylePropsCopyWith<_ProxiesStyleProps> get copyWith => __$ProxiesStylePropsCopyWithImpl<_ProxiesStyleProps>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProxiesStylePropsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProxiesStyleProps&&(identical(other.type, type) || other.type == type)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.iconStyle, iconStyle) || other.iconStyle == iconStyle)&&(identical(other.cardType, cardType) || other.cardType == cardType)&&(identical(other.hideTimeoutProxies, hideTimeoutProxies) || other.hideTimeoutProxies == hideTimeoutProxies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,sortType,layout,iconStyle,cardType,hideTimeoutProxies);
}

@override
String toString() {
    return 'ProxiesStyleProps(type: $type, sortType: $sortType, layout: $layout, iconStyle: $iconStyle, cardType: $cardType, hideTimeoutProxies: $hideTimeoutProxies)';
}


}

/// @nodoc
abstract mixin class _$ProxiesStylePropsCopyWith<$Res> implements $ProxiesStylePropsCopyWith<$Res> {
  factory _$ProxiesStylePropsCopyWith(_ProxiesStyleProps value, $Res Function(_ProxiesStyleProps) _then) = __$ProxiesStylePropsCopyWithImpl;
@override @useResult
$Res call({
 ProxiesType type, ProxiesSortType sortType, ProxiesLayout layout,@JsonKey(fromJson: proxiesIconStyleSafeFromJson) ProxiesIconStyle iconStyle,@JsonKey(fromJson: proxyCardTypeSafeFromJson) ProxyCardType cardType, bool hideTimeoutProxies
});




}
/// @nodoc
class __$ProxiesStylePropsCopyWithImpl<$Res>
    implements _$ProxiesStylePropsCopyWith<$Res> {
  __$ProxiesStylePropsCopyWithImpl(this._self, this._then);

  final _ProxiesStyleProps _self;
  final $Res Function(_ProxiesStyleProps) _then;

/// Create a copy of ProxiesStyleProps
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? sortType = null,Object? layout = null,Object? iconStyle = null,Object? cardType = null,Object? hideTimeoutProxies = null,}) {
  return _then(_ProxiesStyleProps(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ProxiesType,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as ProxiesSortType,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as ProxiesLayout,iconStyle: null == iconStyle ? _self.iconStyle : iconStyle // ignore: cast_nullable_to_non_nullable
as ProxiesIconStyle,cardType: null == cardType ? _self.cardType : cardType // ignore: cast_nullable_to_non_nullable
as ProxyCardType,hideTimeoutProxies: null == hideTimeoutProxies ? _self.hideTimeoutProxies : hideTimeoutProxies // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$DelayState {

 int get delay; bool get group;
/// Create a copy of DelayState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DelayStateCopyWith<DelayState> get copyWith => _$DelayStateCopyWithImpl<DelayState>(this as DelayState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DelayState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DelayState&&(identical(other.delay, _this.delay) || other.delay == _this.delay)&&(identical(other.group, _this.group) || other.group == _this.group));
}


@override
int get hashCode {
  final _this = this as DelayState;
  return Object.hash(runtimeType,_this.delay,_this.group);
}

@override
String toString() {
  final _this = this as DelayState;
  return 'DelayState(delay: ${_this.delay}, group: ${_this.group})';
}


}

/// @nodoc
abstract mixin class $DelayStateCopyWith<$Res>  {
  factory $DelayStateCopyWith(DelayState value, $Res Function(DelayState) _then) = _$DelayStateCopyWithImpl;
@useResult
$Res call({
 int delay, bool group
});




}
/// @nodoc
class _$DelayStateCopyWithImpl<$Res>
    implements $DelayStateCopyWith<$Res> {
  _$DelayStateCopyWithImpl(this._self, this._then);

  final DelayState _self;
  final $Res Function(DelayState) _then;

/// Create a copy of DelayState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? delay = null,Object? group = null,}) {
  return _then(DelayState(
delay: null == delay ? _self.delay : delay // ignore: cast_nullable_to_non_nullable
as int,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DelayState].
extension DelayStatePatterns on DelayState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DelayState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DelayState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DelayState value)  $default,){
final _that = this;
switch (_that) {
case _DelayState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DelayState value)?  $default,){
final _that = this;
switch (_that) {
case _DelayState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int delay,  bool group)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DelayState() when $default != null:
return $default(_that.delay,_that.group);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int delay,  bool group)  $default,) {final _that = this;
switch (_that) {
case _DelayState():
return $default(_that.delay,_that.group);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int delay,  bool group)?  $default,) {final _that = this;
switch (_that) {
case _DelayState() when $default != null:
return $default(_that.delay,_that.group);case _:
  return null;

}
}

}

/// @nodoc


class _DelayState implements DelayState {
  const _DelayState({required this.delay, required this.group});
  

@override final  int delay;
@override final  bool group;

/// Create a copy of DelayState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DelayStateCopyWith<_DelayState> get copyWith => __$DelayStateCopyWithImpl<_DelayState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DelayState&&(identical(other.delay, delay) || other.delay == delay)&&(identical(other.group, group) || other.group == group));
}


@override
int get hashCode {
    return Object.hash(runtimeType,delay,group);
}

@override
String toString() {
    return 'DelayState(delay: $delay, group: $group)';
}


}

/// @nodoc
abstract mixin class _$DelayStateCopyWith<$Res> implements $DelayStateCopyWith<$Res> {
  factory _$DelayStateCopyWith(_DelayState value, $Res Function(_DelayState) _then) = __$DelayStateCopyWithImpl;
@override @useResult
$Res call({
 int delay, bool group
});




}
/// @nodoc
class __$DelayStateCopyWithImpl<$Res>
    implements _$DelayStateCopyWith<$Res> {
  __$DelayStateCopyWithImpl(this._self, this._then);

  final _DelayState _self;
  final $Res Function(_DelayState) _then;

/// Create a copy of DelayState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? delay = null,Object? group = null,}) {
  return _then(_DelayState(
delay: null == delay ? _self.delay : delay // ignore: cast_nullable_to_non_nullable
as int,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SelectedProxyState {

 String get proxyName; bool get group; String? get testUrl;
/// Create a copy of SelectedProxyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedProxyStateCopyWith<SelectedProxyState> get copyWith => _$SelectedProxyStateCopyWithImpl<SelectedProxyState>(this as SelectedProxyState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SelectedProxyState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedProxyState&&(identical(other.proxyName, _this.proxyName) || other.proxyName == _this.proxyName)&&(identical(other.group, _this.group) || other.group == _this.group)&&(identical(other.testUrl, _this.testUrl) || other.testUrl == _this.testUrl));
}


@override
int get hashCode {
  final _this = this as SelectedProxyState;
  return Object.hash(runtimeType,_this.proxyName,_this.group,_this.testUrl);
}

@override
String toString() {
  final _this = this as SelectedProxyState;
  return 'SelectedProxyState(proxyName: ${_this.proxyName}, group: ${_this.group}, testUrl: ${_this.testUrl})';
}


}

/// @nodoc
abstract mixin class $SelectedProxyStateCopyWith<$Res>  {
  factory $SelectedProxyStateCopyWith(SelectedProxyState value, $Res Function(SelectedProxyState) _then) = _$SelectedProxyStateCopyWithImpl;
@useResult
$Res call({
 String proxyName, bool group, String? testUrl
});




}
/// @nodoc
class _$SelectedProxyStateCopyWithImpl<$Res>
    implements $SelectedProxyStateCopyWith<$Res> {
  _$SelectedProxyStateCopyWithImpl(this._self, this._then);

  final SelectedProxyState _self;
  final $Res Function(SelectedProxyState) _then;

/// Create a copy of SelectedProxyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? proxyName = null,Object? group = null,Object? testUrl = freezed,}) {
  return _then(SelectedProxyState(
proxyName: null == proxyName ? _self.proxyName : proxyName // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as bool,testUrl: freezed == testUrl ? _self.testUrl : testUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectedProxyState].
extension SelectedProxyStatePatterns on SelectedProxyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectedProxyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectedProxyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectedProxyState value)  $default,){
final _that = this;
switch (_that) {
case _SelectedProxyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectedProxyState value)?  $default,){
final _that = this;
switch (_that) {
case _SelectedProxyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String proxyName,  bool group,  String? testUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectedProxyState() when $default != null:
return $default(_that.proxyName,_that.group,_that.testUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String proxyName,  bool group,  String? testUrl)  $default,) {final _that = this;
switch (_that) {
case _SelectedProxyState():
return $default(_that.proxyName,_that.group,_that.testUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String proxyName,  bool group,  String? testUrl)?  $default,) {final _that = this;
switch (_that) {
case _SelectedProxyState() when $default != null:
return $default(_that.proxyName,_that.group,_that.testUrl);case _:
  return null;

}
}

}

/// @nodoc


class _SelectedProxyState implements SelectedProxyState {
  const _SelectedProxyState({required this.proxyName, this.group = false, this.testUrl});
  

@override final  String proxyName;
@override@JsonKey() final  bool group;
@override final  String? testUrl;

/// Create a copy of SelectedProxyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedProxyStateCopyWith<_SelectedProxyState> get copyWith => __$SelectedProxyStateCopyWithImpl<_SelectedProxyState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedProxyState&&(identical(other.proxyName, proxyName) || other.proxyName == proxyName)&&(identical(other.group, group) || other.group == group)&&(identical(other.testUrl, testUrl) || other.testUrl == testUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,proxyName,group,testUrl);
}

@override
String toString() {
    return 'SelectedProxyState(proxyName: $proxyName, group: $group, testUrl: $testUrl)';
}


}

/// @nodoc
abstract mixin class _$SelectedProxyStateCopyWith<$Res> implements $SelectedProxyStateCopyWith<$Res> {
  factory _$SelectedProxyStateCopyWith(_SelectedProxyState value, $Res Function(_SelectedProxyState) _then) = __$SelectedProxyStateCopyWithImpl;
@override @useResult
$Res call({
 String proxyName, bool group, String? testUrl
});




}
/// @nodoc
class __$SelectedProxyStateCopyWithImpl<$Res>
    implements _$SelectedProxyStateCopyWith<$Res> {
  __$SelectedProxyStateCopyWithImpl(this._self, this._then);

  final _SelectedProxyState _self;
  final $Res Function(_SelectedProxyState) _then;

/// Create a copy of SelectedProxyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? proxyName = null,Object? group = null,Object? testUrl = freezed,}) {
  return _then(_SelectedProxyState(
proxyName: null == proxyName ? _self.proxyName : proxyName // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as bool,testUrl: freezed == testUrl ? _self.testUrl : testUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ProxiesListState {

 List<Group> get groups; Set<String> get currentUnfoldSet; ProxyCardType get proxyCardType;
/// Create a copy of ProxiesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProxiesListStateCopyWith<ProxiesListState> get copyWith => _$ProxiesListStateCopyWithImpl<ProxiesListState>(this as ProxiesListState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProxiesListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProxiesListState&&const DeepCollectionEquality().equals(other.groups, _this.groups)&&const DeepCollectionEquality().equals(other.currentUnfoldSet, _this.currentUnfoldSet)&&(identical(other.proxyCardType, _this.proxyCardType) || other.proxyCardType == _this.proxyCardType));
}


@override
int get hashCode {
  final _this = this as ProxiesListState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.groups),const DeepCollectionEquality().hash(_this.currentUnfoldSet),_this.proxyCardType);
}

@override
String toString() {
  final _this = this as ProxiesListState;
  return 'ProxiesListState(groups: ${_this.groups}, currentUnfoldSet: ${_this.currentUnfoldSet}, proxyCardType: ${_this.proxyCardType})';
}


}

/// @nodoc
abstract mixin class $ProxiesListStateCopyWith<$Res>  {
  factory $ProxiesListStateCopyWith(ProxiesListState value, $Res Function(ProxiesListState) _then) = _$ProxiesListStateCopyWithImpl;
@useResult
$Res call({
 List<Group> groups, Set<String> currentUnfoldSet, ProxyCardType proxyCardType
});




}
/// @nodoc
class _$ProxiesListStateCopyWithImpl<$Res>
    implements $ProxiesListStateCopyWith<$Res> {
  _$ProxiesListStateCopyWithImpl(this._self, this._then);

  final ProxiesListState _self;
  final $Res Function(ProxiesListState) _then;

/// Create a copy of ProxiesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,Object? currentUnfoldSet = null,Object? proxyCardType = null,}) {
  return _then(ProxiesListState(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,currentUnfoldSet: null == currentUnfoldSet ? _self.currentUnfoldSet : currentUnfoldSet // ignore: cast_nullable_to_non_nullable
as Set<String>,proxyCardType: null == proxyCardType ? _self.proxyCardType : proxyCardType // ignore: cast_nullable_to_non_nullable
as ProxyCardType,
  ));
}

}


/// Adds pattern-matching-related methods to [ProxiesListState].
extension ProxiesListStatePatterns on ProxiesListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProxiesListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProxiesListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProxiesListState value)  $default,){
final _that = this;
switch (_that) {
case _ProxiesListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProxiesListState value)?  $default,){
final _that = this;
switch (_that) {
case _ProxiesListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Group> groups,  Set<String> currentUnfoldSet,  ProxyCardType proxyCardType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProxiesListState() when $default != null:
return $default(_that.groups,_that.currentUnfoldSet,_that.proxyCardType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Group> groups,  Set<String> currentUnfoldSet,  ProxyCardType proxyCardType)  $default,) {final _that = this;
switch (_that) {
case _ProxiesListState():
return $default(_that.groups,_that.currentUnfoldSet,_that.proxyCardType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Group> groups,  Set<String> currentUnfoldSet,  ProxyCardType proxyCardType)?  $default,) {final _that = this;
switch (_that) {
case _ProxiesListState() when $default != null:
return $default(_that.groups,_that.currentUnfoldSet,_that.proxyCardType);case _:
  return null;

}
}

}

/// @nodoc


class _ProxiesListState implements ProxiesListState {
  const _ProxiesListState({required  List<Group> groups, required  Set<String> currentUnfoldSet, required this.proxyCardType}): _groups = groups,_currentUnfoldSet = currentUnfoldSet;
  

 final  List<Group> _groups;
@override List<Group> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

 final  Set<String> _currentUnfoldSet;
@override Set<String> get currentUnfoldSet {
  if (_currentUnfoldSet is EqualUnmodifiableSetView) return _currentUnfoldSet;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_currentUnfoldSet);
}

@override final  ProxyCardType proxyCardType;

/// Create a copy of ProxiesListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProxiesListStateCopyWith<_ProxiesListState> get copyWith => __$ProxiesListStateCopyWithImpl<_ProxiesListState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProxiesListState&&const DeepCollectionEquality().equals(other.groups, _groups)&&const DeepCollectionEquality().equals(other.currentUnfoldSet, _currentUnfoldSet)&&(identical(other.proxyCardType, proxyCardType) || other.proxyCardType == proxyCardType));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_currentUnfoldSet),proxyCardType);
}

@override
String toString() {
    return 'ProxiesListState(groups: $groups, currentUnfoldSet: $currentUnfoldSet, proxyCardType: $proxyCardType)';
}


}

/// @nodoc
abstract mixin class _$ProxiesListStateCopyWith<$Res> implements $ProxiesListStateCopyWith<$Res> {
  factory _$ProxiesListStateCopyWith(_ProxiesListState value, $Res Function(_ProxiesListState) _then) = __$ProxiesListStateCopyWithImpl;
@override @useResult
$Res call({
 List<Group> groups, Set<String> currentUnfoldSet, ProxyCardType proxyCardType
});




}
/// @nodoc
class __$ProxiesListStateCopyWithImpl<$Res>
    implements _$ProxiesListStateCopyWith<$Res> {
  __$ProxiesListStateCopyWithImpl(this._self, this._then);

  final _ProxiesListState _self;
  final $Res Function(_ProxiesListState) _then;

/// Create a copy of ProxiesListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,Object? currentUnfoldSet = null,Object? proxyCardType = null,}) {
  return _then(_ProxiesListState(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,currentUnfoldSet: null == currentUnfoldSet ? _self._currentUnfoldSet : currentUnfoldSet // ignore: cast_nullable_to_non_nullable
as Set<String>,proxyCardType: null == proxyCardType ? _self.proxyCardType : proxyCardType // ignore: cast_nullable_to_non_nullable
as ProxyCardType,
  ));
}


}

/// @nodoc
mixin _$ProxiesTabState {

 List<Group> get groups; String? get currentGroupName; ProxyCardType get proxyCardType;
/// Create a copy of ProxiesTabState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProxiesTabStateCopyWith<ProxiesTabState> get copyWith => _$ProxiesTabStateCopyWithImpl<ProxiesTabState>(this as ProxiesTabState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProxiesTabState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProxiesTabState&&const DeepCollectionEquality().equals(other.groups, _this.groups)&&(identical(other.currentGroupName, _this.currentGroupName) || other.currentGroupName == _this.currentGroupName)&&(identical(other.proxyCardType, _this.proxyCardType) || other.proxyCardType == _this.proxyCardType));
}


@override
int get hashCode {
  final _this = this as ProxiesTabState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.groups),_this.currentGroupName,_this.proxyCardType);
}

@override
String toString() {
  final _this = this as ProxiesTabState;
  return 'ProxiesTabState(groups: ${_this.groups}, currentGroupName: ${_this.currentGroupName}, proxyCardType: ${_this.proxyCardType})';
}


}

/// @nodoc
abstract mixin class $ProxiesTabStateCopyWith<$Res>  {
  factory $ProxiesTabStateCopyWith(ProxiesTabState value, $Res Function(ProxiesTabState) _then) = _$ProxiesTabStateCopyWithImpl;
@useResult
$Res call({
 List<Group> groups, String? currentGroupName, ProxyCardType proxyCardType
});




}
/// @nodoc
class _$ProxiesTabStateCopyWithImpl<$Res>
    implements $ProxiesTabStateCopyWith<$Res> {
  _$ProxiesTabStateCopyWithImpl(this._self, this._then);

  final ProxiesTabState _self;
  final $Res Function(ProxiesTabState) _then;

/// Create a copy of ProxiesTabState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,Object? currentGroupName = freezed,Object? proxyCardType = null,}) {
  return _then(ProxiesTabState(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,currentGroupName: freezed == currentGroupName ? _self.currentGroupName : currentGroupName // ignore: cast_nullable_to_non_nullable
as String?,proxyCardType: null == proxyCardType ? _self.proxyCardType : proxyCardType // ignore: cast_nullable_to_non_nullable
as ProxyCardType,
  ));
}

}


/// Adds pattern-matching-related methods to [ProxiesTabState].
extension ProxiesTabStatePatterns on ProxiesTabState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProxiesTabState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProxiesTabState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProxiesTabState value)  $default,){
final _that = this;
switch (_that) {
case _ProxiesTabState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProxiesTabState value)?  $default,){
final _that = this;
switch (_that) {
case _ProxiesTabState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Group> groups,  String? currentGroupName,  ProxyCardType proxyCardType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProxiesTabState() when $default != null:
return $default(_that.groups,_that.currentGroupName,_that.proxyCardType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Group> groups,  String? currentGroupName,  ProxyCardType proxyCardType)  $default,) {final _that = this;
switch (_that) {
case _ProxiesTabState():
return $default(_that.groups,_that.currentGroupName,_that.proxyCardType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Group> groups,  String? currentGroupName,  ProxyCardType proxyCardType)?  $default,) {final _that = this;
switch (_that) {
case _ProxiesTabState() when $default != null:
return $default(_that.groups,_that.currentGroupName,_that.proxyCardType);case _:
  return null;

}
}

}

/// @nodoc


class _ProxiesTabState implements ProxiesTabState {
  const _ProxiesTabState({required  List<Group> groups, required this.currentGroupName, required this.proxyCardType}): _groups = groups;
  

 final  List<Group> _groups;
@override List<Group> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

@override final  String? currentGroupName;
@override final  ProxyCardType proxyCardType;

/// Create a copy of ProxiesTabState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProxiesTabStateCopyWith<_ProxiesTabState> get copyWith => __$ProxiesTabStateCopyWithImpl<_ProxiesTabState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProxiesTabState&&const DeepCollectionEquality().equals(other.groups, _groups)&&(identical(other.currentGroupName, currentGroupName) || other.currentGroupName == currentGroupName)&&(identical(other.proxyCardType, proxyCardType) || other.proxyCardType == proxyCardType));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_groups),currentGroupName,proxyCardType);
}

@override
String toString() {
    return 'ProxiesTabState(groups: $groups, currentGroupName: $currentGroupName, proxyCardType: $proxyCardType)';
}


}

/// @nodoc
abstract mixin class _$ProxiesTabStateCopyWith<$Res> implements $ProxiesTabStateCopyWith<$Res> {
  factory _$ProxiesTabStateCopyWith(_ProxiesTabState value, $Res Function(_ProxiesTabState) _then) = __$ProxiesTabStateCopyWithImpl;
@override @useResult
$Res call({
 List<Group> groups, String? currentGroupName, ProxyCardType proxyCardType
});




}
/// @nodoc
class __$ProxiesTabStateCopyWithImpl<$Res>
    implements _$ProxiesTabStateCopyWith<$Res> {
  __$ProxiesTabStateCopyWithImpl(this._self, this._then);

  final _ProxiesTabState _self;
  final $Res Function(_ProxiesTabState) _then;

/// Create a copy of ProxiesTabState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,Object? currentGroupName = freezed,Object? proxyCardType = null,}) {
  return _then(_ProxiesTabState(
groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,currentGroupName: freezed == currentGroupName ? _self.currentGroupName : currentGroupName // ignore: cast_nullable_to_non_nullable
as String?,proxyCardType: null == proxyCardType ? _self.proxyCardType : proxyCardType // ignore: cast_nullable_to_non_nullable
as ProxyCardType,
  ));
}


}

/// @nodoc
mixin _$ProxiesTabControllerState {

 List<String> get groupNames; String? get currentGroupName;
/// Create a copy of ProxiesTabControllerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProxiesTabControllerStateCopyWith<ProxiesTabControllerState> get copyWith => _$ProxiesTabControllerStateCopyWithImpl<ProxiesTabControllerState>(this as ProxiesTabControllerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProxiesTabControllerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProxiesTabControllerState&&const DeepCollectionEquality().equals(other.groupNames, _this.groupNames)&&(identical(other.currentGroupName, _this.currentGroupName) || other.currentGroupName == _this.currentGroupName));
}


@override
int get hashCode {
  final _this = this as ProxiesTabControllerState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.groupNames),_this.currentGroupName);
}

@override
String toString() {
  final _this = this as ProxiesTabControllerState;
  return 'ProxiesTabControllerState(groupNames: ${_this.groupNames}, currentGroupName: ${_this.currentGroupName})';
}


}

/// @nodoc
abstract mixin class $ProxiesTabControllerStateCopyWith<$Res>  {
  factory $ProxiesTabControllerStateCopyWith(ProxiesTabControllerState value, $Res Function(ProxiesTabControllerState) _then) = _$ProxiesTabControllerStateCopyWithImpl;
@useResult
$Res call({
 List<String> groupNames, String? currentGroupName
});




}
/// @nodoc
class _$ProxiesTabControllerStateCopyWithImpl<$Res>
    implements $ProxiesTabControllerStateCopyWith<$Res> {
  _$ProxiesTabControllerStateCopyWithImpl(this._self, this._then);

  final ProxiesTabControllerState _self;
  final $Res Function(ProxiesTabControllerState) _then;

/// Create a copy of ProxiesTabControllerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupNames = null,Object? currentGroupName = freezed,}) {
  return _then(ProxiesTabControllerState(
groupNames: null == groupNames ? _self.groupNames : groupNames // ignore: cast_nullable_to_non_nullable
as List<String>,currentGroupName: freezed == currentGroupName ? _self.currentGroupName : currentGroupName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProxiesTabControllerState].
extension ProxiesTabControllerStatePatterns on ProxiesTabControllerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProxiesTabControllerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProxiesTabControllerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProxiesTabControllerState value)  $default,){
final _that = this;
switch (_that) {
case _ProxiesTabControllerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProxiesTabControllerState value)?  $default,){
final _that = this;
switch (_that) {
case _ProxiesTabControllerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> groupNames,  String? currentGroupName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProxiesTabControllerState() when $default != null:
return $default(_that.groupNames,_that.currentGroupName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> groupNames,  String? currentGroupName)  $default,) {final _that = this;
switch (_that) {
case _ProxiesTabControllerState():
return $default(_that.groupNames,_that.currentGroupName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> groupNames,  String? currentGroupName)?  $default,) {final _that = this;
switch (_that) {
case _ProxiesTabControllerState() when $default != null:
return $default(_that.groupNames,_that.currentGroupName);case _:
  return null;

}
}

}

/// @nodoc


class _ProxiesTabControllerState implements ProxiesTabControllerState {
  const _ProxiesTabControllerState({required  List<String> groupNames, required this.currentGroupName}): _groupNames = groupNames;
  

 final  List<String> _groupNames;
@override List<String> get groupNames {
  if (_groupNames is EqualUnmodifiableListView) return _groupNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groupNames);
}

@override final  String? currentGroupName;

/// Create a copy of ProxiesTabControllerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProxiesTabControllerStateCopyWith<_ProxiesTabControllerState> get copyWith => __$ProxiesTabControllerStateCopyWithImpl<_ProxiesTabControllerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProxiesTabControllerState&&const DeepCollectionEquality().equals(other.groupNames, _groupNames)&&(identical(other.currentGroupName, currentGroupName) || other.currentGroupName == currentGroupName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_groupNames),currentGroupName);
}

@override
String toString() {
    return 'ProxiesTabControllerState(groupNames: $groupNames, currentGroupName: $currentGroupName)';
}


}

/// @nodoc
abstract mixin class _$ProxiesTabControllerStateCopyWith<$Res> implements $ProxiesTabControllerStateCopyWith<$Res> {
  factory _$ProxiesTabControllerStateCopyWith(_ProxiesTabControllerState value, $Res Function(_ProxiesTabControllerState) _then) = __$ProxiesTabControllerStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> groupNames, String? currentGroupName
});




}
/// @nodoc
class __$ProxiesTabControllerStateCopyWithImpl<$Res>
    implements _$ProxiesTabControllerStateCopyWith<$Res> {
  __$ProxiesTabControllerStateCopyWithImpl(this._self, this._then);

  final _ProxiesTabControllerState _self;
  final $Res Function(_ProxiesTabControllerState) _then;

/// Create a copy of ProxiesTabControllerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupNames = null,Object? currentGroupName = freezed,}) {
  return _then(_ProxiesTabControllerState(
groupNames: null == groupNames ? _self._groupNames : groupNames // ignore: cast_nullable_to_non_nullable
as List<String>,currentGroupName: freezed == currentGroupName ? _self.currentGroupName : currentGroupName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
