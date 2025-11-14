import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_data.dart';

/// Widget to display weather information
class WeatherDisplay extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDisplay({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Weather',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (weatherData.isCached)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '(cached)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Temperature
            _buildWeatherRow(
              Icons.thermostat,
              'Temperature',
              '${weatherData.temperature.toStringAsFixed(1)}°C',
              Colors.red,
            ),
            const Divider(height: 24),

            // Wind Speed
            _buildWeatherRow(
              Icons.air,
              'Wind Speed',
              '${weatherData.windSpeed.toStringAsFixed(1)} km/h',
              Colors.blue,
            ),
            const Divider(height: 24),

            // Weather Code
            _buildWeatherRow(
              Icons.wb_sunny,
              'Weather',
              '${weatherData.weatherDescription} (Code: ${weatherData.weatherCode})',
              Colors.orange,
            ),
            const Divider(height: 24),

            // Last Updated
            _buildWeatherRow(
              Icons.access_time,
              'Last Updated',
              dateFormat.format(weatherData.lastUpdated),
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
