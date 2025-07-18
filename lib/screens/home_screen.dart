import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../utils/weather_lottie.dart';
import 'city_selector_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();

  Weather? _weather;
  List<DailyWeather>? _dailyForecast;

  bool _isLoading = false;
  String _city = "Minsk";

  final TextEditingController _controller = TextEditingController(text: "Minsk");

  @override
  void initState() {
    super.initState();
    _fetchWeatherAndForecast(_city);
  }

  Future<void> _fetchWeatherAndForecast(String cityName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherService.fetchWeather(cityName);
      final forecast = await _weatherService.fetch7DayForecast(cityName);
      setState(() {
        _weather = weather;
        _dailyForecast = forecast;
        _city = cityName;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

  }

  void _openCitySelector() async {
    final selectedCity = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const CitySelectorScreen()),
    );

    if (selectedCity != null && selectedCity.isNotEmpty) {
      _fetchWeatherAndForecast(selectedCity);
    }
  }

  Widget _buildCurrentWeather() {
    if (_weather == null) {
      return const Text("Введите город и нажмите 'Поиск'");
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          getLottieAnimation(_weather!.mainCondition),
          width: 150,
          height: 150,
        ),
        const SizedBox(height: 16),
        Text(
          '${_weather!.temperature.toStringAsFixed(1)}°C',
          style: const TextStyle(fontSize: 48),
        ),
        const SizedBox(height: 8),
        Text(
          _weather!.mainCondition,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 16),
        _buildAdditionalWeatherDetails(),
      ],
    );
  }

  Widget _buildDailyForecast() {
    if (_dailyForecast == null) {
      return const SizedBox.shrink();
    }

    return Expanded(
      key: Key(_city), // Добавляем ключ
      child: ListView.separated(
        itemCount: _dailyForecast!.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final day = _dailyForecast![index];
          final date = DateFormat('EEE, dd MMM').format(
              DateTime.fromMillisecondsSinceEpoch(day.dt * 1000));

          return ListTile(
            key: ValueKey('${_city}_$index'), // ключ для всего ListTile, зависит от города и позиции
            leading: SizedBox(
              width: 50,
              height: 50,
              child: Lottie.asset(
                getLottieAnimation(day.mainCondition),
                key: ValueKey('${_city}_lottie_$index'), // ключ для анимации
              ),
            ),
            title: Text(
              date,
              key: ValueKey('${_city}_date_$index'),
            ),
            trailing: Text(
              '${day.temperature.toStringAsFixed(1)}°C',
              key: ValueKey('${_city}_temp_$index'),
            ),
            subtitle: Text(
              day.mainCondition,
              key: ValueKey('${_city}_cond_$index'),
            ),
          );
        },
      ),
    );
  }


  Widget _buildAdditionalWeatherDetails() {
    if (_weather == null) return const SizedBox.shrink();

    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _infoColumn('Влажность', '${_weather!.humidity} %', Icons.opacity),
            _infoColumn('Давление', '${_weather!.pressure} гПа', Icons.speed),
            _infoColumn('Ветер', '${_weather!.windSpeed.toStringAsFixed(1)} м/с', Icons.air),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _infoColumn('Облачность', '${_weather!.clouds} %', Icons.cloud),
            _infoColumn('Ощущается как', '${_weather!.feelsLike.toStringAsFixed(1)}°C', Icons.thermostat),
          ],
        ),
      ],
    );
  }

  Widget _infoColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCurrentWeather(),
            const SizedBox(height: 16),
            const Text(
              'Прогноз на 7 дней',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            _buildDailyForecast(),
          ],
        ),
      ),
    );
  }
}
