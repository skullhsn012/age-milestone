import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

/// Counter class with ChangeNotifier
class Counter with ChangeNotifier {
  int _value = 0;

  int get value => _value;

  void setValue(double newValue) {
    _value = newValue.toInt();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Age Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age Counter')),
      body: Consumer<Counter>(
        builder: (context, counter, child) {
          String message = _getAgeMessage(counter.value);
          Color bgColor = _getBackgroundColor(counter.value);

          return Container(
            color: bgColor, // Change background color
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Your Age:', style: TextStyle(fontSize: 20)),
                Text('${counter.value}',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                Text(message, style: const TextStyle(fontSize: 18)),
                Slider(
                  value: counter.value.toDouble(),
                  min: 0,
                  max: 99,
                  divisions: 99,
                  label: counter.value.toString(),
                  onChanged: (double newValue) {
                    counter.setValue(newValue);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Returns message based on age milestones
  String _getAgeMessage(int age) {
    if (age <= 12) return "You're a child!";
    if (age <= 19) return "Teenager time!";
    if (age <= 30) return "You're a young adult!";
    if (age <= 50) return "You're an adult now!";
    return "Golden years!";
  }

  /// Returns background color based on age range
  Color _getBackgroundColor(int age) {
    if (age <= 12) return Colors.lightBlue;
    if (age <= 19) return Colors.lightGreen;
    if (age <= 30) return Colors.yellow.shade200;
    if (age <= 50) return Colors.orange;
    return Colors.grey.shade400;
  }
}
