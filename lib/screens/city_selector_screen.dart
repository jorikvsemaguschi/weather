import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/location_service.dart'; // <-- добавь импорт

class CitySelectorScreen extends StatefulWidget {
  const CitySelectorScreen({super.key});

  @override
  State<CitySelectorScreen> createState() => _CitySelectorScreenState();
}

class _CitySelectorScreenState extends State<CitySelectorScreen> {
  final TextEditingController _controller = TextEditingController();

  void _submitCity() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) {
      Navigator.pop(context, city);
    }
  }

  Future<void> _detectLocation() async {
    final city = await LocationService().getCurrentCity();
    if (city != null) {
      Navigator.pop(context, city);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to detect location")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.citySelection)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: localizations.enterCity,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submitCity(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitCity,
              child: Text(localizations.select),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _detectLocation,
              icon: const Icon(Icons.my_location),
              label: Text(localizations.detectLocation),
            ),
          ],
        ),
      ),
    );
  }
}

