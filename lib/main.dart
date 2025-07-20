import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Точка входа в приложение
Future<void> main() async {
  // Инициализация переменных окружения и SharedPreferences
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

// Корневой виджет приложения
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Доступ к состоянию приложения для смены языка/темы и сохранения города
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ru');
  ThemeMode _themeMode = ThemeMode.light;
  String? _lastCity;
  bool _settingsLoaded = false; 

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Загрузка настроек из SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('settings_language');
    final theme = prefs.getString('settings_theme');
    final city = prefs.getString('last_city');
    setState(() {
      if (lang != null) _locale = Locale(lang);
      if (theme == 'dark') _themeMode = ThemeMode.dark;
      if (theme == 'light') _themeMode = ThemeMode.light;
      _lastCity = city;
      _settingsLoaded = true; 
    });
  }

  // Смена языка с сохранением
  void setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_language', locale.languageCode);
  }

  // Смена темы с сохранением
  void setThemeMode(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings_theme', mode == ThemeMode.dark ? 'dark' : 'light');
  }

  // Сохранение последнего выбранного города
  Future<void> saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_city', city);
    setState(() {
      _lastCity = city;
    });
  }

  // Получение последнего выбранного города
  String? get lastCity => _lastCity;

  @override
  Widget build(BuildContext context) {
    if (!_settingsLoaded) {
      // Показываем индикатор загрузки, пока настройки не загружены
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return MaterialApp(
      title: 'Weather App',
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
      ),
      themeMode: _themeMode,
      home: HomeScreen(initialCity: lastCity),
    );
  }
}

