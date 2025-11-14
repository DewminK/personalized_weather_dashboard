# Troubleshooting Network Issues

## Common Error: "Failed host lookup" or "No internet connection"

This error occurs when the app cannot reach the Open-Meteo API server. Here are the solutions:

---

## ✅ Solution 1: Check Your Internet Connection

### For Physical Devices:
1. **Enable WiFi or Mobile Data**
   - Go to device Settings
   - Turn on WiFi or Mobile Data
   - Verify you're connected to a network

2. **Test Internet Connection**
   - Open a web browser
   - Try visiting: https://api.open-meteo.com/v1/forecast?latitude=7.2&longitude=83.4&current_weather=true
   - If it loads, your internet is working

### For Emulators:
The emulator may not have internet access configured properly.

---

## ✅ Solution 2: Configure Android Emulator Internet

### Method 1: Check Emulator Network Settings
1. Open **Android Studio**
2. Go to **Tools > AVD Manager**
3. Click **Edit** (pencil icon) on your emulator
4. Click **Show Advanced Settings**
5. Under **Network**, ensure settings are:
   - **Speed**: Full
   - **Latency**: None

### Method 2: Restart Emulator
```bash
# In terminal/command prompt
adb kill-server
adb start-server
```
Then restart the emulator.

### Method 3: Use a Different Emulator
Create a new emulator with:
- **API Level**: 30 or higher
- **System Image**: x86_64 (with Google APIs)

---

## ✅ Solution 3: Test with Physical Device

If emulator issues persist, use a physical device:

1. **Enable Developer Options**:
   - Go to Settings > About Phone
   - Tap "Build Number" 7 times

2. **Enable USB Debugging**:
   - Go to Settings > Developer Options
   - Turn on "USB Debugging"

3. **Connect and Run**:
   ```bash
   flutter devices
   flutter run -d <your-device-id>
   ```

---

## ✅ Solution 4: Verify API is Accessible

### Test in Browser:
Visit this URL in your browser:
```
https://api.open-meteo.com/v1/forecast?latitude=7.2&longitude=83.4&current_weather=true
```

**Expected Response**:
```json
{
  "current_weather": {
    "temperature": 25.5,
    "windspeed": 12.3,
    "weathercode": 0,
    "time": "2025-11-14T10:30"
  }
}
```

If you see this, the API is working and it's a device/emulator issue.

---

## ✅ Solution 5: Add Internet Permission (Android)

Ensure your `android/app/src/main/AndroidManifest.xml` has:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <application>
        ...
    </application>
</manifest>
```

---

## ✅ Solution 6: Use Cached Data (Offline Mode)

The app has offline support built-in!

### How to Test Offline Feature:
1. **Fetch weather while online** (at least once)
2. **Turn off internet**
3. **Close and reopen app**
4. You should see cached data with a **(cached)** tag

This is a **feature**, not a bug! The app is designed to work offline.

---

## ✅ Solution 7: Windows Firewall (Windows Only)

If running on Windows:

1. Open **Windows Defender Firewall**
2. Click **Allow an app through firewall**
3. Find **Flutter** or your **IDE** (VS Code, Android Studio)
4. Ensure both **Private** and **Public** are checked
5. Click **OK**

---

## ✅ Solution 8: Proxy Settings

If you're behind a corporate/university network with a proxy:

### For Windows:
```bash
# Set proxy in terminal before running Flutter
set HTTP_PROXY=http://your-proxy:port
set HTTPS_PROXY=http://your-proxy:port
flutter run
```

### For macOS/Linux:
```bash
export HTTP_PROXY=http://your-proxy:port
export HTTPS_PROXY=http://your-proxy:port
flutter run
```

---

## ✅ Solution 9: Alternative API (Last Resort)

If Open-Meteo is blocked on your network, you can modify the code to use an alternative API:

### Option A: WeatherAPI.com (Free tier available)
1. Sign up at https://www.weatherapi.com/
2. Get a free API key
3. Modify `weather_service.dart`

### Option B: OpenWeatherMap (Free tier available)
1. Sign up at https://openweathermap.org/
2. Get a free API key
3. Modify `weather_service.dart`

**Note**: Document any API changes in your project report.

---

## 🔍 Debugging Steps

### Step 1: Check Flutter Doctor
```bash
flutter doctor -v
```
Ensure everything is ✓ (green checkmarks)

### Step 2: Check Device Connection
```bash
flutter devices
```
You should see at least one device listed

### Step 3: Run with Verbose Logging
```bash
flutter run -v
```
This shows detailed logs to identify the exact issue

### Step 4: Check Emulator Internet
Inside the emulator, open Chrome and try:
```
https://www.google.com
```
If Google doesn't load, the emulator has no internet.

---

## 📱 Recommended Testing Configuration

### Best Setup for Testing:
- **Device**: Physical Android device (most reliable)
- **API Level**: 30 or higher
- **Connection**: WiFi (not mobile data with restrictions)
- **Permissions**: Internet permission granted

### Alternative Setup:
- **Emulator**: Pixel 6 API 34 (or similar)
- **System Image**: x86_64 with Google APIs
- **Network**: Ensure emulator has internet access

---

## 💡 Understanding the Error Messages

### Error: "Failed host lookup"
- **Cause**: Cannot resolve domain name `api.open-meteo.com`
- **Solution**: Check internet connection or DNS settings

### Error: "SocketException"
- **Cause**: Network socket cannot be created
- **Solution**: Check firewall, internet connection, or proxy

### Error: "Connection timeout"
- **Cause**: Request took too long (>10 seconds)
- **Solution**: Slow internet or API is slow, try again

### Error: "No internet connection"
- **Cause**: Device has no active network connection
- **Solution**: Enable WiFi or mobile data

---

## ✅ Verification Checklist

Before reporting issues, verify:

- [ ] Device/emulator has internet access (test with browser)
- [ ] Can access https://api.open-meteo.com in browser
- [ ] Internet permission is in AndroidManifest.xml
- [ ] No firewall blocking the app
- [ ] No proxy issues
- [ ] `flutter doctor` shows no errors
- [ ] Tried with physical device (if emulator fails)
- [ ] Cached data works when offline

---

## 🎯 Expected Behavior

### Online Mode:
1. Enter student index
2. Tap "Fetch Weather"
3. See loading indicator
4. Weather data appears
5. Data is cached automatically

### Offline Mode:
1. Open app (after fetching at least once online)
2. See cached data with **(cached)** tag
3. Try to fetch → Error dialog appears
4. Error dialog mentions cached data is available
5. Cached data remains visible

---

## 📞 Still Having Issues?

If none of these solutions work:

1. **Test the API directly** in a browser first
2. **Try with a physical device** instead of emulator
3. **Check university/corporate network restrictions**
4. **Use a different network** (mobile hotspot, home WiFi)
5. **Document the issue** with screenshots for your report

Remember: The offline caching feature means the app still functions without internet after the first successful fetch!
