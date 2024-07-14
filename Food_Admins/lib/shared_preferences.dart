import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserId(int userId) async {
    await _preferences?.setInt('userId', userId);
  }

  static int getUserId() {
    return _preferences?.getInt('userId') ?? 0;
  }

  static Future clearUserId() async {
    await _preferences?.remove('userId');
  }
}
