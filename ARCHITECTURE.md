# App Architecture & Data Flow

## Application Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         main.dart                            │
│                     (Entry Point)                            │
│                                                              │
│  - Initializes MaterialApp                                  │
│  - Sets up theme (Material 3, Blue)                         │
│  - Routes to WeatherScreen                                  │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                  screens/weather_screen.dart                 │
│                   (Main UI Controller)                       │
│                                                              │
│  State Management:                                          │
│  - _indexController (TextEditingController)                 │
│  - _coordinates (Coordinates?)                              │
│  - _weatherData (WeatherData?)                              │
│  - _isLoading (bool)                                        │
│  - _requestUrl (String?)                                    │
│                                                              │
│  Lifecycle:                                                 │
│  - initState() → Load cached data                           │
│  - _fetchWeather() → Main fetch logic                       │
│  - _showErrorDialog() → Error handling                      │
└─────┬──────────────┬──────────────┬─────────────────────────┘
      │              │              │
      ▼              ▼              ▼
┌─────────┐    ┌─────────┐    ┌──────────┐
│ Models  │    │Services │    │ Widgets  │
└─────────┘    └─────────┘    └──────────┘
```

## Models Layer

```
┌────────────────────────────┐    ┌─────────────────────────────┐
│   models/coordinates.dart   │    │  models/weather_data.dart   │
├────────────────────────────┤    ├─────────────────────────────┤
│                            │    │                             │
│ Coordinates                │    │ WeatherData                 │
│  - latitude: double        │    │  - temperature: double      │
│  - longitude: double       │    │  - windSpeed: double        │
│                            │    │  - weatherCode: int         │
│ Factory Methods:           │    │  - lastUpdated: DateTime    │
│  + fromStudentIndex()      │    │  - isCached: bool           │
│                            │    │                             │
│ Getters:                   │    │ Factory Methods:            │
│  + latitudeString          │    │  + fromJson()               │
│  + longitudeString         │    │  + fromCachedJson()         │
│                            │    │                             │
│ Formula:                   │    │ Methods:                    │
│  lat = 5 + (first2/10)     │    │  + toJson()                 │
│  lon = 79 + (next2/10)     │    │                             │
│                            │    │ Getters:                    │
│                            │    │  + weatherDescription       │
└────────────────────────────┘    └─────────────────────────────┘
```

## Services Layer

```
┌─────────────────────────────────┐    ┌──────────────────────────────┐
│  services/weather_service.dart   │    │  services/cache_service.dart  │
├─────────────────────────────────┤    ├──────────────────────────────┤
│                                 │    │                              │
│ WeatherService                  │    │ CacheService                 │
│                                 │    │                              │
│ Static Methods:                 │    │ Methods:                     │
│  + buildRequestUrl()            │    │  + cacheWeatherData()        │
│    → Returns URL string         │    │  + getCachedWeatherData()    │
│                                 │    │  + getCachedStudentIndex()   │
│ Instance Methods:               │    │  + clearCache()              │
│  + fetchWeather()               │    │                              │
│    → HTTP GET request           │    │ Storage Keys:                │
│    → Parse JSON                 │    │  - cached_weather_data       │
│    → Return WeatherData         │    │  - cached_student_index      │
│                                 │    │                              │
│ Dependencies:                   │    │ Dependencies:                │
│  - http package                 │    │  - shared_preferences        │
│                                 │    │  - dart:convert              │
└─────────────────────────────────┘    └──────────────────────────────┘
```

## Widgets Layer

```
┌──────────────────────────────────────────────────────────────────┐
│                    widgets/coordinates_display.dart               │
│  CoordinatesDisplay(coordinates: Coordinates)                    │
│  ├─ Card                                                          │
│  │  ├─ Title: "Computed Coordinates"                             │
│  │  └─ Content:                                                  │
│  │     ├─ Icon: location_on (red)                                │
│  │     ├─ Latitude: X.XX°                                        │
│  │     └─ Longitude: Y.YY°                                       │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                    widgets/weather_display.dart                   │
│  WeatherDisplay(weatherData: WeatherData)                        │
│  ├─ Card                                                          │
│  │  ├─ Title: "Current Weather" + "(cached)" badge               │
│  │  └─ Content:                                                  │
│  │     ├─ Temperature: XX.X°C (icon: thermostat, red)            │
│  │     ├─ Wind Speed: XX.X km/h (icon: air, blue)                │
│  │     ├─ Weather: Description (Code: X) (icon: wb_sunny, orange)│
│  │     └─ Last Updated: YYYY-MM-DD HH:MM:SS (icon: time, green)  │
└──────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────┐
│                   widgets/request_url_display.dart                │
│  RequestUrlDisplay(requestUrl: String)                           │
│  ├─ Card                                                          │
│  │  ├─ Title: "Request URL" + Copy button                        │
│  │  └─ Content:                                                  │
│  │     └─ SelectableText: Full API URL (monospace, small font)   │
└──────────────────────────────────────────────────────────────────┘
```

## Data Flow Diagram

```
┌─────────────┐
│    User     │
└──────┬──────┘
       │ 1. Enters Index
       ▼
┌─────────────────────┐
│  Weather Screen     │
│  TextField          │
└──────┬──────────────┘
       │ 2. Tap "Fetch Weather"
       ▼
┌─────────────────────┐
│  Coordinates Model  │
│  Calculate lat/lon  │
└──────┬──────────────┘
       │ 3. Coordinates(7.20, 83.40)
       ▼
┌─────────────────────┐
│  Weather Service    │
│  Build URL          │
└──────┬──────────────┘
       │ 4. https://api.open-meteo.com/...
       ▼
┌─────────────────────┐
│  HTTP Request       │
│  GET to Open-Meteo  │
└──────┬──────────────┘
       │ 5. JSON Response
       ▼
┌─────────────────────┐
│  WeatherData Model  │
│  Parse JSON         │
└──────┬──────────────┘
       │ 6. WeatherData Object
       ▼
┌─────────────────────┐
│  Cache Service      │
│  Save locally       │
└──────┬──────────────┘
       │ 7. Cached successfully
       ▼
┌─────────────────────┐
│  Weather Screen     │
│  setState()         │
└──────┬──────────────┘
       │ 8. Update UI
       ▼
┌─────────────────────┐
│  Display Widgets    │
│  - Coordinates      │
│  - Weather Data     │
│  - Request URL      │
└─────────────────────┘
```

## Offline/Cached Flow

```
┌─────────────┐
│  App Start  │
└──────┬──────┘
       │
       ▼
┌─────────────────────┐
│  Weather Screen     │
│  initState()        │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│  Cache Service      │
│  getCachedData()    │
└──────┬──────────────┘
       │
       ├─ If cached data exists
       │  ▼
       │  ┌──────────────────┐
       │  │  Load cached:    │
       │  │  - Weather Data  │
       │  │  - Student Index │
       │  │  - Coordinates   │
       │  └────────┬─────────┘
       │           │
       │           ▼
       │  ┌──────────────────┐
       │  │  Display with    │
       │  │  "(cached)" tag  │
       │  └──────────────────┘
       │
       └─ If no cache
          ▼
          ┌──────────────────┐
          │  Empty state     │
          │  Wait for fetch  │
          └──────────────────┘
```

## Error Handling Flow

```
┌─────────────────────┐
│  _fetchWeather()    │
└──────┬──────────────┘
       │
       ▼
    try {
       │
       ├─ Validate index
       │  └─ Empty? → throw Exception
       │
       ├─ Calculate coordinates
       │  └─ Invalid format? → throw Exception
       │
       ├─ Fetch from API
       │  └─ Network error? → throw Exception
       │
       ├─ Parse response
       │  └─ Invalid JSON? → throw Exception
       │
       └─ Cache result
          └─ Success!
    }
    │
    ▼
  catch (e) {
    │
    ├─ setState(isLoading: false)
    │
    └─ Show error dialog
       ├─ Title: "Error"
       ├─ Message: e.toString()
       └─ Button: "OK" to dismiss
  }
```

## State Management

```
WeatherScreen State Variables:
┌──────────────────────────────────┐
│  _indexController                │ → Controls text input
├──────────────────────────────────┤
│  _coordinates: Coordinates?      │ → Null until calculated
├──────────────────────────────────┤
│  _weatherData: WeatherData?      │ → Null until fetched
├──────────────────────────────────┤
│  _isLoading: bool                │ → Shows loading indicator
├──────────────────────────────────┤
│  _requestUrl: String?            │ → Null until API called
└──────────────────────────────────┘

State Transitions:
  Initial → Loading → Success → Display
     │        │          │
     │        │          └─→ Cache
     │        │
     │        └─→ Error → Dialog → Reset
     │
     └─→ Load Cache → Display
```

## Complete Request/Response Cycle

```
1. User Input
   Index: "224036T"
   ↓

2. Coordinate Calculation
   firstTwo = 22
   nextTwo = 40
   lat = 5 + 2.2 = 7.20
   lon = 79 + 4.0 = 83.40
   ↓

3. URL Construction
   https://api.open-meteo.com/v1/forecast
   ?latitude=7.2
   &longitude=83.4
   &current_weather=true
   ↓

4. HTTP GET Request
   ↓

5. API Response (JSON)
   {
     "current_weather": {
       "temperature": 25.5,
       "windspeed": 12.3,
       "weathercode": 0
     }
   }
   ↓

6. Parse to Model
   WeatherData(
     temperature: 25.5,
     windSpeed: 12.3,
     weatherCode: 0,
     lastUpdated: 2025-11-14 10:30:00
   )
   ↓

7. Cache Locally
   SharedPreferences:
   - cached_weather_data: {...}
   - cached_student_index: "224036T"
   ↓

8. Update UI
   - Coordinates: 7.20°, 83.40°
   - Temperature: 25.5°C
   - Wind: 12.3 km/h
   - Weather: Clear sky (Code: 0)
   - Updated: 2025-11-14 10:30:00
   - URL: https://api.open-meteo.com/...
```

## Platform-Specific Build Outputs

```
Android:
  build/app/outputs/flutter-apk/
  ├── app-debug.apk
  └── app-release.apk

iOS:
  build/ios/
  └── Runner.app

Windows:
  build/windows/runner/Release/
  └── personalized_weather_dashboard.exe

Web:
  build/web/
  └── index.html

Linux:
  build/linux/release/bundle/
  └── personalized_weather_dashboard

macOS:
  build/macos/Build/Products/Release/
  └── personalized_weather_dashboard.app
```
