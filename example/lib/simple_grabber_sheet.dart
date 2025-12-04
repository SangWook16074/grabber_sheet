import 'package:flutter/material.dart';
import 'package:grabber_sheet/grabber_sheet.dart';
import 'package:grabber_sheet_example/common/responsive_frame.dart';

class SimpleGrabberSheet extends StatelessWidget {
  const SimpleGrabberSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sheetColor = Colors.blue.shade100;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Simple GrabberSheet'),
        backgroundColor: sheetColor,
      ),
      body: ResponsiveFrame(
        child: Stack(
          children: [
            Center(
              child: Text(
                'Background Content',
                style: theme.textTheme.headlineMedium,
              ),
            ),
            GrabberSheet(
              initialChildSize: 0.5,
              minChildSize: 0.2,
              maxChildSize: 0.8,
              snap: true,
              snapSizes: const [.5],
              backgroundColor: sheetColor,
              grabberStyle: GrabberStyle(color: Colors.grey.shade400),
              bottom: Row(
                children: [
                  const Text('sheet title'),
                  const Spacer(),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
                ],
              ),
              bottomAreaPadding: const EdgeInsets.symmetric(horizontal: 16),
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return ListView.builder(
                  controller: scrollController,
                  itemCount: 30,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        'Item $index',
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
