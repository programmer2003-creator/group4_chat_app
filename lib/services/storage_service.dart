import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  // Initialize shared preferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save user data (e.g., email or UID)
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Retrieve user data
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Clear specific data
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Clear all data
  Future<void> clear() async {
    await _prefs.clear();
  }
}
