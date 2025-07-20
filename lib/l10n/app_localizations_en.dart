// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Weather App';

  @override
  String get settings => 'Settings';

  @override
  String get city => 'City';

  @override
  String get temperatureInC => 'Temperature in Celsius';

  @override
  String get language => 'Language';

  @override
  String get enterCity => 'Enter city';

  @override
  String get search => 'Search';

  @override
  String get inputPrompt =>
      'Please select a city by tapping on the city name above';

  @override
  String get temperatureUnit => '°C';

  @override
  String get citySelection => 'City Selection';

  @override
  String get select => 'Select';

  @override
  String get detectLocation => 'Detect by location';

  @override
  String get error => 'Error';

  @override
  String get enterCityPrompt => 'Enter city and press \'Search\'';

  @override
  String get sevenDayForecast => '7-day Forecast';

  @override
  String get humidity => 'Humidity';

  @override
  String get pressure => 'Pressure';

  @override
  String get wind => 'Wind';

  @override
  String get cloudiness => 'Cloudiness';

  @override
  String get feelsLike => 'Feels like';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get unableToDetectLocation => 'Unable to detect location';

  @override
  String get cityNotFound => 'City not found';

  @override
  String geocodingError(Object code) {
    return 'Geocoding error: $code';
  }

  @override
  String forecastError(Object code) {
    return 'Forecast error: $code';
  }

  @override
  String weatherError(Object code) {
    return 'Weather error: $code';
  }
}
