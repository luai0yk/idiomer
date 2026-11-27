import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CashService {
  CashService._();

  static final CashService instance = CashService._();

  factory CashService() => instance;

  SharedPreferences? _prefs;

  bool get isInitialized => _prefs != null;

  /// Initialize the CashService.
  /// Optionally accepts [SharedPreferences] for testing/mocking.
  Future<CashService> init([SharedPreferences? prefs]) async {
    _prefs = prefs ?? await SharedPreferences.getInstance();
    return this;
  }

  /// Check if key exists
  bool contains(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  /// Reload values from native storage
  Future<void> reload() async {
    await _prefs?.reload();
  }

  /// Remove value
  Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  /// Clear all values
  Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }

  /// Set string value
  Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  /// Get string value
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Set bool value
  Future<bool> setBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  /// Get bool value
  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  /// Set int value
  Future<bool> setInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }

  /// Get int value
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// Set double value
  Future<bool> setDouble(String key, double value) async {
    return await _prefs?.setDouble(key, value) ?? false;
  }

  /// Get double value
  double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  /// Set string list value
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs?.setStringList(key, value) ?? false;
  }

  /// Get string list value
  List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  /// Save json model
  Future<bool> setModel(String key, Map<String, dynamic> json) async {
    final jsonString = jsonEncode(json);

    return await _prefs?.setString(key, jsonString) ?? false;
  }

  /// Get json model
  T? getModel<T>(String key, T Function(Map<String, dynamic> json) fromJson) {
    final jsonString = _prefs?.getString(key);

    if (jsonString == null) {
      return null;
    }

    try {
      final decoded = jsonDecode(jsonString);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      return fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}
