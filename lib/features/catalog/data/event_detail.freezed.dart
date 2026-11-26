// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventDetail {

@JsonKey(fromJson: idFromJson) String? get id;@JsonKey(name: 'nama_event') String get name;@JsonKey(name: 'deskripsi') String get description;@JsonKey(name: 'artis') String get artist;/// Alamat venue — backend menyebutnya `alamat`.
@JsonKey(name: 'alamat') String get venue;@JsonKey(name: 'kota') String? get city; String? get genre;@JsonKey(name: 'poster_url') String? get posterUrl;@JsonKey(name: 'tanggal_mulai', fromJson: dateFromJson) DateTime? get startsAt;@JsonKey(name: 'tanggal_selesai', fromJson: dateFromJson) DateTime? get endsAt;@JsonKey(name: 'kapasitas_venue', fromJson: intFromJson) int get capacity;@JsonKey(name: 'organizer_id', fromJson: idFromJson) String? get organizerId;@JsonKey(name: 'organization_name') String? get organizationName;@JsonKey(name: 'total_quota', fromJson: intFromJson) int get totalQuota;@JsonKey(name: 'sold_quota', fromJson: intFromJson) int get soldQuota;@JsonKey(name: 'available_quota', fromJson: intFromJson) int get availableQuota;@JsonKey(name: 'is_sold_out') bool get soldOut;@JsonKey(name: 'occupancy_percent', fromJson: intFromJson) int get occupancyPercent;@JsonKey(name: 'is_bookmarked') bool get bookmarked; List<TicketCategory> get categories;
/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDetailCopyWith<EventDetail> get copyWith => _$EventDetailCopyWithImpl<EventDetail>(this as EventDetail, _$identity);

  /// Serializes this EventDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EventDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.artist, _this.artist) || other.artist == _this.artist)&&(identical(other.venue, _this.venue) || other.venue == _this.venue)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.genre, _this.genre) || other.genre == _this.genre)&&(identical(other.posterUrl, _this.posterUrl) || other.posterUrl == _this.posterUrl)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.organizerId, _this.organizerId) || other.organizerId == _this.organizerId)&&(identical(other.organizationName, _this.organizationName) || other.organizationName == _this.organizationName)&&(identical(other.totalQuota, _this.totalQuota) || other.totalQuota == _this.totalQuota)&&(identical(other.soldQuota, _this.soldQuota) || other.soldQuota == _this.soldQuota)&&(identical(other.availableQuota, _this.availableQuota) || other.availableQuota == _this.availableQuota)&&(identical(other.soldOut, _this.soldOut) || other.soldOut == _this.soldOut)&&(identical(other.occupancyPercent, _this.occupancyPercent) || other.occupancyPercent == _this.occupancyPercent)&&(identical(other.bookmarked, _this.bookmarked) || other.bookmarked == _this.bookmarked)&&const DeepCollectionEquality().equals(other.categories, _this.categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EventDetail;
  return Object.hashAll([runtimeType,_this.id,_this.name,_this.description,_this.artist,_this.venue,_this.city,_this.genre,_this.posterUrl,_this.startsAt,_this.endsAt,_this.capacity,_this.organizerId,_this.organizationName,_this.totalQuota,_this.soldQuota,_this.availableQuota,_this.soldOut,_this.occupancyPercent,_this.bookmarked,const DeepCollectionEquality().hash(_this.categories)]);
}

@override
String toString() {
  final _this = this as EventDetail;
  return 'EventDetail(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, artist: ${_this.artist}, venue: ${_this.venue}, city: ${_this.city}, genre: ${_this.genre}, posterUrl: ${_this.posterUrl}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, capacity: ${_this.capacity}, organizerId: ${_this.organizerId}, organizationName: ${_this.organizationName}, totalQuota: ${_this.totalQuota}, soldQuota: ${_this.soldQuota}, availableQuota: ${_this.availableQuota}, soldOut: ${_this.soldOut}, occupancyPercent: ${_this.occupancyPercent}, bookmarked: ${_this.bookmarked}, categories: ${_this.categories})';
}


}

/// @nodoc
abstract mixin class $EventDetailCopyWith<$Res>  {
  factory $EventDetailCopyWith(EventDetail value, $Res Function(EventDetail) _then) = _$EventDetailCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String? id,@JsonKey(name: 'nama_event') String name,@JsonKey(name: 'deskripsi') String description,@JsonKey(name: 'artis') String artist,@JsonKey(name: 'alamat') String venue,@JsonKey(name: 'kota') String? city, String? genre,@JsonKey(name: 'poster_url') String? posterUrl,@JsonKey(name: 'tanggal_mulai', fromJson: dateFromJson) DateTime? startsAt,@JsonKey(name: 'tanggal_selesai', fromJson: dateFromJson) DateTime? endsAt,@JsonKey(name: 'kapasitas_venue', fromJson: intFromJson) int capacity,@JsonKey(name: 'organizer_id', fromJson: idFromJson) String? organizerId,@JsonKey(name: 'organization_name') String? organizationName,@JsonKey(name: 'total_quota', fromJson: intFromJson) int totalQuota,@JsonKey(name: 'sold_quota', fromJson: intFromJson) int soldQuota,@JsonKey(name: 'available_quota', fromJson: intFromJson) int availableQuota,@JsonKey(name: 'is_sold_out') bool soldOut,@JsonKey(name: 'occupancy_percent', fromJson: intFromJson) int occupancyPercent,@JsonKey(name: 'is_bookmarked') bool bookmarked, List<TicketCategory> categories
});




}
/// @nodoc
class _$EventDetailCopyWithImpl<$Res>
    implements $EventDetailCopyWith<$Res> {
  _$EventDetailCopyWithImpl(this._self, this._then);

  final EventDetail _self;
  final $Res Function(EventDetail) _then;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? description = null,Object? artist = null,Object? venue = null,Object? city = freezed,Object? genre = freezed,Object? posterUrl = freezed,Object? startsAt = freezed,Object? endsAt = freezed,Object? capacity = null,Object? organizerId = freezed,Object? organizationName = freezed,Object? totalQuota = null,Object? soldQuota = null,Object? availableQuota = null,Object? soldOut = null,Object? occupancyPercent = null,Object? bookmarked = null,Object? categories = null,}) {
  return _then(EventDetail(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,organizerId: freezed == organizerId ? _self.organizerId : organizerId // ignore: cast_nullable_to_non_nullable
as String?,organizationName: freezed == organizationName ? _self.organizationName : organizationName // ignore: cast_nullable_to_non_nullable
as String?,totalQuota: null == totalQuota ? _self.totalQuota : totalQuota // ignore: cast_nullable_to_non_nullable
as int,soldQuota: null == soldQuota ? _self.soldQuota : soldQuota // ignore: cast_nullable_to_non_nullable
as int,availableQuota: null == availableQuota ? _self.availableQuota : availableQuota // ignore: cast_nullable_to_non_nullable
as int,soldOut: null == soldOut ? _self.soldOut : soldOut // ignore: cast_nullable_to_non_nullable
as bool,occupancyPercent: null == occupancyPercent ? _self.occupancyPercent : occupancyPercent // ignore: cast_nullable_to_non_nullable
as int,bookmarked: null == bookmarked ? _self.bookmarked : bookmarked // ignore: cast_nullable_to_non_nullable
as bool,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<TicketCategory>,
  ));
}

}


/// Adds pattern-matching-related methods to [EventDetail].
extension EventDetailPatterns on EventDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventDetail value)  $default,){
final _that = this;
switch (_that) {
case _EventDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventDetail value)?  $default,){
final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String? id, @JsonKey(name: 'nama_event')  String name, @JsonKey(name: 'deskripsi')  String description, @JsonKey(name: 'artis')  String artist, @JsonKey(name: 'alamat')  String venue, @JsonKey(name: 'kota')  String? city,  String? genre, @JsonKey(name: 'poster_url')  String? posterUrl, @JsonKey(name: 'tanggal_mulai', fromJson: dateFromJson)  DateTime? startsAt, @JsonKey(name: 'tanggal_selesai', fromJson: dateFromJson)  DateTime? endsAt, @JsonKey(name: 'kapasitas_venue', fromJson: intFromJson)  int capacity, @JsonKey(name: 'organizer_id', fromJson: idFromJson)  String? organizerId, @JsonKey(name: 'organization_name')  String? organizationName, @JsonKey(name: 'total_quota', fromJson: intFromJson)  int totalQuota, @JsonKey(name: 'sold_quota', fromJson: intFromJson)  int soldQuota, @JsonKey(name: 'available_quota', fromJson: intFromJson)  int availableQuota, @JsonKey(name: 'is_sold_out')  bool soldOut, @JsonKey(name: 'occupancy_percent', fromJson: intFromJson)  int occupancyPercent, @JsonKey(name: 'is_bookmarked')  bool bookmarked,  List<TicketCategory> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.artist,_that.venue,_that.city,_that.genre,_that.posterUrl,_that.startsAt,_that.endsAt,_that.capacity,_that.organizerId,_that.organizationName,_that.totalQuota,_that.soldQuota,_that.availableQuota,_that.soldOut,_that.occupancyPercent,_that.bookmarked,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String? id, @JsonKey(name: 'nama_event')  String name, @JsonKey(name: 'deskripsi')  String description, @JsonKey(name: 'artis')  String artist, @JsonKey(name: 'alamat')  String venue, @JsonKey(name: 'kota')  String? city,  String? genre, @JsonKey(name: 'poster_url')  String? posterUrl, @JsonKey(name: 'tanggal_mulai', fromJson: dateFromJson)  DateTime? startsAt, @JsonKey(name: 'tanggal_selesai', fromJson: dateFromJson)  DateTime? endsAt, @JsonKey(name: 'kapasitas_venue', fromJson: intFromJson)  int capacity, @JsonKey(name: 'organizer_id', fromJson: idFromJson)  String? organizerId, @JsonKey(name: 'organization_name')  String? organizationName, @JsonKey(name: 'total_quota', fromJson: intFromJson)  int totalQuota, @JsonKey(name: 'sold_quota', fromJson: intFromJson)  int soldQuota, @JsonKey(name: 'available_quota', fromJson: intFromJson)  int availableQuota, @JsonKey(name: 'is_sold_out')  bool soldOut, @JsonKey(name: 'occupancy_percent', fromJson: intFromJson)  int occupancyPercent, @JsonKey(name: 'is_bookmarked')  bool bookmarked,  List<TicketCategory> categories)  $default,) {final _that = this;
switch (_that) {
case _EventDetail():
return $default(_that.id,_that.name,_that.description,_that.artist,_that.venue,_that.city,_that.genre,_that.posterUrl,_that.startsAt,_that.endsAt,_that.capacity,_that.organizerId,_that.organizationName,_that.totalQuota,_that.soldQuota,_that.availableQuota,_that.soldOut,_that.occupancyPercent,_that.bookmarked,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String? id, @JsonKey(name: 'nama_event')  String name, @JsonKey(name: 'deskripsi')  String description, @JsonKey(name: 'artis')  String artist, @JsonKey(name: 'alamat')  String venue, @JsonKey(name: 'kota')  String? city,  String? genre, @JsonKey(name: 'poster_url')  String? posterUrl, @JsonKey(name: 'tanggal_mulai', fromJson: dateFromJson)  DateTime? startsAt, @JsonKey(name: 'tanggal_selesai', fromJson: dateFromJson)  DateTime? endsAt, @JsonKey(name: 'kapasitas_venue', fromJson: intFromJson)  int capacity, @JsonKey(name: 'organizer_id', fromJson: idFromJson)  String? organizerId, @JsonKey(name: 'organization_name')  String? organizationName, @JsonKey(name: 'total_quota', fromJson: intFromJson)  int totalQuota, @JsonKey(name: 'sold_quota', fromJson: intFromJson)  int soldQuota, @JsonKey(name: 'available_quota', fromJson: intFromJson)  int availableQuota, @JsonKey(name: 'is_sold_out')  bool soldOut, @JsonKey(name: 'occupancy_percent', fromJson: intFromJson)  int occupancyPercent, @JsonKey(name: 'is_bookmarked')  bool bookmarked,  List<TicketCategory> categories)?  $default,) {final _that = this;
switch (_that) {
case _EventDetail() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.artist,_that.venue,_that.city,_that.genre,_that.posterUrl,_that.startsAt,_that.endsAt,_that.capacity,_that.organizerId,_that.organizationName,_that.totalQuota,_that.soldQuota,_that.availableQuota,_that.soldOut,_that.occupancyPercent,_that.bookmarked,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventDetail implements EventDetail {
  const _EventDetail({@JsonKey(fromJson: idFromJson) this.id, @JsonKey(name: 'nama_event') this.name = '', @JsonKey(name: 'deskripsi') this.description = '', @JsonKey(name: 'artis') this.artist = '', @JsonKey(name: 'alamat') this.venue = '', @JsonKey(name: 'kota') this.city, this.genre, @JsonKey(name: 'poster_url') this.posterUrl, @JsonKey(name: 'tanggal_mulai', fromJson: dateFromJson) this.startsAt, @JsonKey(name: 'tanggal_selesai', fromJson: dateFromJson) this.endsAt, @JsonKey(name: 'kapasitas_venue', fromJson: intFromJson) this.capacity = 0, @JsonKey(name: 'organizer_id', fromJson: idFromJson) this.organizerId, @JsonKey(name: 'organization_name') this.organizationName, @JsonKey(name: 'total_quota', fromJson: intFromJson) this.totalQuota = 0, @JsonKey(name: 'sold_quota', fromJson: intFromJson) this.soldQuota = 0, @JsonKey(name: 'available_quota', fromJson: intFromJson) this.availableQuota = 0, @JsonKey(name: 'is_sold_out') this.soldOut = false, @JsonKey(name: 'occupancy_percent', fromJson: intFromJson) this.occupancyPercent = 0, @JsonKey(name: 'is_bookmarked') this.bookmarked = false,  List<TicketCategory> categories = const <TicketCategory>[]}): _categories = categories;
  factory _EventDetail.fromJson(Map<String, dynamic> json) => _$EventDetailFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String? id;
@override@JsonKey(name: 'nama_event') final  String name;
@override@JsonKey(name: 'deskripsi') final  String description;
@override@JsonKey(name: 'artis') final  String artist;
/// Alamat venue — backend menyebutnya `alamat`.
@override@JsonKey(name: 'alamat') final  String venue;
@override@JsonKey(name: 'kota') final  String? city;
@override final  String? genre;
@override@JsonKey(name: 'poster_url') final  String? posterUrl;
@override@JsonKey(name: 'tanggal_mulai', fromJson: dateFromJson) final  DateTime? startsAt;
@override@JsonKey(name: 'tanggal_selesai', fromJson: dateFromJson) final  DateTime? endsAt;
@override@JsonKey(name: 'kapasitas_venue', fromJson: intFromJson) final  int capacity;
@override@JsonKey(name: 'organizer_id', fromJson: idFromJson) final  String? organizerId;
@override@JsonKey(name: 'organization_name') final  String? organizationName;
@override@JsonKey(name: 'total_quota', fromJson: intFromJson) final  int totalQuota;
@override@JsonKey(name: 'sold_quota', fromJson: intFromJson) final  int soldQuota;
@override@JsonKey(name: 'available_quota', fromJson: intFromJson) final  int availableQuota;
@override@JsonKey(name: 'is_sold_out') final  bool soldOut;
@override@JsonKey(name: 'occupancy_percent', fromJson: intFromJson) final  int occupancyPercent;
@override@JsonKey(name: 'is_bookmarked') final  bool bookmarked;
 final  List<TicketCategory> _categories;
@override@JsonKey() List<TicketCategory> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDetailCopyWith<_EventDetail> get copyWith => __$EventDetailCopyWithImpl<_EventDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.venue, venue) || other.venue == venue)&&(identical(other.city, city) || other.city == city)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.organizerId, organizerId) || other.organizerId == organizerId)&&(identical(other.organizationName, organizationName) || other.organizationName == organizationName)&&(identical(other.totalQuota, totalQuota) || other.totalQuota == totalQuota)&&(identical(other.soldQuota, soldQuota) || other.soldQuota == soldQuota)&&(identical(other.availableQuota, availableQuota) || other.availableQuota == availableQuota)&&(identical(other.soldOut, soldOut) || other.soldOut == soldOut)&&(identical(other.occupancyPercent, occupancyPercent) || other.occupancyPercent == occupancyPercent)&&(identical(other.bookmarked, bookmarked) || other.bookmarked == bookmarked)&&const DeepCollectionEquality().equals(other.categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,name,description,artist,venue,city,genre,posterUrl,startsAt,endsAt,capacity,organizerId,organizationName,totalQuota,soldQuota,availableQuota,soldOut,occupancyPercent,bookmarked,const DeepCollectionEquality().hash(_categories)]);
}

@override
String toString() {
    return 'EventDetail(id: $id, name: $name, description: $description, artist: $artist, venue: $venue, city: $city, genre: $genre, posterUrl: $posterUrl, startsAt: $startsAt, endsAt: $endsAt, capacity: $capacity, organizerId: $organizerId, organizationName: $organizationName, totalQuota: $totalQuota, soldQuota: $soldQuota, availableQuota: $availableQuota, soldOut: $soldOut, occupancyPercent: $occupancyPercent, bookmarked: $bookmarked, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$EventDetailCopyWith<$Res> implements $EventDetailCopyWith<$Res> {
  factory _$EventDetailCopyWith(_EventDetail value, $Res Function(_EventDetail) _then) = __$EventDetailCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String? id,@JsonKey(name: 'nama_event') String name,@JsonKey(name: 'deskripsi') String description,@JsonKey(name: 'artis') String artist,@JsonKey(name: 'alamat') String venue,@JsonKey(name: 'kota') String? city, String? genre,@JsonKey(name: 'poster_url') String? posterUrl,@JsonKey(name: 'tanggal_mulai', fromJson: dateFromJson) DateTime? startsAt,@JsonKey(name: 'tanggal_selesai', fromJson: dateFromJson) DateTime? endsAt,@JsonKey(name: 'kapasitas_venue', fromJson: intFromJson) int capacity,@JsonKey(name: 'organizer_id', fromJson: idFromJson) String? organizerId,@JsonKey(name: 'organization_name') String? organizationName,@JsonKey(name: 'total_quota', fromJson: intFromJson) int totalQuota,@JsonKey(name: 'sold_quota', fromJson: intFromJson) int soldQuota,@JsonKey(name: 'available_quota', fromJson: intFromJson) int availableQuota,@JsonKey(name: 'is_sold_out') bool soldOut,@JsonKey(name: 'occupancy_percent', fromJson: intFromJson) int occupancyPercent,@JsonKey(name: 'is_bookmarked') bool bookmarked, List<TicketCategory> categories
});




}
/// @nodoc
class __$EventDetailCopyWithImpl<$Res>
    implements _$EventDetailCopyWith<$Res> {
  __$EventDetailCopyWithImpl(this._self, this._then);

  final _EventDetail _self;
  final $Res Function(_EventDetail) _then;

/// Create a copy of EventDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? description = null,Object? artist = null,Object? venue = null,Object? city = freezed,Object? genre = freezed,Object? posterUrl = freezed,Object? startsAt = freezed,Object? endsAt = freezed,Object? capacity = null,Object? organizerId = freezed,Object? organizationName = freezed,Object? totalQuota = null,Object? soldQuota = null,Object? availableQuota = null,Object? soldOut = null,Object? occupancyPercent = null,Object? bookmarked = null,Object? categories = null,}) {
  return _then(_EventDetail(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,venue: null == venue ? _self.venue : venue // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,posterUrl: freezed == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,organizerId: freezed == organizerId ? _self.organizerId : organizerId // ignore: cast_nullable_to_non_nullable
as String?,organizationName: freezed == organizationName ? _self.organizationName : organizationName // ignore: cast_nullable_to_non_nullable
as String?,totalQuota: null == totalQuota ? _self.totalQuota : totalQuota // ignore: cast_nullable_to_non_nullable
as int,soldQuota: null == soldQuota ? _self.soldQuota : soldQuota // ignore: cast_nullable_to_non_nullable
as int,availableQuota: null == availableQuota ? _self.availableQuota : availableQuota // ignore: cast_nullable_to_non_nullable
as int,soldOut: null == soldOut ? _self.soldOut : soldOut // ignore: cast_nullable_to_non_nullable
as bool,occupancyPercent: null == occupancyPercent ? _self.occupancyPercent : occupancyPercent // ignore: cast_nullable_to_non_nullable
as int,bookmarked: null == bookmarked ? _self.bookmarked : bookmarked // ignore: cast_nullable_to_non_nullable
as bool,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<TicketCategory>,
  ));
}


}


/// @nodoc
mixin _$TicketCategory {

@JsonKey(fromJson: idFromJson) String? get id;@JsonKey(name: 'nama_kategori') String get name;@JsonKey(name: 'harga', fromJson: numFromJson) num get price;@JsonKey(name: 'kuota_total', fromJson: intFromJson) int get quotaTotal;@JsonKey(name: 'kuota_terjual', fromJson: intFromJson) int get quotaSold;@JsonKey(name: 'kuota_tersedia', fromJson: intFromJson) int get quotaAvailable;@JsonKey(name: 'max_per_transaksi', fromJson: intFromJson) int get maxPerTransaction;
/// Create a copy of TicketCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketCategoryCopyWith<TicketCategory> get copyWith => _$TicketCategoryCopyWithImpl<TicketCategory>(this as TicketCategory, _$identity);

  /// Serializes this TicketCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TicketCategory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketCategory&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.quotaTotal, _this.quotaTotal) || other.quotaTotal == _this.quotaTotal)&&(identical(other.quotaSold, _this.quotaSold) || other.quotaSold == _this.quotaSold)&&(identical(other.quotaAvailable, _this.quotaAvailable) || other.quotaAvailable == _this.quotaAvailable)&&(identical(other.maxPerTransaction, _this.maxPerTransaction) || other.maxPerTransaction == _this.maxPerTransaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TicketCategory;
  return Object.hash(runtimeType,_this.id,_this.name,_this.price,_this.quotaTotal,_this.quotaSold,_this.quotaAvailable,_this.maxPerTransaction);
}

@override
String toString() {
  final _this = this as TicketCategory;
  return 'TicketCategory(id: ${_this.id}, name: ${_this.name}, price: ${_this.price}, quotaTotal: ${_this.quotaTotal}, quotaSold: ${_this.quotaSold}, quotaAvailable: ${_this.quotaAvailable}, maxPerTransaction: ${_this.maxPerTransaction})';
}


}

/// @nodoc
abstract mixin class $TicketCategoryCopyWith<$Res>  {
  factory $TicketCategoryCopyWith(TicketCategory value, $Res Function(TicketCategory) _then) = _$TicketCategoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String? id,@JsonKey(name: 'nama_kategori') String name,@JsonKey(name: 'harga', fromJson: numFromJson) num price,@JsonKey(name: 'kuota_total', fromJson: intFromJson) int quotaTotal,@JsonKey(name: 'kuota_terjual', fromJson: intFromJson) int quotaSold,@JsonKey(name: 'kuota_tersedia', fromJson: intFromJson) int quotaAvailable,@JsonKey(name: 'max_per_transaksi', fromJson: intFromJson) int maxPerTransaction
});




}
/// @nodoc
class _$TicketCategoryCopyWithImpl<$Res>
    implements $TicketCategoryCopyWith<$Res> {
  _$TicketCategoryCopyWithImpl(this._self, this._then);

  final TicketCategory _self;
  final $Res Function(TicketCategory) _then;

/// Create a copy of TicketCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? price = null,Object? quotaTotal = null,Object? quotaSold = null,Object? quotaAvailable = null,Object? maxPerTransaction = null,}) {
  return _then(TicketCategory(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,quotaTotal: null == quotaTotal ? _self.quotaTotal : quotaTotal // ignore: cast_nullable_to_non_nullable
as int,quotaSold: null == quotaSold ? _self.quotaSold : quotaSold // ignore: cast_nullable_to_non_nullable
as int,quotaAvailable: null == quotaAvailable ? _self.quotaAvailable : quotaAvailable // ignore: cast_nullable_to_non_nullable
as int,maxPerTransaction: null == maxPerTransaction ? _self.maxPerTransaction : maxPerTransaction // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketCategory].
extension TicketCategoryPatterns on TicketCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketCategory value)  $default,){
final _that = this;
switch (_that) {
case _TicketCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketCategory value)?  $default,){
final _that = this;
switch (_that) {
case _TicketCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String? id, @JsonKey(name: 'nama_kategori')  String name, @JsonKey(name: 'harga', fromJson: numFromJson)  num price, @JsonKey(name: 'kuota_total', fromJson: intFromJson)  int quotaTotal, @JsonKey(name: 'kuota_terjual', fromJson: intFromJson)  int quotaSold, @JsonKey(name: 'kuota_tersedia', fromJson: intFromJson)  int quotaAvailable, @JsonKey(name: 'max_per_transaksi', fromJson: intFromJson)  int maxPerTransaction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketCategory() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.quotaTotal,_that.quotaSold,_that.quotaAvailable,_that.maxPerTransaction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String? id, @JsonKey(name: 'nama_kategori')  String name, @JsonKey(name: 'harga', fromJson: numFromJson)  num price, @JsonKey(name: 'kuota_total', fromJson: intFromJson)  int quotaTotal, @JsonKey(name: 'kuota_terjual', fromJson: intFromJson)  int quotaSold, @JsonKey(name: 'kuota_tersedia', fromJson: intFromJson)  int quotaAvailable, @JsonKey(name: 'max_per_transaksi', fromJson: intFromJson)  int maxPerTransaction)  $default,) {final _that = this;
switch (_that) {
case _TicketCategory():
return $default(_that.id,_that.name,_that.price,_that.quotaTotal,_that.quotaSold,_that.quotaAvailable,_that.maxPerTransaction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String? id, @JsonKey(name: 'nama_kategori')  String name, @JsonKey(name: 'harga', fromJson: numFromJson)  num price, @JsonKey(name: 'kuota_total', fromJson: intFromJson)  int quotaTotal, @JsonKey(name: 'kuota_terjual', fromJson: intFromJson)  int quotaSold, @JsonKey(name: 'kuota_tersedia', fromJson: intFromJson)  int quotaAvailable, @JsonKey(name: 'max_per_transaksi', fromJson: intFromJson)  int maxPerTransaction)?  $default,) {final _that = this;
switch (_that) {
case _TicketCategory() when $default != null:
return $default(_that.id,_that.name,_that.price,_that.quotaTotal,_that.quotaSold,_that.quotaAvailable,_that.maxPerTransaction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TicketCategory implements TicketCategory {
  const _TicketCategory({@JsonKey(fromJson: idFromJson) this.id, @JsonKey(name: 'nama_kategori') this.name = '', @JsonKey(name: 'harga', fromJson: numFromJson) this.price = 0, @JsonKey(name: 'kuota_total', fromJson: intFromJson) this.quotaTotal = 0, @JsonKey(name: 'kuota_terjual', fromJson: intFromJson) this.quotaSold = 0, @JsonKey(name: 'kuota_tersedia', fromJson: intFromJson) this.quotaAvailable = 0, @JsonKey(name: 'max_per_transaksi', fromJson: intFromJson) this.maxPerTransaction = 0});
  factory _TicketCategory.fromJson(Map<String, dynamic> json) => _$TicketCategoryFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String? id;
@override@JsonKey(name: 'nama_kategori') final  String name;
@override@JsonKey(name: 'harga', fromJson: numFromJson) final  num price;
@override@JsonKey(name: 'kuota_total', fromJson: intFromJson) final  int quotaTotal;
@override@JsonKey(name: 'kuota_terjual', fromJson: intFromJson) final  int quotaSold;
@override@JsonKey(name: 'kuota_tersedia', fromJson: intFromJson) final  int quotaAvailable;
@override@JsonKey(name: 'max_per_transaksi', fromJson: intFromJson) final  int maxPerTransaction;

/// Create a copy of TicketCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketCategoryCopyWith<_TicketCategory> get copyWith => __$TicketCategoryCopyWithImpl<_TicketCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TicketCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.price, price) || other.price == price)&&(identical(other.quotaTotal, quotaTotal) || other.quotaTotal == quotaTotal)&&(identical(other.quotaSold, quotaSold) || other.quotaSold == quotaSold)&&(identical(other.quotaAvailable, quotaAvailable) || other.quotaAvailable == quotaAvailable)&&(identical(other.maxPerTransaction, maxPerTransaction) || other.maxPerTransaction == maxPerTransaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,price,quotaTotal,quotaSold,quotaAvailable,maxPerTransaction);
}

@override
String toString() {
    return 'TicketCategory(id: $id, name: $name, price: $price, quotaTotal: $quotaTotal, quotaSold: $quotaSold, quotaAvailable: $quotaAvailable, maxPerTransaction: $maxPerTransaction)';
}


}

/// @nodoc
abstract mixin class _$TicketCategoryCopyWith<$Res> implements $TicketCategoryCopyWith<$Res> {
  factory _$TicketCategoryCopyWith(_TicketCategory value, $Res Function(_TicketCategory) _then) = __$TicketCategoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String? id,@JsonKey(name: 'nama_kategori') String name,@JsonKey(name: 'harga', fromJson: numFromJson) num price,@JsonKey(name: 'kuota_total', fromJson: intFromJson) int quotaTotal,@JsonKey(name: 'kuota_terjual', fromJson: intFromJson) int quotaSold,@JsonKey(name: 'kuota_tersedia', fromJson: intFromJson) int quotaAvailable,@JsonKey(name: 'max_per_transaksi', fromJson: intFromJson) int maxPerTransaction
});




}
/// @nodoc
class __$TicketCategoryCopyWithImpl<$Res>
    implements _$TicketCategoryCopyWith<$Res> {
  __$TicketCategoryCopyWithImpl(this._self, this._then);

  final _TicketCategory _self;
  final $Res Function(_TicketCategory) _then;

/// Create a copy of TicketCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? price = null,Object? quotaTotal = null,Object? quotaSold = null,Object? quotaAvailable = null,Object? maxPerTransaction = null,}) {
  return _then(_TicketCategory(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as num,quotaTotal: null == quotaTotal ? _self.quotaTotal : quotaTotal // ignore: cast_nullable_to_non_nullable
as int,quotaSold: null == quotaSold ? _self.quotaSold : quotaSold // ignore: cast_nullable_to_non_nullable
as int,quotaAvailable: null == quotaAvailable ? _self.quotaAvailable : quotaAvailable // ignore: cast_nullable_to_non_nullable
as int,maxPerTransaction: null == maxPerTransaction ? _self.maxPerTransaction : maxPerTransaction // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OrganizerProfile {

@JsonKey(fromJson: idFromJson) String? get id;@JsonKey(name: 'organization_name') String get name;@JsonKey(name: 'verification_status') String? get verificationStatus;@JsonKey(name: 'created_at', fromJson: dateFromJson) DateTime? get createdAt;
/// Create a copy of OrganizerProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizerProfileCopyWith<OrganizerProfile> get copyWith => _$OrganizerProfileCopyWithImpl<OrganizerProfile>(this as OrganizerProfile, _$identity);

  /// Serializes this OrganizerProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OrganizerProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganizerProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.verificationStatus, _this.verificationStatus) || other.verificationStatus == _this.verificationStatus)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OrganizerProfile;
  return Object.hash(runtimeType,_this.id,_this.name,_this.verificationStatus,_this.createdAt);
}

@override
String toString() {
  final _this = this as OrganizerProfile;
  return 'OrganizerProfile(id: ${_this.id}, name: ${_this.name}, verificationStatus: ${_this.verificationStatus}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $OrganizerProfileCopyWith<$Res>  {
  factory $OrganizerProfileCopyWith(OrganizerProfile value, $Res Function(OrganizerProfile) _then) = _$OrganizerProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: idFromJson) String? id,@JsonKey(name: 'organization_name') String name,@JsonKey(name: 'verification_status') String? verificationStatus,@JsonKey(name: 'created_at', fromJson: dateFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$OrganizerProfileCopyWithImpl<$Res>
    implements $OrganizerProfileCopyWith<$Res> {
  _$OrganizerProfileCopyWithImpl(this._self, this._then);

  final OrganizerProfile _self;
  final $Res Function(OrganizerProfile) _then;

/// Create a copy of OrganizerProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? verificationStatus = freezed,Object? createdAt = freezed,}) {
  return _then(OrganizerProfile(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,verificationStatus: freezed == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrganizerProfile].
extension OrganizerProfilePatterns on OrganizerProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganizerProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganizerProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganizerProfile value)  $default,){
final _that = this;
switch (_that) {
case _OrganizerProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganizerProfile value)?  $default,){
final _that = this;
switch (_that) {
case _OrganizerProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String? id, @JsonKey(name: 'organization_name')  String name, @JsonKey(name: 'verification_status')  String? verificationStatus, @JsonKey(name: 'created_at', fromJson: dateFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganizerProfile() when $default != null:
return $default(_that.id,_that.name,_that.verificationStatus,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: idFromJson)  String? id, @JsonKey(name: 'organization_name')  String name, @JsonKey(name: 'verification_status')  String? verificationStatus, @JsonKey(name: 'created_at', fromJson: dateFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _OrganizerProfile():
return $default(_that.id,_that.name,_that.verificationStatus,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: idFromJson)  String? id, @JsonKey(name: 'organization_name')  String name, @JsonKey(name: 'verification_status')  String? verificationStatus, @JsonKey(name: 'created_at', fromJson: dateFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _OrganizerProfile() when $default != null:
return $default(_that.id,_that.name,_that.verificationStatus,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganizerProfile implements OrganizerProfile {
  const _OrganizerProfile({@JsonKey(fromJson: idFromJson) this.id, @JsonKey(name: 'organization_name') this.name = '', @JsonKey(name: 'verification_status') this.verificationStatus, @JsonKey(name: 'created_at', fromJson: dateFromJson) this.createdAt});
  factory _OrganizerProfile.fromJson(Map<String, dynamic> json) => _$OrganizerProfileFromJson(json);

@override@JsonKey(fromJson: idFromJson) final  String? id;
@override@JsonKey(name: 'organization_name') final  String name;
@override@JsonKey(name: 'verification_status') final  String? verificationStatus;
@override@JsonKey(name: 'created_at', fromJson: dateFromJson) final  DateTime? createdAt;

/// Create a copy of OrganizerProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizerProfileCopyWith<_OrganizerProfile> get copyWith => __$OrganizerProfileCopyWithImpl<_OrganizerProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganizerProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganizerProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,verificationStatus,createdAt);
}

@override
String toString() {
    return 'OrganizerProfile(id: $id, name: $name, verificationStatus: $verificationStatus, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$OrganizerProfileCopyWith<$Res> implements $OrganizerProfileCopyWith<$Res> {
  factory _$OrganizerProfileCopyWith(_OrganizerProfile value, $Res Function(_OrganizerProfile) _then) = __$OrganizerProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: idFromJson) String? id,@JsonKey(name: 'organization_name') String name,@JsonKey(name: 'verification_status') String? verificationStatus,@JsonKey(name: 'created_at', fromJson: dateFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$OrganizerProfileCopyWithImpl<$Res>
    implements _$OrganizerProfileCopyWith<$Res> {
  __$OrganizerProfileCopyWithImpl(this._self, this._then);

  final _OrganizerProfile _self;
  final $Res Function(_OrganizerProfile) _then;

/// Create a copy of OrganizerProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? verificationStatus = freezed,Object? createdAt = freezed,}) {
  return _then(_OrganizerProfile(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,verificationStatus: freezed == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
