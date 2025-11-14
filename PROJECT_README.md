# Personalized Weather Dashboard

A Flutter mobile application that derives geographic coordinates from a student index and fetches weather data from the Open-Meteo API.

## Student Information
- **Student Index**: 224036T
- **Computed Coordinates**:
  - Latitude: 7.20° (from digits 22: 5 + 22/10)
  - Longitude: 83.40° (from digits 40: 79 + 40/10)

## Features

### Core Functionality
✅ **Student Index Input**: Text field to enter student index (pre-filled with 224036T)

✅ **Coordinate Derivation**: Automatically calculates latitude and longitude from index
- Formula: 
  - `lat = 5 + (first_two_digits / 10.0)`
  - `lon = 79 + (next_two_digits / 10.0)`
- Displays coordinates with 2 decimal precision

✅ **Weather Fetching**: "Fetch Weather" button calls Open-Meteo API
- Shows loading indicator during fetch
- Displays temperature (°C)
- Shows wind speed (km/h)
- Shows weather code with description

✅ **Request URL Display**: Shows the exact API request URL on screen for verification

✅ **Last Update Time**: Displays when weather data was last fetched

✅ **Error Handling**: Friendly error dialogs if fetch fails

✅ **Offline Caching**: 
- Caches last successful result using `shared_preferences`
- Shows "(cached)" tag when displaying offline data
- App shows cached weather on startup if available

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── models/
│   ├── coordinates.dart               # Coordinates model with derivation logic
│   └── weather_data.dart              # Weather data model
├── services/
│   ├── weather_service.dart           # Weather API service
│   └── cache_service.dart             # Local caching service
├── screens/
│   └── weather_screen.dart            # Main weather screen
└── widgets/
    ├── coordinates_display.dart       # Coordinates display widget
    ├── weather_display.dart           # Weather information widget
    └── request_url_display.dart       # API URL display widget
```

## Dependencies

- `http: ^1.1.0` - For making HTTP requests to Open-Meteo API
- `shared_preferences: ^2.2.2` - For local data caching
- `intl: ^0.19.0` - For date/time formatting

## Weather API

**API**: Open-Meteo (No API key required)
**Endpoint**: `https://api.open-meteo.com/v1/forecast`

**Parameters**:
- `latitude`: Derived from student index
- `longitude`: Derived from student index
- `current_weather`: true

**Example Request**:
```
https://api.open-meteo.com/v1/forecast?latitude=7.2&longitude=83.4&current_weather=true
```

## How to Run

1. Ensure Flutter SDK is installed
2. Navigate to project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Usage Instructions

1. **Launch the app** - It will automatically load cached data if available
2. **Verify/Edit student index** - The index field is pre-filled with 224036T
3. **Tap "Fetch Weather"** - This will:
   - Calculate coordinates from the index
   - Call the Open-Meteo API
   - Display current weather data
   - Cache the result for offline use
4. **View results**:
   - Computed coordinates
   - Temperature, wind speed, and weather conditions
   - Last update timestamp
   - Complete API request URL
5. **Test offline mode**: 
   - Fetch weather once while online
   - Turn off internet
   - Restart app to see cached data with "(cached)" tag

## Weather Code Descriptions

The app interprets WMO weather codes:
- 0: Clear sky
- 1-3: Partly cloudy
- 45-48: Foggy
- 51-55: Drizzle
- 61-65: Rain
- 71-75: Snow
- 80-82: Rain showers
- 85-86: Snow showers
- 95: Thunderstorm
- 96-99: Thunderstorm with hail

## Error Handling

The app handles various error scenarios:
- Invalid student index format
- Network connectivity issues
- API failures
- Data parsing errors

All errors are displayed in user-friendly dialog boxes.

## Technical Implementation Details

### Coordinate Derivation Algorithm
```dart
// Example: Index "224036T"
final firstTwo = int.parse(index.substring(0, 2));  // 22
final nextTwo = int.parse(index.substring(2, 4));   // 40
final latitude = 5.0 + (firstTwo / 10.0);           // 7.2
final longitude = 79.0 + (nextTwo / 10.0);          // 83.4
```

### Caching Strategy
- Uses `shared_preferences` for persistent storage
- Caches both weather data and student index
- Marks cached data with visual indicator
- Loads cache on app startup
- Updates cache on successful API fetch

### UI/UX Features
- Material Design 3 with blue color scheme
- Card-based layout for organized information
- Loading indicators during API calls
- Selectable text for URL (can be copied)
- Copy-to-clipboard button for request URL
- Icon-based visual indicators for weather properties

## Platform Support

This app supports:
- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ✅ Web

## License

This is a student project for academic purposes.
