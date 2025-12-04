import 'package:flutter/material.dart';
import 'package:grabber_sheet_example/non_mobile_grabber_example.dart';
import 'package:grabber_sheet_example/simple_grabber_sheet.dart';

void main() => runApp(const DraggableSheetExampleApp());

class DraggableSheetExampleApp extends StatelessWidget {
  const DraggableSheetExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlue,
          surface: Colors.lightBlue.shade50,
          onSurface: Colors.black87,
        ),
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GrabberSheet Examples')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Simple GrabberSheet'),
            subtitle: const Text(
              'A basic implementation of the grabber sheet.',
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SimpleGrabberSheet(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Responsive GrabberSheet'),
            subtitle: const Text(
              'Shows a responsive layout and grabber visibility on non-mobile platforms.',
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NonMobileGrabberExample(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
