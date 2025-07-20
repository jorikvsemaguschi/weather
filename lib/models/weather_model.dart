// Модель текущей погоды
class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int clouds;
  final double feelsLike;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.clouds,
    required this.feelsLike,
  });

  // Создание объекта из JSON
  factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
    final current = json['current'];
    return Weather(
      cityName: cityName,
      temperature: current['temp'].toDouble(),
      mainCondition: current['weather'][0]['main'],
      humidity: current['humidity'],
      pressure: current['pressure'],
      windSpeed: current['wind_speed'].toDouble(),
      clouds: current['clouds'],
      feelsLike: current['feels_like'].toDouble(),
    );
  }
}

// Модель прогноза на день
class DailyWeather {
  final int dt; // Время (timestamp)
  final double temperature; // Температура днем
  final String mainCondition; // Основное погодное условие

  DailyWeather({
    required this.dt,
    required this.temperature,
    required this.mainCondition,
  });

  // Создание объекта из JSON
  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      dt: json['dt'],
      temperature: json['temp']['day'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}