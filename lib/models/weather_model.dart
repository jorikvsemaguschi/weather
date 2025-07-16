class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
    return Weather(
      cityName: cityName,
      temperature: json['current']['temp'].toDouble(),
      mainCondition: json['current']['weather'][0]['main'],
    );
  }
}
