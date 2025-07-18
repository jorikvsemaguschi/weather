import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';
import '../main.dart'; // для доступа к MyApp.of(context)

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isCelsius = true;
  String _language = 'ru';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings), // локализация заголовка
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text(localizations.temperatureInC), // локализация переключателя
            value: _isCelsius,
            onChanged: (val) {
              setState(() {
                _isCelsius = val;
              });
            },
          ),
          const SizedBox(height: 20),
          Text(
            localizations.language, // подпись "Язык"
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: _language,
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _language = val;
                });
                MyApp.of(context)?.setLocale(Locale(val));
              }
            },
            items: [
              DropdownMenuItem(
                value: 'ru',
                child: Text('Русский'),
              ),
              DropdownMenuItem(
                value: 'en',
                child: Text('English'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
