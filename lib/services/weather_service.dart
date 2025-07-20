import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

// Исключение для ошибок сервиса погоды
class WeatherServiceException implements Exception {
  final String type;
  final int? code;
  WeatherServiceException(this.type, {this.code});
}

// Сервис для работы с погодным API и кэшем
class WeatherService {
  final String _geoUrl = 'http://api.openweathermap.org/geo/1.0/direct';
  final String _oneCallUrl = 'https://api.openweathermap.org/data/3.0/onecall';
  final String _apiKey = dotenv.env['WEATHER_API_KEY']!;

  static const _weatherCachePrefix = 'weather_cache_';
  static const _forecastCachePrefix = 'forecast_cache_';
  static const _weatherCacheDuration = Duration(minutes: 10);
  static const _forecastCacheDuration = Duration(hours: 1);

  // Получение координат по названию города
  Future<Map<String, double>> _getCoordinates(String cityName) async {
    final url = Uri.parse('$_geoUrl?q=$cityName&limit=1&appid=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final lat = data[0]['lat'];
        final lon = data[0]['lon'];
        return {'lat': lat, 'lon': lon};
      } else {
        throw WeatherServiceException('cityNotFound');
      }
    } else {
      throw WeatherServiceException('geocodingError', code: response.statusCode);
    }
  }

  // Получение прогноза на 7 дней с кэшированием
  Future<List<DailyWeather>> fetch7DayForecast(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_forecastCachePrefix$cityName';
    final cacheString = prefs.getString(cacheKey);
    if (cacheString != null) {
      final cache = jsonDecode(cacheString);
      final cacheTime = DateTime.parse(cache['timestamp']);
      if (DateTime.now().difference(cacheTime) < _forecastCacheDuration) {
        final List<dynamic> dailyList = cache['data'];
        return dailyList.map((json) => DailyWeather.fromJson(json)).toList();
      }
    }

    final coords = await _getCoordinates(cityName);
    final lat = coords['lat'];
    final lon = coords['lon'];

    final url = Uri.parse(
      '$_oneCallUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> dailyList = data['daily'];
      await prefs.setString(
        cacheKey,
        jsonEncode({
          'timestamp': DateTime.now().toIso8601String(),
          'data': dailyList,
        }),
      );
      return dailyList.map((json) => DailyWeather.fromJson(json)).toList();
    } else {
      throw WeatherServiceException('forecastError', code: response.statusCode);
    }
  }

  // Получение текущей погоды с кэшированием
  Future<Weather> fetchWeather(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_weatherCachePrefix$cityName';
    final cacheString = prefs.getString(cacheKey);
    if (cacheString != null) {
      final cache = jsonDecode(cacheString);
      final cacheTime = DateTime.parse(cache['timestamp']);
      if (DateTime.now().difference(cacheTime) < _weatherCacheDuration) {
        return Weather.fromJson(cache['data'], cityName);
      }
    }

    final coords = await _getCoordinates(cityName);
    final lat = coords['lat'];
    final lon = coords['lon'];

    final url = Uri.parse(
      '$_oneCallUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString(
        cacheKey,
        jsonEncode({
          'timestamp': DateTime.now().toIso8601String(),
          'data': data,
        }),
      );
      return Weather.fromJson(data, cityName);
    } else {
      throw WeatherServiceException('weatherError', code: response.statusCode);
    }
  }
}