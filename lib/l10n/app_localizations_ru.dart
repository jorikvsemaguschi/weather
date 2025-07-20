// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get title => 'Приложение погоды';

  @override
  String get settings => 'Настройки';

  @override
  String get city => 'Город';

  @override
  String get temperatureInC => 'Температура в Цельсиях';

  @override
  String get language => 'Язык';

  @override
  String get enterCity => 'Введите город';

  @override
  String get search => 'Поиск';

  @override
  String get inputPrompt =>
      'Пожалуйста, выберите город, нажав на название города выше';

  @override
  String get temperatureUnit => '°C';

  @override
  String get citySelection => 'Выбор города';

  @override
  String get select => 'Выбрать';

  @override
  String get detectLocation => 'Определить по геолокации';

  @override
  String get error => 'Ошибка';

  @override
  String get enterCityPrompt => 'Введите город и нажмите \'Поиск\'';

  @override
  String get sevenDayForecast => 'Прогноз на 7 дней';

  @override
  String get humidity => 'Влажность';

  @override
  String get pressure => 'Давление';

  @override
  String get wind => 'Ветер';

  @override
  String get cloudiness => 'Облачность';

  @override
  String get feelsLike => 'Ощущается как';

  @override
  String get darkTheme => 'Темная тема';

  @override
  String get unableToDetectLocation => 'Не удалось определить местоположение';

  @override
  String get cityNotFound => 'Город не найден';

  @override
  String geocodingError(Object code) {
    return 'Ошибка геокодинга: $code';
  }

  @override
  String forecastError(Object code) {
    return 'Ошибка получения прогноза: $code';
  }

  @override
  String weatherError(Object code) {
    return 'Ошибка получения погоды: $code';
  }
}
