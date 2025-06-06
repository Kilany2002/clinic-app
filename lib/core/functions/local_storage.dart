import 'package:shared_preferences/shared_preferences.dart';

class AppLocalStorage {
  static String token = "token";

  static late SharedPreferences _sharedPreferences;


  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static cacheData({required String key, required dynamic value}) async {
    if (value is String) {
      await _sharedPreferences.setString(key, value);
    } else if (value is int) {
      await _sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      await _sharedPreferences.setBool(key, value);
    } else if (value is double) {
      await _sharedPreferences.setDouble(key, value);
    } else {
      await _sharedPreferences.setStringList(key, value);
    }
  }

  static dynamic getCachData({required String key}) {
    return _sharedPreferences.get(key);
  }

  static getUserData() {}
}
