import 'package:flutter/material.dart';
import 'package:grabber_sheet_example/advanced_example.dart';
import 'package:grabber_sheet_example/maps_example.dart';
import 'package:grabber_sheet_example/non_mobile_grabber_example.dart';
import 'package:grabber_sheet_example/simple_grabber_sheet.dart';

void main() => runApp(const DraggableSheetExampleApp());

class DraggableSheetExampleApp extends StatelessWidget {
  const DraggableSheetExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ExampleCatalogPage(),
    );
  }
}

class ExampleCatalogPage extends StatelessWidget {
  const ExampleCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = [
      const _ExampleItem(
        title: 'Maps-style demo',
        subtitle: 'Search results sheet layered over a faux map surface.',
        icon: Icons.map_outlined,
        page: MapsExamplePage(),
      ),
      const _ExampleItem(
        title: 'Simple setup',
        subtitle: 'The smallest useful GrabberSheet configuration.',
        icon: Icons.layers_outlined,
        page: SimpleGrabberSheet(),
      ),
      const _ExampleItem(
        title: 'Advanced controls',
        subtitle: 'Controller, scrim, callbacks, and animation tuning.',
        icon: Icons.tune,
        page: AdvancedExamplePage(),
      ),
      const _ExampleItem(
        title: 'Desktop / web behavior',
        subtitle: 'Responsive layout and non-mobile grabber behavior.',
        icon: Icons.desktop_windows_outlined,
        page: NonMobileGrabberExample(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('grabber_sheet examples')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: examples.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = examples[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(child: Icon(item.icon)),
              title: Text(item.title),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(item.subtitle),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute<void>(builder: (_) => item.page));
              },
            ),
          );
        },
      ),
    );
  }
}

class _ExampleItem {
  const _ExampleItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;
}
