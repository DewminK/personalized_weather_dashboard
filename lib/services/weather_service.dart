import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';
import '../models/coordinates.dart';

class WeatherService {
  static const String baseUrl = 'https://api.open-meteo.com/v1/forecast';


  static String buildRequestUrl(Coordinates coordinates) {
    return '$baseUrl?latitude=${coordinates.latitude}&longitude=${coordinates.longitude}&current_weather=true';
  }

  Future<WeatherData> fetchWeather(Coordinates coordinates) async {
    final url = buildRequestUrl(coordinates);

    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Accept': 'application/json'})
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Connection timeout. Please check your internet connection and try again.',
              );
            },
          );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return WeatherData.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw Exception('Weather data not found for the specified location.');
      } else if (response.statusCode >= 500) {
        throw Exception(
          'Weather service is temporarily unavailable. Please try again later.',
        );
      } else {
        throw Exception(
          'Failed to load weather data (Error ${response.statusCode})',
        );
      }
    } on TimeoutException {
      throw Exception(
        'Connection timeout. The request took too long. Please try again.',
      );
    } on SocketException {
      throw Exception(
        'No internet connection. Please check your network settings and try again.\n\nThe app will display cached data if available.',
      );
    } on FormatException {
      throw Exception(
        'Invalid response from weather service. Please try again later.',
      );
    } on http.ClientException catch (e) {
      if (e.message.contains('Failed host lookup')) {
        throw Exception(
          'Cannot reach weather service. Please check your internet connection.\n\nIf you\'re offline, the app will show cached data if available.',
        );
      }
      throw Exception(
        'Network error: Unable to connect to weather service.\n\nPlease check your internet connection and try again.',
      );
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Unexpected error: ${e.toString()}');
    }
  }
}
