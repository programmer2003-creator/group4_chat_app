import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  // Initialize the shared preferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Save a string value
  Future<bool> saveString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  // Get a string value
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  // Remove a value
  Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  // Clear all values
  Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }
}
