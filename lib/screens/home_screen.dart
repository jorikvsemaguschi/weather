import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../utils/weather_lottie.dart';
import 'city_selector_screen.dart';
import 'settings_screen.dart';
import '../l10n/app_localizations.dart';





class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = false;
  final TextEditingController _controller = TextEditingController(text: "Minsk");
  String _city = "Minsk";

  @override
  void initState() {
    super.initState();
    _fetchWeather(_city);
  }

  Future<void> _fetchWeather(String cityName) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final weather = await _weatherService.fetchWeather(cityName);
      setState(() {
        _weather = weather;
        _city = cityName;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.error(e.toString()),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) {
      _fetchWeather(city);
      FocusScope.of(context).unfocus(); // Скрыть клавиатуру
    }
  }

  void _openCitySelector() async {
    final selectedCity = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const CitySelectorScreen()),
    );

    if (selectedCity != null && selectedCity.isNotEmpty) {
      _fetchWeather(selectedCity);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _openCitySelector,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 8),
              Text(_city),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : _weather == null
                    ? Text(AppLocalizations.of(context)!.inputPrompt)
                    : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      getLottieAnimation(_weather!.mainCondition),
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_weather!.temperature.toStringAsFixed(1)}${AppLocalizations.of(context)!.temperatureUnit}',
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _weather!.mainCondition,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
