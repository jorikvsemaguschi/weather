import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../utils/weather_lottie.dart';

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
        SnackBar(content: Text('Ошибка: $e')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Погода в $_city')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Введите город',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _onSearch,
                  child: const Text('Поиск'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : _weather == null
                    ? const Text("Введите город и нажмите 'Поиск'")
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
                      '${_weather!.temperature.toStringAsFixed(1)}°C',
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
