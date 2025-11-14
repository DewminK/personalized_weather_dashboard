# Project File Structure

```
personalized_weather_dashboard/
│
├── android/                           # Android platform code
│   ├── app/
│   │   ├── src/
│   │   └── build.gradle.kts
│   ├── build.gradle.kts
│   ├── settings.gradle.kts
│   └── ...
│
├── ios/                               # iOS platform code
│   ├── Runner/
│   └── ...
│
├── lib/                               # Main Flutter application code
│   │
│   ├── main.dart                      # Application entry point
│   │   └── Initializes MaterialApp
│   │   └── Sets up theme
│   │   └── Navigates to WeatherScreen
│   │
│   ├── models/                        # Data models
│   │   ├── coordinates.dart
│   │   │   └── Coordinates class
│   │   │   └── Factory: fromStudentIndex()
│   │   │   └── Calculates lat/lon from student index
│   │   │
│   │   └── weather_data.dart
│   │       └── WeatherData class
│   │       └── Factory: fromJson() (API response)
│   │       └── Factory: fromCachedJson() (local cache)
│   │       └── Method: toJson() (for caching)
│   │       └── Getter: weatherDescription (WMO code interpretation)
│   │
│   ├── services/                      # Business logic services
│   │   ├── weather_service.dart
│   │   │   └── WeatherService class
│   │   │   └── Method: buildRequestUrl()
│   │   │   └── Method: fetchWeather()
│   │   │   └── Makes HTTP GET requests to Open-Meteo API
│   │   │
│   │   └── cache_service.dart
│   │       └── CacheService class
│   │       └── Method: cacheWeatherData()
│   │       └── Method: getCachedWeatherData()
│   │       └── Method: getCachedStudentIndex()
│   │       └── Method: clearCache()
│   │       └── Uses SharedPreferences for persistence
│   │
│   ├── screens/                       # UI screens
│   │   └── weather_screen.dart
│   │       └── WeatherScreen (StatefulWidget)
│   │       └── Main application screen
│   │       └── Contains:
│   │           - Text input for student index
│   │           - Fetch Weather button
│   │           - Loading indicator
│   │           - Error handling
│   │           - Displays all widgets below
│   │
│   └── widgets/                       # Reusable UI components
│       ├── coordinates_display.dart
│       │   └── CoordinatesDisplay widget
│       │   └── Shows computed latitude/longitude
│       │   └── Formatted to 2 decimal places
│       │
│       ├── weather_display.dart
│       │   └── WeatherDisplay widget
│       │   └── Shows:
│       │       - Temperature
│       │       - Wind speed
│       │       - Weather condition
│       │       - Last update time
│       │       - "(cached)" tag if applicable
│       │
│       └── request_url_display.dart
│           └── RequestUrlDisplay widget
│           └── Shows API request URL
│           └── Includes copy-to-clipboard functionality
│
├── test/                              # Unit tests
│   └── widget_test.dart
│
├── web/                               # Web platform code
├── windows/                           # Windows platform code
├── linux/                             # Linux platform code
├── macos/                             # macOS platform code
│
├── analysis_options.yaml              # Dart linter configuration
├── pubspec.yaml                       # Project dependencies
├── README.md                          # Original Flutter README
└── PROJECT_README.md                  # Custom project documentation

```

## File Purposes and Responsibilities

### 1. **main.dart**
- **Purpose**: Application entry point
- **Responsibilities**:
  - Initialize MaterialApp
  - Configure theme (Material 3, blue color scheme)
  - Set up routing to WeatherScreen

### 2. **models/coordinates.dart**
- **Purpose**: Coordinate calculation logic
- **Responsibilities**:
  - Store latitude and longitude
  - Derive coordinates from student index using formula
  - Format coordinates for display (2 decimals)

### 3. **models/weather_data.dart**
- **Purpose**: Weather data representation
- **Responsibilities**:
  - Store weather information (temp, wind, code)
  - Parse API JSON response
  - Serialize/deserialize for caching
  - Interpret WMO weather codes

### 4. **services/weather_service.dart**
- **Purpose**: API communication
- **Responsibilities**:
  - Build Open-Meteo API URLs
  - Make HTTP requests
  - Handle network errors
  - Parse API responses

### 5. **services/cache_service.dart**
- **Purpose**: Local data persistence
- **Responsibilities**:
  - Save weather data locally
  - Retrieve cached data
  - Save/retrieve student index
  - Clear cache when needed

### 6. **screens/weather_screen.dart**
- **Purpose**: Main UI screen
- **Responsibilities**:
  - Manage application state
  - Handle user input
  - Coordinate between services and widgets
  - Display loading states
  - Show error dialogs
  - Load cached data on startup

### 7. **widgets/coordinates_display.dart**
- **Purpose**: Display coordinates
- **Responsibilities**:
  - Show latitude and longitude
  - Format numbers to 2 decimals
  - Provide visual indicators (icons)

### 8. **widgets/weather_display.dart**
- **Purpose**: Display weather information
- **Responsibilities**:
  - Show temperature, wind speed, weather condition
  - Display last update timestamp
  - Show "(cached)" indicator
  - Format data for readability

### 9. **widgets/request_url_display.dart**
- **Purpose**: Display API request URL
- **Responsibilities**:
  - Show full URL for verification
  - Enable URL copying to clipboard
  - Format URL in monospace font

## Data Flow

```
User Input (Index)
    ↓
Coordinates Model (Calculate lat/lon)
    ↓
Weather Service (Build URL, Fetch Data)
    ↓
Weather Data Model (Parse JSON)
    ↓
Cache Service (Save Locally)
    ↓
Weather Screen (Update State)
    ↓
Widgets (Display to User)
```

## Key Design Decisions

1. **Separation of Concerns**: Models, Services, Screens, and Widgets are separated
2. **Reusable Components**: Widgets are modular and reusable
3. **Service Layer**: Business logic is separated from UI
4. **State Management**: Using StatefulWidget with setState
5. **Error Handling**: Try-catch blocks with user-friendly dialogs
6. **Caching Strategy**: Automatic save on success, load on startup
7. **Material Design 3**: Modern UI with cards and proper spacing

## Dependencies Explained

- **http**: Makes HTTP requests to Open-Meteo API
- **shared_preferences**: Stores data persistently on device
- **intl**: Formats dates and times consistently

## Formula Implementation

The coordinate derivation formula is implemented in `models/coordinates.dart`:

```dart
factory Coordinates.fromStudentIndex(String index) {
  final firstTwo = int.parse(index.substring(0, 2));  // e.g., 22
  final nextTwo = int.parse(index.substring(2, 4));   // e.g., 40
  
  final latitude = 5.0 + (firstTwo / 10.0);           // 7.2
  final longitude = 79.0 + (nextTwo / 10.0);          // 83.4
  
  return Coordinates(latitude: latitude, longitude: longitude);
}
```

For student index **224036T**:
- First two digits: **22**
- Next two digits: **40**
- Latitude: 5 + 2.2 = **7.20°**
- Longitude: 79 + 4.0 = **83.40°**
