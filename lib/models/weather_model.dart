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


class DailyWeather {
  final int dt; // время в unix timestamp
  final double temperature; // средняя температура дня
  final String mainCondition; // краткое описание погоды

  DailyWeather({
    required this.dt,
    required this.temperature,
    required this.mainCondition,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      dt: json['dt'],
      temperature: json['temp']['day'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}