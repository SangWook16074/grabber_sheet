import 'package:flutter/material.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

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
      appBar: AppBar(
        title: const Text('GrabberSheet Example'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              'Background Content',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          // Use the new widget name
          GrabberSheet(
            initialChildSize: 0.5,
            minChildSize: 0.1,
            maxChildSize: 0.9,
            snap: true,
            snapSizes: const [.5],
            backgroundColor: Theme.of(context).colorScheme.surface,
            grabberStyle: GrabberStyle(color: Colors.grey.shade400),
            builder: (BuildContext context, ScrollController scrollController) {
              return ListView.builder(
                controller: scrollController,
                itemCount: 30,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      'Item $index',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
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
