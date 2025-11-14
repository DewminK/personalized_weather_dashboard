import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';

/// Service class for caching weather data locally
class CacheService {
  static const String _weatherCacheKey = 'cached_weather_data';
  static const String _indexCacheKey = 'cached_student_index';

  /// Save weather data to cache
  Future<void> cacheWeatherData(
    WeatherData weatherData,
    String studentIndex,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(weatherData.toJson());
      await prefs.setString(_weatherCacheKey, jsonString);
      await prefs.setString(_indexCacheKey, studentIndex);
    } catch (e) {
      print('Error caching weather data: $e');
    }
  }

  /// Get cached weather data
  Future<WeatherData?> getCachedWeatherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_weatherCacheKey);

      if (jsonString != null) {
        final jsonData = json.decode(jsonString);
        return WeatherData.fromCachedJson(jsonData);
      }
    } catch (e) {
      print('Error loading cached weather data: $e');
    }
    return null;
  }

  /// Get cached student index
  Future<String?> getCachedStudentIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_indexCacheKey);
    } catch (e) {
      print('Error loading cached student index: $e');
    }
    return null;
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_weatherCacheKey);
      await prefs.remove(_indexCacheKey);
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }
}
