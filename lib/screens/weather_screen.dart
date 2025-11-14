import 'package:flutter/material.dart';
import '../models/coordinates.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';
import '../services/cache_service.dart';
import '../widgets/weather_display.dart';
import '../widgets/coordinates_display.dart';
import '../widgets/request_url_display.dart';

/// Main weather screen
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _indexController = TextEditingController(
    text: '224036T',
  );
  final WeatherService _weatherService = WeatherService();
  final CacheService _cacheService = CacheService();

  Coordinates? _coordinates;
  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _requestUrl;

  @override
  void initState() {
    super.initState();
    _loadCachedData();
  }

  /// Load cached data on app start
  Future<void> _loadCachedData() async {
    final cachedIndex = await _cacheService.getCachedStudentIndex();
    final cachedWeather = await _cacheService.getCachedWeatherData();

    if (cachedIndex != null && cachedWeather != null) {
      setState(() {
        _indexController.text = cachedIndex;
        try {
          _coordinates = Coordinates.fromStudentIndex(cachedIndex);
          _requestUrl = WeatherService.buildRequestUrl(_coordinates!);
        } catch (e) {
          // Ignore coordinate calculation errors on cached data
        }
        _weatherData = cachedWeather;
      });
    }
  }

  /// Fetch weather data
  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Validate and parse student index
      final studentIndex = _indexController.text.trim();
      if (studentIndex.isEmpty) {
        throw Exception('Please enter your student index');
      }

      // Calculate coordinates
      final coordinates = Coordinates.fromStudentIndex(studentIndex);
      final requestUrl = WeatherService.buildRequestUrl(coordinates);

      // Fetch weather data
      final weatherData = await _weatherService.fetchWeather(coordinates);

      // Cache the successful result
      await _cacheService.cacheWeatherData(weatherData, studentIndex);

      setState(() {
        _coordinates = coordinates;
        _weatherData = weatherData;
        _requestUrl = requestUrl;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error dialog
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    // Clean up the error message
    String displayMessage = message.replaceFirst('Exception: ', '');

    // Check if we have cached data
    final hasCachedData = _weatherData != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700]),
            const SizedBox(width: 8),
            const Text('Connection Error'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayMessage, style: const TextStyle(fontSize: 14)),
            if (hasCachedData) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Cached weather data is still available below.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          if (!hasCachedData)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _fetchWeather();
              },
              child: const Text('RETRY'),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _indexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalized Weather Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Student Index Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Student Index',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _indexController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your student index (e.g., 224036T)',
                        prefixIcon: Icon(Icons.person),
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _fetchWeather,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.cloud_download),
                        label: Text(
                          _isLoading ? 'Fetching...' : 'Fetch Weather',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Coordinates Display
            if (_coordinates != null)
              CoordinatesDisplay(coordinates: _coordinates!),

            const SizedBox(height: 16),

            // Weather Display
            if (_weatherData != null)
              WeatherDisplay(weatherData: _weatherData!),

            const SizedBox(height: 16),

            // Request URL Display
            if (_requestUrl != null)
              RequestUrlDisplay(requestUrl: _requestUrl!),
          ],
        ),
      ),
    );
  }
}
