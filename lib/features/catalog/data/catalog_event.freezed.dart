// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CatalogEvent {

@JsonKey(fromJson: _idFromJson) String? get id;@JsonKey(name: 'nama_event') String get name;/// Alamat venue — disebut `alamat` oleh backend.
@JsonKey(name: 'alamat') String get venue; String? get genre;@JsonKey(name: 'poster_url') String? get posterUrl;@JsonKey(name: 'tanggal_mulai', fromJson: _dateFromJson) DateTime? get startsAt;@JsonKey(name: 'min_price', fromJson: _numFromJson) num get minPrice;@JsonKey(name: 'is_sold_out') bool get soldOut;
/// Create a copy of CatalogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogEventCopyWith<CatalogEvent> get copyWith => _$CatalogEventCopyWithImpl<CatalogEvent>(this as CatalogEvent, _$identity);

  /// Serializes this CatalogEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.venue, _this.venue) || other.venue == _this.venue)&&(identical(other.genre, _this.genre) || other.genre == _this.genre)&&(identical(other.posterUrl, _this.posterUrl) || other.posterUrl == _this.posterUrl)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.minPrice, _this.minPrice) || other.minPrice == _this.minPrice)&&(identical(other.soldOut, _this.soldOut) || other.soldOut == _this.soldOut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogEvent;
  return Object.hash(runtimeType,_this.id,_this.name,_this.venue,_this.genre,_this.posterUrl,_this.startsAt,_this.minPrice,_this.soldOut);
}

@override
String toString() {
  final _this = this as CatalogEvent;
  return 'CatalogEvent(id: ${_this.id}, name: ${_this.name}, venue: ${_this.venue}, genre: ${_this.genre}, posterUrl: ${_this.posterUrl}, startsAt: ${_this.startsAt}, minPrice: ${_this.minPrice}, soldOut: ${_this.soldOut})';
}


}

/// @nodoc
abstract mixin class $CatalogEventCopyWith<$Res>  {
  factory $CatalogEventCopyWith(CatalogEvent value, $Res Function(CatalogEvent) _then) = _$CatalogEventCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String? id,@JsonKey(name: 'nama_event') String name,@JsonKey(name: 'alamat') String venue, String? genre,@JsonKey(name: 'poster_url') String? posterUrl,@JsonKey(name: 'tanggal_mulai', fromJson: _dateFromJson) DateTime? startsAt,@JsonKey(name: 'min_price', fromJson: _numFromJson) num minPrice,@JsonKey(name: 'is_sold_out') bool soldOut
});




}
/// @nodoc
class _$CatalogEventCopyWithImpl<$Res>
    implements $CatalogEventCopyWith<$Res> {
  _$CatalogEventCopyWithImpl(this._self, this._then);

  final CatalogEvent _self;
  final $Res Function(CatalogEvent) _then;

/// Create a copy of CatalogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? venue = null,Object? genre = freezed,Object? posterUrl = freezed,Object? startsAt = freezed,Object? minPrice = null,Object? soldOut = null,}) {
  return _then(CatalogEvent(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,minPrice: null == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as num,soldOut: null == soldOut ? _self.soldOut : soldOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogEvent].
extension CatalogEventPatterns on CatalogEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogEvent value)  $default,){
final _that = this;
switch (_that) {
case _CatalogEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogEvent value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String? id, @JsonKey(name: 'nama_event')  String name, @JsonKey(name: 'alamat')  String venue,  String? genre, @JsonKey(name: 'poster_url')  String? posterUrl, @JsonKey(name: 'tanggal_mulai', fromJson: _dateFromJson)  DateTime? startsAt, @JsonKey(name: 'min_price', fromJson: _numFromJson)  num minPrice, @JsonKey(name: 'is_sold_out')  bool soldOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogEvent() when $default != null:
return $default(_that.id,_that.name,_that.venue,_that.genre,_that.posterUrl,_that.startsAt,_that.minPrice,_that.soldOut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idFromJson)  String? id, @JsonKey(name: 'nama_event')  String name, @JsonKey(name: 'alamat')  String venue,  String? genre, @JsonKey(name: 'poster_url')  String? posterUrl, @JsonKey(name: 'tanggal_mulai', fromJson: _dateFromJson)  DateTime? startsAt, @JsonKey(name: 'min_price', fromJson: _numFromJson)  num minPrice, @JsonKey(name: 'is_sold_out')  bool soldOut)  $default,) {final _that = this;
switch (_that) {
case _CatalogEvent():
return $default(_that.id,_that.name,_that.venue,_that.genre,_that.posterUrl,_that.startsAt,_that.minPrice,_that.soldOut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idFromJson)  String? id, @JsonKey(name: 'nama_event')  String name, @JsonKey(name: 'alamat')  String venue,  String? genre, @JsonKey(name: 'poster_url')  String? posterUrl, @JsonKey(name: 'tanggal_mulai', fromJson: _dateFromJson)  DateTime? startsAt, @JsonKey(name: 'min_price', fromJson: _numFromJson)  num minPrice, @JsonKey(name: 'is_sold_out')  bool soldOut)?  $default,) {final _that = this;
switch (_that) {
case _CatalogEvent() when $default != null:
return $default(_that.id,_that.name,_that.venue,_that.genre,_that.posterUrl,_that.startsAt,_that.minPrice,_that.soldOut);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogEvent implements CatalogEvent {
  const _CatalogEvent({@JsonKey(fromJson: _idFromJson) this.id, @JsonKey(name: 'nama_event') required this.name, @JsonKey(name: 'alamat') this.venue = '', this.genre, @JsonKey(name: 'poster_url') this.posterUrl, @JsonKey(name: 'tanggal_mulai', fromJson: _dateFromJson) this.startsAt, @JsonKey(name: 'min_price', fromJson: _numFromJson) this.minPrice = 0, @JsonKey(name: 'is_sold_out') this.soldOut = false});
  factory _CatalogEvent.fromJson(Map<String, dynamic> json) => _$CatalogEventFromJson(json);

@override@JsonKey(fromJson: _idFromJson) final  String? id;
@override@JsonKey(name: 'nama_event') final  String name;
/// Alamat venue — disebut `alamat` oleh backend.
@override@JsonKey(name: 'alamat') final  String venue;
@override final  String? genre;
@override@JsonKey(name: 'poster_url') final  String? posterUrl;
@override@JsonKey(name: 'tanggal_mulai', fromJson: _dateFromJson) final  DateTime? startsAt;
@override@JsonKey(name: 'min_price', fromJson: _numFromJson) final  num minPrice;
@override@JsonKey(name: 'is_sold_out') final  bool soldOut;

/// Create a copy of CatalogEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogEventCopyWith<_CatalogEvent> get copyWith => __$CatalogEventCopyWithImpl<_CatalogEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.soldOut, soldOut) || other.soldOut == soldOut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,venue,genre,posterUrl,startsAt,minPrice,soldOut);
}

@override
String toString() {
    return 'CatalogEvent(id: $id, name: $name, venue: $venue, genre: $genre, posterUrl: $posterUrl, startsAt: $startsAt, minPrice: $minPrice, soldOut: $soldOut)';
}


}

/// @nodoc
abstract mixin class _$CatalogEventCopyWith<$Res> implements $CatalogEventCopyWith<$Res> {
  factory _$CatalogEventCopyWith(_CatalogEvent value, $Res Function(_CatalogEvent) _then) = __$CatalogEventCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idFromJson) String? id,@JsonKey(name: 'nama_event') String name,@JsonKey(name: 'alamat') String venue, String? genre,@JsonKey(name: 'poster_url') String? posterUrl,@JsonKey(name: 'tanggal_mulai', fromJson: _dateFromJson) DateTime? startsAt,@JsonKey(name: 'min_price', fromJson: _numFromJson) num minPrice,@JsonKey(name: 'is_sold_out') bool soldOut
});




}
/// @nodoc
class __$CatalogEventCopyWithImpl<$Res>
    implements _$CatalogEventCopyWith<$Res> {
  __$CatalogEventCopyWithImpl(this._self, this._then);

  final _CatalogEvent _self;
  final $Res Function(_CatalogEvent) _then;

/// Create a copy of CatalogEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? venue = null,Object? genre = freezed,Object? posterUrl = freezed,Object? startsAt = freezed,Object? minPrice = null,Object? soldOut = null,}) {
  return _then(_CatalogEvent(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,minPrice: null == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as num,soldOut: null == soldOut ? _self.soldOut : soldOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CatalogStats {

@JsonKey(name: 'active_events_count', fromJson: _intFromJson) int get activeEvents;@JsonKey(name: 'tickets_sold_count', fromJson: _intFromJson) int get ticketsSold;@JsonKey(name: 'verified_organizers_count', fromJson: _intFromJson) int get verifiedOrganizers;@JsonKey(name: 'cities_count', fromJson: _intFromJson) int get cities;
/// Create a copy of CatalogStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogStatsCopyWith<CatalogStats> get copyWith => _$CatalogStatsCopyWithImpl<CatalogStats>(this as CatalogStats, _$identity);

  /// Serializes this CatalogStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CatalogStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogStats&&(identical(other.activeEvents, _this.activeEvents) || other.activeEvents == _this.activeEvents)&&(identical(other.ticketsSold, _this.ticketsSold) || other.ticketsSold == _this.ticketsSold)&&(identical(other.verifiedOrganizers, _this.verifiedOrganizers) || other.verifiedOrganizers == _this.verifiedOrganizers)&&(identical(other.cities, _this.cities) || other.cities == _this.cities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogStats;
  return Object.hash(runtimeType,_this.activeEvents,_this.ticketsSold,_this.verifiedOrganizers,_this.cities);
}

@override
String toString() {
  final _this = this as CatalogStats;
  return 'CatalogStats(activeEvents: ${_this.activeEvents}, ticketsSold: ${_this.ticketsSold}, verifiedOrganizers: ${_this.verifiedOrganizers}, cities: ${_this.cities})';
}


}

/// @nodoc
abstract mixin class $CatalogStatsCopyWith<$Res>  {
  factory $CatalogStatsCopyWith(CatalogStats value, $Res Function(CatalogStats) _then) = _$CatalogStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'active_events_count', fromJson: _intFromJson) int activeEvents,@JsonKey(name: 'tickets_sold_count', fromJson: _intFromJson) int ticketsSold,@JsonKey(name: 'verified_organizers_count', fromJson: _intFromJson) int verifiedOrganizers,@JsonKey(name: 'cities_count', fromJson: _intFromJson) int cities
});




}
/// @nodoc
class _$CatalogStatsCopyWithImpl<$Res>
    implements $CatalogStatsCopyWith<$Res> {
  _$CatalogStatsCopyWithImpl(this._self, this._then);

  final CatalogStats _self;
  final $Res Function(CatalogStats) _then;

/// Create a copy of CatalogStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeEvents = null,Object? ticketsSold = null,Object? verifiedOrganizers = null,Object? cities = null,}) {
  return _then(CatalogStats(
activeEvents: null == activeEvents ? _self.activeEvents : activeEvents // ignore: cast_nullable_to_non_nullable
as int,ticketsSold: null == ticketsSold ? _self.ticketsSold : ticketsSold // ignore: cast_nullable_to_non_nullable
as int,verifiedOrganizers: null == verifiedOrganizers ? _self.verifiedOrganizers : verifiedOrganizers // ignore: cast_nullable_to_non_nullable
as int,cities: null == cities ? _self.cities : cities // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogStats].
extension CatalogStatsPatterns on CatalogStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogStats value)  $default,){
final _that = this;
switch (_that) {
case _CatalogStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogStats value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'active_events_count', fromJson: _intFromJson)  int activeEvents, @JsonKey(name: 'tickets_sold_count', fromJson: _intFromJson)  int ticketsSold, @JsonKey(name: 'verified_organizers_count', fromJson: _intFromJson)  int verifiedOrganizers, @JsonKey(name: 'cities_count', fromJson: _intFromJson)  int cities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogStats() when $default != null:
return $default(_that.activeEvents,_that.ticketsSold,_that.verifiedOrganizers,_that.cities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'active_events_count', fromJson: _intFromJson)  int activeEvents, @JsonKey(name: 'tickets_sold_count', fromJson: _intFromJson)  int ticketsSold, @JsonKey(name: 'verified_organizers_count', fromJson: _intFromJson)  int verifiedOrganizers, @JsonKey(name: 'cities_count', fromJson: _intFromJson)  int cities)  $default,) {final _that = this;
switch (_that) {
case _CatalogStats():
return $default(_that.activeEvents,_that.ticketsSold,_that.verifiedOrganizers,_that.cities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'active_events_count', fromJson: _intFromJson)  int activeEvents, @JsonKey(name: 'tickets_sold_count', fromJson: _intFromJson)  int ticketsSold, @JsonKey(name: 'verified_organizers_count', fromJson: _intFromJson)  int verifiedOrganizers, @JsonKey(name: 'cities_count', fromJson: _intFromJson)  int cities)?  $default,) {final _that = this;
switch (_that) {
case _CatalogStats() when $default != null:
return $default(_that.activeEvents,_that.ticketsSold,_that.verifiedOrganizers,_that.cities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogStats implements CatalogStats {
  const _CatalogStats({@JsonKey(name: 'active_events_count', fromJson: _intFromJson) this.activeEvents = 0, @JsonKey(name: 'tickets_sold_count', fromJson: _intFromJson) this.ticketsSold = 0, @JsonKey(name: 'verified_organizers_count', fromJson: _intFromJson) this.verifiedOrganizers = 0, @JsonKey(name: 'cities_count', fromJson: _intFromJson) this.cities = 0});
  factory _CatalogStats.fromJson(Map<String, dynamic> json) => _$CatalogStatsFromJson(json);

@override@JsonKey(name: 'active_events_count', fromJson: _intFromJson) final  int activeEvents;
@override@JsonKey(name: 'tickets_sold_count', fromJson: _intFromJson) final  int ticketsSold;
@override@JsonKey(name: 'verified_organizers_count', fromJson: _intFromJson) final  int verifiedOrganizers;
@override@JsonKey(name: 'cities_count', fromJson: _intFromJson) final  int cities;

/// Create a copy of CatalogStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogStatsCopyWith<_CatalogStats> get copyWith => __$CatalogStatsCopyWithImpl<_CatalogStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogStats&&(identical(other.activeEvents, activeEvents) || other.activeEvents == activeEvents)&&(identical(other.ticketsSold, ticketsSold) || other.ticketsSold == ticketsSold)&&(identical(other.verifiedOrganizers, verifiedOrganizers) || other.verifiedOrganizers == verifiedOrganizers)&&(identical(other.cities, cities) || other.cities == cities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,activeEvents,ticketsSold,verifiedOrganizers,cities);
}

@override
String toString() {
    return 'CatalogStats(activeEvents: $activeEvents, ticketsSold: $ticketsSold, verifiedOrganizers: $verifiedOrganizers, cities: $cities)';
}


}

/// @nodoc
abstract mixin class _$CatalogStatsCopyWith<$Res> implements $CatalogStatsCopyWith<$Res> {
  factory _$CatalogStatsCopyWith(_CatalogStats value, $Res Function(_CatalogStats) _then) = __$CatalogStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'active_events_count', fromJson: _intFromJson) int activeEvents,@JsonKey(name: 'tickets_sold_count', fromJson: _intFromJson) int ticketsSold,@JsonKey(name: 'verified_organizers_count', fromJson: _intFromJson) int verifiedOrganizers,@JsonKey(name: 'cities_count', fromJson: _intFromJson) int cities
});




}
/// @nodoc
class __$CatalogStatsCopyWithImpl<$Res>
    implements _$CatalogStatsCopyWith<$Res> {
  __$CatalogStatsCopyWithImpl(this._self, this._then);

  final _CatalogStats _self;
  final $Res Function(_CatalogStats) _then;

/// Create a copy of CatalogStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeEvents = null,Object? ticketsSold = null,Object? verifiedOrganizers = null,Object? cities = null,}) {
  return _then(_CatalogStats(
activeEvents: null == activeEvents ? _self.activeEvents : activeEvents // ignore: cast_nullable_to_non_nullable
as int,ticketsSold: null == ticketsSold ? _self.ticketsSold : ticketsSold // ignore: cast_nullable_to_non_nullable
as int,verifiedOrganizers: null == verifiedOrganizers ? _self.verifiedOrganizers : verifiedOrganizers // ignore: cast_nullable_to_non_nullable
as int,cities: null == cities ? _self.cities : cities // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
