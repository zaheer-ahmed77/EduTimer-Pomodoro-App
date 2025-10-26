import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _focusKey = 'focus_duration';
  static const String _breakKey = 'break_duration';

  Future<void> saveSettings(int focusMinutes, int breakMinutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_focusKey, focusMinutes);
    await prefs.setInt(_breakKey, breakMinutes);
  }

  Future<Map<String, int>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    int focusMinutes = prefs.getInt(_focusKey) ?? 25;

    int breakMinutes = prefs.getInt(_breakKey) ?? 5;

    return {'focus': focusMinutes, 'break': breakMinutes};
  }
}
