import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Android GUID',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Get Android GUID'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.example.get_android_guid/guid');

  String _deviceGUID = 'Unknown device GUID.';

  Future<String?> _getDeviceGUID() async {
    try {
      final String? androidId = await platform.invokeMethod('getDeviceGUID');
      setState(() {
        _deviceGUID = androidId ?? 'Unknown device GUID.';
      });
      return androidId;
    } on PlatformException {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _deviceGUID,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(onPressed: _getDeviceGUID, child: const Text('Get Device GUID')),
          ],
        ),
      ),
    );
  }
}
