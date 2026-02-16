// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Weather {

 double get temperature; double get feelsLike; String get description; String get icon; int get humidity; double get windSpeed; int get windDegree; int get pressure; int get visibility; double get dewPoint; int get uvIndex; DateTime get sunrise; DateTime get sunset; DateTime get timestamp; String? get condition;
/// Create a copy of Weather
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherCopyWith<Weather> get copyWith => _$WeatherCopyWithImpl<Weather>(this as Weather, _$identity);

  /// Serializes this Weather to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Weather&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.windDegree, windDegree) || other.windDegree == windDegree)&&(identical(other.pressure, pressure) || other.pressure == pressure)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.dewPoint, dewPoint) || other.dewPoint == dewPoint)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.condition, condition) || other.condition == condition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temperature,feelsLike,description,icon,humidity,windSpeed,windDegree,pressure,visibility,dewPoint,uvIndex,sunrise,sunset,timestamp,condition);

@override
String toString() {
  return 'Weather(temperature: $temperature, feelsLike: $feelsLike, description: $description, icon: $icon, humidity: $humidity, windSpeed: $windSpeed, windDegree: $windDegree, pressure: $pressure, visibility: $visibility, dewPoint: $dewPoint, uvIndex: $uvIndex, sunrise: $sunrise, sunset: $sunset, timestamp: $timestamp, condition: $condition)';
}


}

/// @nodoc
abstract mixin class $WeatherCopyWith<$Res>  {
  factory $WeatherCopyWith(Weather value, $Res Function(Weather) _then) = _$WeatherCopyWithImpl;
@useResult
$Res call({
 double temperature, double feelsLike, String description, String icon, int humidity, double windSpeed, int windDegree, int pressure, int visibility, double dewPoint, int uvIndex, DateTime sunrise, DateTime sunset, DateTime timestamp, String? condition
});




}
/// @nodoc
class _$WeatherCopyWithImpl<$Res>
    implements $WeatherCopyWith<$Res> {
  _$WeatherCopyWithImpl(this._self, this._then);

  final Weather _self;
  final $Res Function(Weather) _then;

/// Create a copy of Weather
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temperature = null,Object? feelsLike = null,Object? description = null,Object? icon = null,Object? humidity = null,Object? windSpeed = null,Object? windDegree = null,Object? pressure = null,Object? visibility = null,Object? dewPoint = null,Object? uvIndex = null,Object? sunrise = null,Object? sunset = null,Object? timestamp = null,Object? condition = freezed,}) {
  return _then(_self.copyWith(
temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,windDegree: null == windDegree ? _self.windDegree : windDegree // ignore: cast_nullable_to_non_nullable
as int,pressure: null == pressure ? _self.pressure : pressure // ignore: cast_nullable_to_non_nullable
as int,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as int,dewPoint: null == dewPoint ? _self.dewPoint : dewPoint // ignore: cast_nullable_to_non_nullable
as double,uvIndex: null == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as int,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as DateTime,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as DateTime,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,condition: freezed == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Weather].
extension WeatherPatterns on Weather {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Weather value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Weather() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Weather value)  $default,){
final _that = this;
switch (_that) {
case _Weather():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Weather value)?  $default,){
final _that = this;
switch (_that) {
case _Weather() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double temperature,  double feelsLike,  String description,  String icon,  int humidity,  double windSpeed,  int windDegree,  int pressure,  int visibility,  double dewPoint,  int uvIndex,  DateTime sunrise,  DateTime sunset,  DateTime timestamp,  String? condition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Weather() when $default != null:
return $default(_that.temperature,_that.feelsLike,_that.description,_that.icon,_that.humidity,_that.windSpeed,_that.windDegree,_that.pressure,_that.visibility,_that.dewPoint,_that.uvIndex,_that.sunrise,_that.sunset,_that.timestamp,_that.condition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double temperature,  double feelsLike,  String description,  String icon,  int humidity,  double windSpeed,  int windDegree,  int pressure,  int visibility,  double dewPoint,  int uvIndex,  DateTime sunrise,  DateTime sunset,  DateTime timestamp,  String? condition)  $default,) {final _that = this;
switch (_that) {
case _Weather():
return $default(_that.temperature,_that.feelsLike,_that.description,_that.icon,_that.humidity,_that.windSpeed,_that.windDegree,_that.pressure,_that.visibility,_that.dewPoint,_that.uvIndex,_that.sunrise,_that.sunset,_that.timestamp,_that.condition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double temperature,  double feelsLike,  String description,  String icon,  int humidity,  double windSpeed,  int windDegree,  int pressure,  int visibility,  double dewPoint,  int uvIndex,  DateTime sunrise,  DateTime sunset,  DateTime timestamp,  String? condition)?  $default,) {final _that = this;
switch (_that) {
case _Weather() when $default != null:
return $default(_that.temperature,_that.feelsLike,_that.description,_that.icon,_that.humidity,_that.windSpeed,_that.windDegree,_that.pressure,_that.visibility,_that.dewPoint,_that.uvIndex,_that.sunrise,_that.sunset,_that.timestamp,_that.condition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Weather implements Weather {
  const _Weather({required this.temperature, required this.feelsLike, required this.description, required this.icon, required this.humidity, required this.windSpeed, required this.windDegree, required this.pressure, required this.visibility, required this.dewPoint, required this.uvIndex, required this.sunrise, required this.sunset, required this.timestamp, this.condition});
  factory _Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);

@override final  double temperature;
@override final  double feelsLike;
@override final  String description;
@override final  String icon;
@override final  int humidity;
@override final  double windSpeed;
@override final  int windDegree;
@override final  int pressure;
@override final  int visibility;
@override final  double dewPoint;
@override final  int uvIndex;
@override final  DateTime sunrise;
@override final  DateTime sunset;
@override final  DateTime timestamp;
@override final  String? condition;

/// Create a copy of Weather
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherCopyWith<_Weather> get copyWith => __$WeatherCopyWithImpl<_Weather>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Weather&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.windDegree, windDegree) || other.windDegree == windDegree)&&(identical(other.pressure, pressure) || other.pressure == pressure)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.dewPoint, dewPoint) || other.dewPoint == dewPoint)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex)&&(identical(other.sunrise, sunrise) || other.sunrise == sunrise)&&(identical(other.sunset, sunset) || other.sunset == sunset)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.condition, condition) || other.condition == condition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temperature,feelsLike,description,icon,humidity,windSpeed,windDegree,pressure,visibility,dewPoint,uvIndex,sunrise,sunset,timestamp,condition);

@override
String toString() {
  return 'Weather(temperature: $temperature, feelsLike: $feelsLike, description: $description, icon: $icon, humidity: $humidity, windSpeed: $windSpeed, windDegree: $windDegree, pressure: $pressure, visibility: $visibility, dewPoint: $dewPoint, uvIndex: $uvIndex, sunrise: $sunrise, sunset: $sunset, timestamp: $timestamp, condition: $condition)';
}


}

/// @nodoc
abstract mixin class _$WeatherCopyWith<$Res> implements $WeatherCopyWith<$Res> {
  factory _$WeatherCopyWith(_Weather value, $Res Function(_Weather) _then) = __$WeatherCopyWithImpl;
@override @useResult
$Res call({
 double temperature, double feelsLike, String description, String icon, int humidity, double windSpeed, int windDegree, int pressure, int visibility, double dewPoint, int uvIndex, DateTime sunrise, DateTime sunset, DateTime timestamp, String? condition
});




}
/// @nodoc
class __$WeatherCopyWithImpl<$Res>
    implements _$WeatherCopyWith<$Res> {
  __$WeatherCopyWithImpl(this._self, this._then);

  final _Weather _self;
  final $Res Function(_Weather) _then;

/// Create a copy of Weather
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temperature = null,Object? feelsLike = null,Object? description = null,Object? icon = null,Object? humidity = null,Object? windSpeed = null,Object? windDegree = null,Object? pressure = null,Object? visibility = null,Object? dewPoint = null,Object? uvIndex = null,Object? sunrise = null,Object? sunset = null,Object? timestamp = null,Object? condition = freezed,}) {
  return _then(_Weather(
temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,windDegree: null == windDegree ? _self.windDegree : windDegree // ignore: cast_nullable_to_non_nullable
as int,pressure: null == pressure ? _self.pressure : pressure // ignore: cast_nullable_to_non_nullable
as int,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as int,dewPoint: null == dewPoint ? _self.dewPoint : dewPoint // ignore: cast_nullable_to_non_nullable
as double,uvIndex: null == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as int,sunrise: null == sunrise ? _self.sunrise : sunrise // ignore: cast_nullable_to_non_nullable
as DateTime,sunset: null == sunset ? _self.sunset : sunset // ignore: cast_nullable_to_non_nullable
as DateTime,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,condition: freezed == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HourlyForecast {

 DateTime get time; double get temperature; double get feelsLike; int get precipitationProbability; double get windSpeed; String get description; String get icon; String? get condition; double? get precipitationAmount;
/// Create a copy of HourlyForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourlyForecastCopyWith<HourlyForecast> get copyWith => _$HourlyForecastCopyWithImpl<HourlyForecast>(this as HourlyForecast, _$identity);

  /// Serializes this HourlyForecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HourlyForecast&&(identical(other.time, time) || other.time == time)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.precipitationProbability, precipitationProbability) || other.precipitationProbability == precipitationProbability)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.precipitationAmount, precipitationAmount) || other.precipitationAmount == precipitationAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperature,feelsLike,precipitationProbability,windSpeed,description,icon,condition,precipitationAmount);

@override
String toString() {
  return 'HourlyForecast(time: $time, temperature: $temperature, feelsLike: $feelsLike, precipitationProbability: $precipitationProbability, windSpeed: $windSpeed, description: $description, icon: $icon, condition: $condition, precipitationAmount: $precipitationAmount)';
}


}

/// @nodoc
abstract mixin class $HourlyForecastCopyWith<$Res>  {
  factory $HourlyForecastCopyWith(HourlyForecast value, $Res Function(HourlyForecast) _then) = _$HourlyForecastCopyWithImpl;
@useResult
$Res call({
 DateTime time, double temperature, double feelsLike, int precipitationProbability, double windSpeed, String description, String icon, String? condition, double? precipitationAmount
});




}
/// @nodoc
class _$HourlyForecastCopyWithImpl<$Res>
    implements $HourlyForecastCopyWith<$Res> {
  _$HourlyForecastCopyWithImpl(this._self, this._then);

  final HourlyForecast _self;
  final $Res Function(HourlyForecast) _then;

/// Create a copy of HourlyForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperature = null,Object? feelsLike = null,Object? precipitationProbability = null,Object? windSpeed = null,Object? description = null,Object? icon = null,Object? condition = freezed,Object? precipitationAmount = freezed,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as int,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,condition: freezed == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String?,precipitationAmount: freezed == precipitationAmount ? _self.precipitationAmount : precipitationAmount // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [HourlyForecast].
extension HourlyForecastPatterns on HourlyForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HourlyForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HourlyForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HourlyForecast value)  $default,){
final _that = this;
switch (_that) {
case _HourlyForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HourlyForecast value)?  $default,){
final _that = this;
switch (_that) {
case _HourlyForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime time,  double temperature,  double feelsLike,  int precipitationProbability,  double windSpeed,  String description,  String icon,  String? condition,  double? precipitationAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HourlyForecast() when $default != null:
return $default(_that.time,_that.temperature,_that.feelsLike,_that.precipitationProbability,_that.windSpeed,_that.description,_that.icon,_that.condition,_that.precipitationAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime time,  double temperature,  double feelsLike,  int precipitationProbability,  double windSpeed,  String description,  String icon,  String? condition,  double? precipitationAmount)  $default,) {final _that = this;
switch (_that) {
case _HourlyForecast():
return $default(_that.time,_that.temperature,_that.feelsLike,_that.precipitationProbability,_that.windSpeed,_that.description,_that.icon,_that.condition,_that.precipitationAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime time,  double temperature,  double feelsLike,  int precipitationProbability,  double windSpeed,  String description,  String icon,  String? condition,  double? precipitationAmount)?  $default,) {final _that = this;
switch (_that) {
case _HourlyForecast() when $default != null:
return $default(_that.time,_that.temperature,_that.feelsLike,_that.precipitationProbability,_that.windSpeed,_that.description,_that.icon,_that.condition,_that.precipitationAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HourlyForecast implements HourlyForecast {
  const _HourlyForecast({required this.time, required this.temperature, required this.feelsLike, required this.precipitationProbability, required this.windSpeed, required this.description, required this.icon, this.condition, this.precipitationAmount});
  factory _HourlyForecast.fromJson(Map<String, dynamic> json) => _$HourlyForecastFromJson(json);

@override final  DateTime time;
@override final  double temperature;
@override final  double feelsLike;
@override final  int precipitationProbability;
@override final  double windSpeed;
@override final  String description;
@override final  String icon;
@override final  String? condition;
@override final  double? precipitationAmount;

/// Create a copy of HourlyForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourlyForecastCopyWith<_HourlyForecast> get copyWith => __$HourlyForecastCopyWithImpl<_HourlyForecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HourlyForecastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HourlyForecast&&(identical(other.time, time) || other.time == time)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.feelsLike, feelsLike) || other.feelsLike == feelsLike)&&(identical(other.precipitationProbability, precipitationProbability) || other.precipitationProbability == precipitationProbability)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.precipitationAmount, precipitationAmount) || other.precipitationAmount == precipitationAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,temperature,feelsLike,precipitationProbability,windSpeed,description,icon,condition,precipitationAmount);

@override
String toString() {
  return 'HourlyForecast(time: $time, temperature: $temperature, feelsLike: $feelsLike, precipitationProbability: $precipitationProbability, windSpeed: $windSpeed, description: $description, icon: $icon, condition: $condition, precipitationAmount: $precipitationAmount)';
}


}

/// @nodoc
abstract mixin class _$HourlyForecastCopyWith<$Res> implements $HourlyForecastCopyWith<$Res> {
  factory _$HourlyForecastCopyWith(_HourlyForecast value, $Res Function(_HourlyForecast) _then) = __$HourlyForecastCopyWithImpl;
@override @useResult
$Res call({
 DateTime time, double temperature, double feelsLike, int precipitationProbability, double windSpeed, String description, String icon, String? condition, double? precipitationAmount
});




}
/// @nodoc
class __$HourlyForecastCopyWithImpl<$Res>
    implements _$HourlyForecastCopyWith<$Res> {
  __$HourlyForecastCopyWithImpl(this._self, this._then);

  final _HourlyForecast _self;
  final $Res Function(_HourlyForecast) _then;

/// Create a copy of HourlyForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperature = null,Object? feelsLike = null,Object? precipitationProbability = null,Object? windSpeed = null,Object? description = null,Object? icon = null,Object? condition = freezed,Object? precipitationAmount = freezed,}) {
  return _then(_HourlyForecast(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,feelsLike: null == feelsLike ? _self.feelsLike : feelsLike // ignore: cast_nullable_to_non_nullable
as double,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as int,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,condition: freezed == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String?,precipitationAmount: freezed == precipitationAmount ? _self.precipitationAmount : precipitationAmount // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$DailyForecast {

 DateTime get date; double get tempMax; double get tempMin; String get description; String get icon; String? get condition; int get precipitationProbability; double get windSpeed; int get humidity; int? get uvIndex;
/// Create a copy of DailyForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyForecastCopyWith<DailyForecast> get copyWith => _$DailyForecastCopyWithImpl<DailyForecast>(this as DailyForecast, _$identity);

  /// Serializes this DailyForecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyForecast&&(identical(other.date, date) || other.date == date)&&(identical(other.tempMax, tempMax) || other.tempMax == tempMax)&&(identical(other.tempMin, tempMin) || other.tempMin == tempMin)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.precipitationProbability, precipitationProbability) || other.precipitationProbability == precipitationProbability)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,tempMax,tempMin,description,icon,condition,precipitationProbability,windSpeed,humidity,uvIndex);

@override
String toString() {
  return 'DailyForecast(date: $date, tempMax: $tempMax, tempMin: $tempMin, description: $description, icon: $icon, condition: $condition, precipitationProbability: $precipitationProbability, windSpeed: $windSpeed, humidity: $humidity, uvIndex: $uvIndex)';
}


}

/// @nodoc
abstract mixin class $DailyForecastCopyWith<$Res>  {
  factory $DailyForecastCopyWith(DailyForecast value, $Res Function(DailyForecast) _then) = _$DailyForecastCopyWithImpl;
@useResult
$Res call({
 DateTime date, double tempMax, double tempMin, String description, String icon, String? condition, int precipitationProbability, double windSpeed, int humidity, int? uvIndex
});




}
/// @nodoc
class _$DailyForecastCopyWithImpl<$Res>
    implements $DailyForecastCopyWith<$Res> {
  _$DailyForecastCopyWithImpl(this._self, this._then);

  final DailyForecast _self;
  final $Res Function(DailyForecast) _then;

/// Create a copy of DailyForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? tempMax = null,Object? tempMin = null,Object? description = null,Object? icon = null,Object? condition = freezed,Object? precipitationProbability = null,Object? windSpeed = null,Object? humidity = null,Object? uvIndex = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,tempMax: null == tempMax ? _self.tempMax : tempMax // ignore: cast_nullable_to_non_nullable
as double,tempMin: null == tempMin ? _self.tempMin : tempMin // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,condition: freezed == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String?,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as int,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,uvIndex: freezed == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyForecast].
extension DailyForecastPatterns on DailyForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyForecast value)  $default,){
final _that = this;
switch (_that) {
case _DailyForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyForecast value)?  $default,){
final _that = this;
switch (_that) {
case _DailyForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double tempMax,  double tempMin,  String description,  String icon,  String? condition,  int precipitationProbability,  double windSpeed,  int humidity,  int? uvIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyForecast() when $default != null:
return $default(_that.date,_that.tempMax,_that.tempMin,_that.description,_that.icon,_that.condition,_that.precipitationProbability,_that.windSpeed,_that.humidity,_that.uvIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double tempMax,  double tempMin,  String description,  String icon,  String? condition,  int precipitationProbability,  double windSpeed,  int humidity,  int? uvIndex)  $default,) {final _that = this;
switch (_that) {
case _DailyForecast():
return $default(_that.date,_that.tempMax,_that.tempMin,_that.description,_that.icon,_that.condition,_that.precipitationProbability,_that.windSpeed,_that.humidity,_that.uvIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double tempMax,  double tempMin,  String description,  String icon,  String? condition,  int precipitationProbability,  double windSpeed,  int humidity,  int? uvIndex)?  $default,) {final _that = this;
switch (_that) {
case _DailyForecast() when $default != null:
return $default(_that.date,_that.tempMax,_that.tempMin,_that.description,_that.icon,_that.condition,_that.precipitationProbability,_that.windSpeed,_that.humidity,_that.uvIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyForecast implements DailyForecast {
  const _DailyForecast({required this.date, required this.tempMax, required this.tempMin, required this.description, required this.icon, this.condition, required this.precipitationProbability, required this.windSpeed, required this.humidity, this.uvIndex});
  factory _DailyForecast.fromJson(Map<String, dynamic> json) => _$DailyForecastFromJson(json);

@override final  DateTime date;
@override final  double tempMax;
@override final  double tempMin;
@override final  String description;
@override final  String icon;
@override final  String? condition;
@override final  int precipitationProbability;
@override final  double windSpeed;
@override final  int humidity;
@override final  int? uvIndex;

/// Create a copy of DailyForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyForecastCopyWith<_DailyForecast> get copyWith => __$DailyForecastCopyWithImpl<_DailyForecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyForecastToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyForecast&&(identical(other.date, date) || other.date == date)&&(identical(other.tempMax, tempMax) || other.tempMax == tempMax)&&(identical(other.tempMin, tempMin) || other.tempMin == tempMin)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.precipitationProbability, precipitationProbability) || other.precipitationProbability == precipitationProbability)&&(identical(other.windSpeed, windSpeed) || other.windSpeed == windSpeed)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.uvIndex, uvIndex) || other.uvIndex == uvIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,tempMax,tempMin,description,icon,condition,precipitationProbability,windSpeed,humidity,uvIndex);

@override
String toString() {
  return 'DailyForecast(date: $date, tempMax: $tempMax, tempMin: $tempMin, description: $description, icon: $icon, condition: $condition, precipitationProbability: $precipitationProbability, windSpeed: $windSpeed, humidity: $humidity, uvIndex: $uvIndex)';
}


}

/// @nodoc
abstract mixin class _$DailyForecastCopyWith<$Res> implements $DailyForecastCopyWith<$Res> {
  factory _$DailyForecastCopyWith(_DailyForecast value, $Res Function(_DailyForecast) _then) = __$DailyForecastCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double tempMax, double tempMin, String description, String icon, String? condition, int precipitationProbability, double windSpeed, int humidity, int? uvIndex
});




}
/// @nodoc
class __$DailyForecastCopyWithImpl<$Res>
    implements _$DailyForecastCopyWith<$Res> {
  __$DailyForecastCopyWithImpl(this._self, this._then);

  final _DailyForecast _self;
  final $Res Function(_DailyForecast) _then;

/// Create a copy of DailyForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? tempMax = null,Object? tempMin = null,Object? description = null,Object? icon = null,Object? condition = freezed,Object? precipitationProbability = null,Object? windSpeed = null,Object? humidity = null,Object? uvIndex = freezed,}) {
  return _then(_DailyForecast(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,tempMax: null == tempMax ? _self.tempMax : tempMax // ignore: cast_nullable_to_non_nullable
as double,tempMin: null == tempMin ? _self.tempMin : tempMin // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,condition: freezed == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String?,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as int,windSpeed: null == windSpeed ? _self.windSpeed : windSpeed // ignore: cast_nullable_to_non_nullable
as double,humidity: null == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as int,uvIndex: freezed == uvIndex ? _self.uvIndex : uvIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$WeatherAlert {

 String get event; String get description; DateTime get start; DateTime get end; String get severity; String? get senderName;
/// Create a copy of WeatherAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherAlertCopyWith<WeatherAlert> get copyWith => _$WeatherAlertCopyWithImpl<WeatherAlert>(this as WeatherAlert, _$identity);

  /// Serializes this WeatherAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherAlert&&(identical(other.event, event) || other.event == event)&&(identical(other.description, description) || other.description == description)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.senderName, senderName) || other.senderName == senderName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,event,description,start,end,severity,senderName);

@override
String toString() {
  return 'WeatherAlert(event: $event, description: $description, start: $start, end: $end, severity: $severity, senderName: $senderName)';
}


}

/// @nodoc
abstract mixin class $WeatherAlertCopyWith<$Res>  {
  factory $WeatherAlertCopyWith(WeatherAlert value, $Res Function(WeatherAlert) _then) = _$WeatherAlertCopyWithImpl;
@useResult
$Res call({
 String event, String description, DateTime start, DateTime end, String severity, String? senderName
});




}
/// @nodoc
class _$WeatherAlertCopyWithImpl<$Res>
    implements $WeatherAlertCopyWith<$Res> {
  _$WeatherAlertCopyWithImpl(this._self, this._then);

  final WeatherAlert _self;
  final $Res Function(WeatherAlert) _then;

/// Create a copy of WeatherAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? event = null,Object? description = null,Object? start = null,Object? end = null,Object? severity = null,Object? senderName = freezed,}) {
  return _then(_self.copyWith(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherAlert].
extension WeatherAlertPatterns on WeatherAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherAlert value)  $default,){
final _that = this;
switch (_that) {
case _WeatherAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherAlert value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String event,  String description,  DateTime start,  DateTime end,  String severity,  String? senderName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherAlert() when $default != null:
return $default(_that.event,_that.description,_that.start,_that.end,_that.severity,_that.senderName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String event,  String description,  DateTime start,  DateTime end,  String severity,  String? senderName)  $default,) {final _that = this;
switch (_that) {
case _WeatherAlert():
return $default(_that.event,_that.description,_that.start,_that.end,_that.severity,_that.senderName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String event,  String description,  DateTime start,  DateTime end,  String severity,  String? senderName)?  $default,) {final _that = this;
switch (_that) {
case _WeatherAlert() when $default != null:
return $default(_that.event,_that.description,_that.start,_that.end,_that.severity,_that.senderName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherAlert implements WeatherAlert {
  const _WeatherAlert({required this.event, required this.description, required this.start, required this.end, required this.severity, this.senderName});
  factory _WeatherAlert.fromJson(Map<String, dynamic> json) => _$WeatherAlertFromJson(json);

@override final  String event;
@override final  String description;
@override final  DateTime start;
@override final  DateTime end;
@override final  String severity;
@override final  String? senderName;

/// Create a copy of WeatherAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherAlertCopyWith<_WeatherAlert> get copyWith => __$WeatherAlertCopyWithImpl<_WeatherAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherAlert&&(identical(other.event, event) || other.event == event)&&(identical(other.description, description) || other.description == description)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.senderName, senderName) || other.senderName == senderName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,event,description,start,end,severity,senderName);

@override
String toString() {
  return 'WeatherAlert(event: $event, description: $description, start: $start, end: $end, severity: $severity, senderName: $senderName)';
}


}

/// @nodoc
abstract mixin class _$WeatherAlertCopyWith<$Res> implements $WeatherAlertCopyWith<$Res> {
  factory _$WeatherAlertCopyWith(_WeatherAlert value, $Res Function(_WeatherAlert) _then) = __$WeatherAlertCopyWithImpl;
@override @useResult
$Res call({
 String event, String description, DateTime start, DateTime end, String severity, String? senderName
});




}
/// @nodoc
class __$WeatherAlertCopyWithImpl<$Res>
    implements _$WeatherAlertCopyWith<$Res> {
  __$WeatherAlertCopyWithImpl(this._self, this._then);

  final _WeatherAlert _self;
  final $Res Function(_WeatherAlert) _then;

/// Create a copy of WeatherAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? event = null,Object? description = null,Object? start = null,Object? end = null,Object? severity = null,Object? senderName = freezed,}) {
  return _then(_WeatherAlert(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Location {

 String get name; double get latitude; double get longitude; String? get country; String? get state; bool get isFavorite;
/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationCopyWith<Location> get copyWith => _$LocationCopyWithImpl<Location>(this as Location, _$identity);

  /// Serializes this Location to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Location&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.country, country) || other.country == country)&&(identical(other.state, state) || other.state == state)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,latitude,longitude,country,state,isFavorite);

@override
String toString() {
  return 'Location(name: $name, latitude: $latitude, longitude: $longitude, country: $country, state: $state, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $LocationCopyWith<$Res>  {
  factory $LocationCopyWith(Location value, $Res Function(Location) _then) = _$LocationCopyWithImpl;
@useResult
$Res call({
 String name, double latitude, double longitude, String? country, String? state, bool isFavorite
});




}
/// @nodoc
class _$LocationCopyWithImpl<$Res>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._self, this._then);

  final Location _self;
  final $Res Function(Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? latitude = null,Object? longitude = null,Object? country = freezed,Object? state = freezed,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Location].
extension LocationPatterns on Location {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Location value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Location() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Location value)  $default,){
final _that = this;
switch (_that) {
case _Location():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Location value)?  $default,){
final _that = this;
switch (_that) {
case _Location() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double latitude,  double longitude,  String? country,  String? state,  bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.name,_that.latitude,_that.longitude,_that.country,_that.state,_that.isFavorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double latitude,  double longitude,  String? country,  String? state,  bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _Location():
return $default(_that.name,_that.latitude,_that.longitude,_that.country,_that.state,_that.isFavorite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double latitude,  double longitude,  String? country,  String? state,  bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.name,_that.latitude,_that.longitude,_that.country,_that.state,_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Location implements Location {
  const _Location({required this.name, required this.latitude, required this.longitude, this.country, this.state, this.isFavorite = false});
  factory _Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

@override final  String name;
@override final  double latitude;
@override final  double longitude;
@override final  String? country;
@override final  String? state;
@override@JsonKey() final  bool isFavorite;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationCopyWith<_Location> get copyWith => __$LocationCopyWithImpl<_Location>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Location&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.country, country) || other.country == country)&&(identical(other.state, state) || other.state == state)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,latitude,longitude,country,state,isFavorite);

@override
String toString() {
  return 'Location(name: $name, latitude: $latitude, longitude: $longitude, country: $country, state: $state, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$LocationCopyWith<$Res> implements $LocationCopyWith<$Res> {
  factory _$LocationCopyWith(_Location value, $Res Function(_Location) _then) = __$LocationCopyWithImpl;
@override @useResult
$Res call({
 String name, double latitude, double longitude, String? country, String? state, bool isFavorite
});




}
/// @nodoc
class __$LocationCopyWithImpl<$Res>
    implements _$LocationCopyWith<$Res> {
  __$LocationCopyWithImpl(this._self, this._then);

  final _Location _self;
  final $Res Function(_Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? latitude = null,Object? longitude = null,Object? country = freezed,Object? state = freezed,Object? isFavorite = null,}) {
  return _then(_Location(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AirQuality {

 int get aqi; double get pm25; double get pm10; double get no2; double get so2; double get o3; double get co; DateTime get timestamp;
/// Create a copy of AirQuality
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AirQualityCopyWith<AirQuality> get copyWith => _$AirQualityCopyWithImpl<AirQuality>(this as AirQuality, _$identity);

  /// Serializes this AirQuality to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AirQuality&&(identical(other.aqi, aqi) || other.aqi == aqi)&&(identical(other.pm25, pm25) || other.pm25 == pm25)&&(identical(other.pm10, pm10) || other.pm10 == pm10)&&(identical(other.no2, no2) || other.no2 == no2)&&(identical(other.so2, so2) || other.so2 == so2)&&(identical(other.o3, o3) || other.o3 == o3)&&(identical(other.co, co) || other.co == co)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aqi,pm25,pm10,no2,so2,o3,co,timestamp);

@override
String toString() {
  return 'AirQuality(aqi: $aqi, pm25: $pm25, pm10: $pm10, no2: $no2, so2: $so2, o3: $o3, co: $co, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $AirQualityCopyWith<$Res>  {
  factory $AirQualityCopyWith(AirQuality value, $Res Function(AirQuality) _then) = _$AirQualityCopyWithImpl;
@useResult
$Res call({
 int aqi, double pm25, double pm10, double no2, double so2, double o3, double co, DateTime timestamp
});




}
/// @nodoc
class _$AirQualityCopyWithImpl<$Res>
    implements $AirQualityCopyWith<$Res> {
  _$AirQualityCopyWithImpl(this._self, this._then);

  final AirQuality _self;
  final $Res Function(AirQuality) _then;

/// Create a copy of AirQuality
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aqi = null,Object? pm25 = null,Object? pm10 = null,Object? no2 = null,Object? so2 = null,Object? o3 = null,Object? co = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
aqi: null == aqi ? _self.aqi : aqi // ignore: cast_nullable_to_non_nullable
as int,pm25: null == pm25 ? _self.pm25 : pm25 // ignore: cast_nullable_to_non_nullable
as double,pm10: null == pm10 ? _self.pm10 : pm10 // ignore: cast_nullable_to_non_nullable
as double,no2: null == no2 ? _self.no2 : no2 // ignore: cast_nullable_to_non_nullable
as double,so2: null == so2 ? _self.so2 : so2 // ignore: cast_nullable_to_non_nullable
as double,o3: null == o3 ? _self.o3 : o3 // ignore: cast_nullable_to_non_nullable
as double,co: null == co ? _self.co : co // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AirQuality].
extension AirQualityPatterns on AirQuality {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AirQuality value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AirQuality() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AirQuality value)  $default,){
final _that = this;
switch (_that) {
case _AirQuality():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AirQuality value)?  $default,){
final _that = this;
switch (_that) {
case _AirQuality() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int aqi,  double pm25,  double pm10,  double no2,  double so2,  double o3,  double co,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AirQuality() when $default != null:
return $default(_that.aqi,_that.pm25,_that.pm10,_that.no2,_that.so2,_that.o3,_that.co,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int aqi,  double pm25,  double pm10,  double no2,  double so2,  double o3,  double co,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _AirQuality():
return $default(_that.aqi,_that.pm25,_that.pm10,_that.no2,_that.so2,_that.o3,_that.co,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int aqi,  double pm25,  double pm10,  double no2,  double so2,  double o3,  double co,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _AirQuality() when $default != null:
return $default(_that.aqi,_that.pm25,_that.pm10,_that.no2,_that.so2,_that.o3,_that.co,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AirQuality implements AirQuality {
  const _AirQuality({required this.aqi, required this.pm25, required this.pm10, required this.no2, required this.so2, required this.o3, required this.co, required this.timestamp});
  factory _AirQuality.fromJson(Map<String, dynamic> json) => _$AirQualityFromJson(json);

@override final  int aqi;
@override final  double pm25;
@override final  double pm10;
@override final  double no2;
@override final  double so2;
@override final  double o3;
@override final  double co;
@override final  DateTime timestamp;

/// Create a copy of AirQuality
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AirQualityCopyWith<_AirQuality> get copyWith => __$AirQualityCopyWithImpl<_AirQuality>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AirQualityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AirQuality&&(identical(other.aqi, aqi) || other.aqi == aqi)&&(identical(other.pm25, pm25) || other.pm25 == pm25)&&(identical(other.pm10, pm10) || other.pm10 == pm10)&&(identical(other.no2, no2) || other.no2 == no2)&&(identical(other.so2, so2) || other.so2 == so2)&&(identical(other.o3, o3) || other.o3 == o3)&&(identical(other.co, co) || other.co == co)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aqi,pm25,pm10,no2,so2,o3,co,timestamp);

@override
String toString() {
  return 'AirQuality(aqi: $aqi, pm25: $pm25, pm10: $pm10, no2: $no2, so2: $so2, o3: $o3, co: $co, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$AirQualityCopyWith<$Res> implements $AirQualityCopyWith<$Res> {
  factory _$AirQualityCopyWith(_AirQuality value, $Res Function(_AirQuality) _then) = __$AirQualityCopyWithImpl;
@override @useResult
$Res call({
 int aqi, double pm25, double pm10, double no2, double so2, double o3, double co, DateTime timestamp
});




}
/// @nodoc
class __$AirQualityCopyWithImpl<$Res>
    implements _$AirQualityCopyWith<$Res> {
  __$AirQualityCopyWithImpl(this._self, this._then);

  final _AirQuality _self;
  final $Res Function(_AirQuality) _then;

/// Create a copy of AirQuality
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aqi = null,Object? pm25 = null,Object? pm10 = null,Object? no2 = null,Object? so2 = null,Object? o3 = null,Object? co = null,Object? timestamp = null,}) {
  return _then(_AirQuality(
aqi: null == aqi ? _self.aqi : aqi // ignore: cast_nullable_to_non_nullable
as int,pm25: null == pm25 ? _self.pm25 : pm25 // ignore: cast_nullable_to_non_nullable
as double,pm10: null == pm10 ? _self.pm10 : pm10 // ignore: cast_nullable_to_non_nullable
as double,no2: null == no2 ? _self.no2 : no2 // ignore: cast_nullable_to_non_nullable
as double,so2: null == so2 ? _self.so2 : so2 // ignore: cast_nullable_to_non_nullable
as double,o3: null == o3 ? _self.o3 : o3 // ignore: cast_nullable_to_non_nullable
as double,co: null == co ? _self.co : co // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
