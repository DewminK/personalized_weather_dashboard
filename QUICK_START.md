# Personalized Weather Dashboard - Quick Start Guide

## 🎯 Project Overview

A Flutter mobile app that calculates geographic coordinates from student index **224036T** and fetches real-time weather data from Open-Meteo API.

## 📍 Your Coordinates

- **Student Index**: 224036T
- **Latitude**: 7.20° (from digits 22: 5 + 22/10)
- **Longitude**: 83.40° (from digits 40: 79 + 40/10)
- **Location**: Central Sri Lanka

## 🚀 How to Run

### Option 1: Quick Run
```bash
cd "d:\UoM\Modules\L3S1\Wireless Communication\Mobile App\Submission\personalized_weather_dashboard"
flutter run
```

### Option 2: Run on Specific Device
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

### Option 3: Build APK (Android)
```bash
flutter build apk
# APK location: build/app/outputs/flutter-apk/app-release.apk
```

## 📱 Using the App

1. **Launch** - App opens with pre-filled index "224036T"
2. **Tap "Fetch Weather"** - Fetches current weather for your coordinates
3. **View Results**:
   - Computed coordinates (7.20°, 83.40°)
   - Temperature in °C
   - Wind speed in km/h
   - Weather condition
   - Last update time
   - Complete API request URL

4. **Offline Mode** - Cached data automatically loads when offline

## 🌐 API Information

**Service**: Open-Meteo (Free, No API Key)
**URL**: `https://api.open-meteo.com/v1/forecast?latitude=7.2&longitude=83.4&current_weather=true`

## 📂 Project Structure

```
lib/
├── main.dart                    # Entry point
├── models/                      # Data models
│   ├── coordinates.dart        # Coordinate calculation
│   └── weather_data.dart       # Weather data structure
├── services/                    # Business logic
│   ├── weather_service.dart    # API calls
│   └── cache_service.dart      # Local storage
├── screens/                     # UI screens
│   └── weather_screen.dart     # Main screen
└── widgets/                     # Reusable components
    ├── coordinates_display.dart
    ├── weather_display.dart
    └── request_url_display.dart
```

## ✅ Features Implemented

✅ Student index input (pre-filled: 224036T)
✅ Coordinate calculation (Lat: 7.20°, Lon: 83.40°)
✅ Weather API integration (Open-Meteo)
✅ Temperature, wind speed, weather code display
✅ Last update timestamp
✅ Request URL display (for verification)
✅ Loading indicator
✅ Error handling with dialogs
✅ Offline caching (shared_preferences)
✅ "(cached)" indicator for offline data

## 🔧 Dependencies

```yaml
dependencies:
  http: ^1.1.0                 # API requests
  shared_preferences: ^2.2.2   # Local caching
  intl: ^0.19.0                # Date formatting
```

## 📊 Testing Checklist

### ✅ Test 1: Normal Fetch
1. Open app
2. Tap "Fetch Weather"
3. Verify coordinates: 7.20°, 83.40°
4. Verify weather data appears
5. Verify URL is displayed

### ✅ Test 2: Offline Mode
1. Fetch weather (online)
2. Close app
3. Turn off internet
4. Reopen app
5. Verify cached data loads
6. Verify "(cached)" tag appears

### ✅ Test 3: Different Index
1. Change to another index (e.g., 194174B)
2. Tap "Fetch Weather"
3. Verify coordinates change
4. Verify new weather data

### ✅ Test 4: Error Handling
1. Turn off internet
2. Tap "Fetch Weather"
3. Verify error dialog appears
4. Tap OK to dismiss

## 📝 Documentation Files

- **PROJECT_README.md** - Comprehensive project documentation
- **FILE_STRUCTURE.md** - Detailed file structure and architecture
- **FEATURES_CHECKLIST.md** - Complete feature implementation list
- **QUICK_START.md** - This file

## 🎨 UI Features

- Material Design 3
- Blue color scheme
- Card-based layout
- Icon indicators for each metric
- Scrollable content
- Copy-to-clipboard for URL
- Responsive design

## 🔢 Coordinate Formula

```dart
// Example: Index "224036T"
firstTwo = 22
nextTwo = 40

latitude = 5 + (firstTwo / 10.0)    // 5 + 2.2 = 7.20°
longitude = 79 + (nextTwo / 10.0)   // 79 + 4.0 = 83.40°
```

## 🌤️ Weather Codes

The app interprets WMO weather codes:
- 0: Clear sky
- 1-3: Partly cloudy
- 45-48: Foggy
- 51-55: Drizzle
- 61-65: Rain
- 71-75: Snow
- 80-82: Rain showers
- 95: Thunderstorm
- 96-99: Thunderstorm with hail

## 💡 Tips

- **Pre-filled Index**: The app remembers your last used index
- **Copy URL**: Tap the copy button to share the API URL
- **Offline First**: App always tries to load cached data on startup
- **Error Recovery**: You can retry fetch after fixing network issues

## 🐛 Troubleshooting

### App won't build?
```bash
flutter clean
flutter pub get
flutter run
```

### Device not detected?
```bash
flutter devices
# Ensure emulator is running or device is connected
```

### Network errors?
- Check internet connection
- Verify Open-Meteo API is accessible
- Try in a browser first: https://api.open-meteo.com/v1/forecast?latitude=7.2&longitude=83.4&current_weather=true

### Cache not working?
- The app uses SharedPreferences
- Data persists between app restarts
- Close and reopen app to test

## 📞 Support

For issues or questions about the implementation:
1. Check PROJECT_README.md for detailed documentation
2. Review FILE_STRUCTURE.md to understand the architecture
3. Examine inline code comments in each file

## ✨ Project Status

**Status**: ✅ COMPLETE
**All Required Features**: ✅ IMPLEMENTED
**Testing**: ✅ VERIFIED
**Documentation**: ✅ COMPREHENSIVE

The app is ready for demonstration and submission!
