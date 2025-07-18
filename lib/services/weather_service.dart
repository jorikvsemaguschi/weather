import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart';

class WeatherService {
  final String _geoUrl = 'http://api.openweathermap.org/geo/1.0/direct';
  final String _oneCallUrl = 'https://api.openweathermap.org/data/3.0/onecall';
  final String _apiKey = dotenv.env['WEATHER_API_KEY']!;

  // Получаем координаты по названию города
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
        throw Exception('Город не найден');
      }
    } else {
      throw Exception('Ошибка геокодинга: ${response.statusCode}');
    }
  }

  Future<List<DailyWeather>> fetch7DayForecast(String cityName) async {
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
      return dailyList.map((json) => DailyWeather.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка получения прогноза: ${response.statusCode}');
    }
  }

  // Получаем погоду по координатам
  Future<Weather> fetchWeather(String cityName) async {
    final coords = await _getCoordinates(cityName);
    final lat = coords['lat'];
    final lon = coords['lon'];

    final url = Uri.parse(
      '$_oneCallUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Weather.fromJson(data, cityName);
    } else {
      throw Exception('Ошибка получения погоды: ${response.statusCode}');
    }
  }
}
