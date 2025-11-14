import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/coordinates.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';
import '../services/cache_service.dart';
import '../widgets/weather_display.dart';
import '../widgets/coordinates_display.dart';


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
  bool _isDataFromCache = false;

  @override
  void initState() {
    super.initState();
    _loadCachedData();
  }

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
        _isDataFromCache = true;
      });
    }
  }

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
        _isDataFromCache = false;
      });
    } catch (e) {
      // Try to load cached data on error
      final cachedWeather = await _cacheService.getCachedWeatherData();
      final cachedIndex = await _cacheService.getCachedStudentIndex();

      setState(() {
        _isLoading = false;

        // If we have cached data, update to show it
        if (cachedWeather != null && cachedIndex != null) {
          _weatherData = cachedWeather;
          _isDataFromCache = true;
          try {
            _coordinates = Coordinates.fromStudentIndex(cachedIndex);
            _requestUrl = WeatherService.buildRequestUrl(_coordinates!);
          } catch (_) {
            // Ignore coordinate calculation errors
          }
        }
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

  /// Clear all cached data and reset display
  Future<void> _clearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Clear All Data'),
          ],
        ),
        content: const Text(
          'Are you sure you want to clear all cached data and reset the display?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _cacheService.clearCache();
      setState(() {
        _coordinates = null;
        _weatherData = null;
        _requestUrl = null;
        _isDataFromCache = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Build request URL preview widget
  Widget _buildRequestUrlPreview() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Request URL:',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: _requestUrl!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('URL copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy, size: 12, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Copy',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SelectableText(
            _requestUrl!,
            style: const TextStyle(
              fontSize: 9,
              fontFamily: 'monospace',
              color: Colors.black87,
              height: 1.3,
            ),
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
        title: const Text(
          'Personalized Weather Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          if (_weatherData != null || _coordinates != null)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear All Data',
              onPressed: _clearData,
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[700]!,
              Colors.blue[50]!,
              Colors.white,
            ],
            stops: const [0.0, 0.3, 0.5],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Student Index Input Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.blue[700],
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'My Index',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _indexController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
                          ),
                          hintText: 'Enter your student index (e.g., 224036T)',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(Icons.badge, color: Colors.blue[700]),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _fetchWeather,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.cloud_download, size: 24),
                          label: Text(
                            _isLoading ? 'Fetching Weather...' : 'Fetch Weather',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      // Display Request URL right after the button (tiny text)
                      if (_requestUrl != null) ...[
                        const SizedBox(height: 16),
                        _buildRequestUrlPreview(),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Coordinates Display
              if (_coordinates != null)
                CoordinatesDisplay(coordinates: _coordinates!),

              const SizedBox(height: 20),

              // Weather Display
              if (_weatherData != null)
                WeatherDisplay(
                  weatherData: _weatherData!,
                  isCached: _isDataFromCache,
                ),

              const SizedBox(height: 20),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
