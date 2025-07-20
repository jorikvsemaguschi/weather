import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../main.dart'; 

// Экран настроек приложения
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'ru';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Загрузка языка из SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('settings_language');
    if (lang != null) {
      setState(() {
        _language = lang;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          // Выбор языка
          Text(
            localizations.language,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: _language,
            onChanged: (val) async {
              if (val != null) {
                setState(() {
                  _language = val;
                });
                MyApp.of(context)?.setLocale(Locale(val));
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('settings_language', val);
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
          const SizedBox(height: 32),
          // Переключатель темы
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations.darkTheme, style: const TextStyle(fontWeight: FontWeight.bold)),
              Switch(
                value: isDark,
                onChanged: (val) {
                  MyApp.of(context)?.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
