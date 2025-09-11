Project Reference
=============

This document describes the public APIs, widgets, and the platform channel used by this Flutter application.

Dart APIs (lib/main.dart)
-------------------------

### `void main()`
Entry point that bootstraps the Flutter application.

Example:
```dart
void main() {
  runApp(const MyApp());
}
```

### `class MyApp extends StatelessWidget`
Root widget that configures application-wide `MaterialApp` settings.

- title: `'Android GUID'`
- theme: Seeded `ColorScheme` with Material 3
- home: `MyHomePage`

Usage:
```dart
const app = MyApp();
runApp(app);
```

### `class MyHomePage extends StatefulWidget`
Top-level screen that displays the device GUID fetched via a platform channel.

Constructor:
- `MyHomePage({ Key? key, required String title })`

Public members:
- `final String title` — AppBar title.

Usage:
```dart
MaterialApp(
  home: const MyHomePage(title: 'Get Android GUID'),
);
```

### `Future<String?> _getDeviceGUID()`
Asynchronously invokes the platform channel method `getDeviceGUID` and updates the view state with the returned Android ID. Returns the GUID string or `null` on failure.

Notes:
- The method catches `PlatformException` and returns `null`.
- On success, it updates the `_deviceGUID` state.

Example (call from UI):
```dart
ElevatedButton(
  onPressed: _getDeviceGUID,
  child: const Text('Get Device GUID'),
);
```

Widgets
-------

The page shows:
- Current GUID text bound to `_deviceGUID`
- A button to trigger `_getDeviceGUID()`

Platform Channel API
--------------------

Channel name:
- `com.example.get_android_guid/guid`

Method(s):
- `getDeviceGUID` → `String` (Android ID)

Android implementation: `android/app/src/main/kotlin/com/example/get_android_guid/MainActivity.kt`

```kotlin
private val CHANNEL = "com.example.get_android_guid/guid"

override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
        if (call.method == "getDeviceGUID") {
            val guid = Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
            result.success(guid)
        } else {
            result.notImplemented()
        }
    }
}
```

Dart client usage:
```dart
static const platform = MethodChannel('com.example.get_android_guid/guid');

final String? androidId = await platform.invokeMethod<String>('getDeviceGUID');
```

Behavior and return values
--------------------------

- On Android: Returns the device-specific `Settings.Secure.ANDROID_ID` as a `String`.
- On other platforms: The method is not implemented natively; the Dart side will throw `MissingPluginException` if invoked. The current code only calls it on button press and catches `PlatformException`.

Error handling
--------------

- `PlatformException` on Dart side is caught and results in a `null` return.
- `notImplemented` is returned from Android when an unknown method is called on the channel.

Extending the API
-----------------

To add more methods, use the same channel and switch on `call.method` in Android (and analogous on iOS if implemented), then expose typed wrappers in Dart.
