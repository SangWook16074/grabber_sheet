import 'package:flutter/material.dart';
import 'package:grabber_sheet/grabber_sheet.dart';
import 'advanced_example.dart';

void main() => runApp(const DraggableSheetExampleApp());

class DraggableSheetExampleApp extends StatelessWidget {
  const DraggableSheetExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const SimpleExamplePage(),
    );
  }
}

class SimpleExamplePage extends StatelessWidget {
  const SimpleExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Simple GrabberSheet'),
        actions: [
          // Navigate to the Advanced Example page to see more features.
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AdvancedExamplePage()),
              );
            },
            child: const Text('View Advanced'),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Center(child: Text('Map or Background Content Here')),
          // 1. Wrap your content with GrabberSheet
          GrabberSheet(
            snap: true,
            builder: (context, scrollController) {
              // 2. Connect the scrollController
              return ListView.builder(
                controller: scrollController,
                itemCount: 50,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Simple Item $index'),
                    leading: const Icon(Icons.location_on),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}