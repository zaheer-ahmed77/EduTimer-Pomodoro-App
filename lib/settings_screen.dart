import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'settings_service.dart';
import 'app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _focusController = TextEditingController();
  final TextEditingController _breakController = TextEditingController();

  final SettingsService _settingsService = SettingsService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _focusController.dispose();
    _breakController.dispose();
    super.dispose();
  }

  void _loadSettings() async {
    setState(() => _isLoading = true);
    final settings = await _settingsService.loadSettings();
    setState(() {
      _focusController.text = settings['focus'].toString();
      _breakController.text = settings['break'].toString();
      _isLoading = false;
    });
  }

  void _saveSettings() async {
    int focusMinutes = int.tryParse(_focusController.text) ?? 25;
    int breakMinutes = int.tryParse(_breakController.text) ?? 5;

    await _settingsService.saveSettings(focusMinutes, breakMinutes);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryDarkText,
              ),
            ) // CHANGE: Color
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Focus Duration (minutes)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryDarkText,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _focusController,

                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),

                  const SizedBox(height: 30),

                  Text(
                    'Break Duration (minutes)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryDarkText,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _breakController,

                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: ElevatedButton(
                      onPressed: _saveSettings,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
