import 'package:flutter/material.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

class NonMobileGrabberExample extends StatelessWidget {
  const NonMobileGrabberExample({super.key});

  @override
  Widget build(BuildContext context) {
    const breakpoint = 800.0;
    final sheetColor = Colors.amber.shade100;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Responsive Non-Mobile Grabber'),
        backgroundColor: sheetColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > breakpoint;
          if (isWideScreen) {
            return _WideLayout(sheetColor: sheetColor);
          } else {
            return _NarrowLayout(sheetColor: sheetColor);
          }
        },
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({required this.sheetColor});

  final Color sheetColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              'Background Content',
              style: theme.textTheme.headlineMedium,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(16),
            color: sheetColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Column(
                  children: [
                    Text(
                      'Responsive Layout',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is a wide-screen layout. The sheet content is displayed as a card on the right. A grabber is manually added to the card to mimic the sheet\'s behavior with "showGrabberOnNonMobile: true".',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const Divider(),
                  ],
                ),
                Expanded(
                  child: _buildContent(
                    context,
                    ScrollController(),
                    isWideScreen: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({required this.sheetColor});

  final Color sheetColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Center(
          child: Text(
            'Background Content',
            style: theme.textTheme.headlineMedium,
          ),
        ),
        GrabberSheet(
          showGrabberOnNonMobile: true,
          initialChildSize: 0.5,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          snap: true,
          snapSizes: const [.5],
          backgroundColor: sheetColor,
          grabberStyle: GrabberStyle(color: Colors.grey.shade400),
          bottom: Column(
            children: [
              Text('Responsive Layout', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'This is a narrow-screen layout on a non-mobile platform. The grabber is visible because "showGrabberOnNonMobile" is set to true.',
                style: theme.textTheme.bodyMedium,
              ),
              const Divider(),
            ],
          ),
          builder: (BuildContext context, ScrollController scrollController) {
            return _buildContent(
              context,
              scrollController,
              isWideScreen: false,
            );
          },
        ),
      ],
    );
  }
}

Widget _buildContent(
  BuildContext context,
  ScrollController scrollController, {
  required bool isWideScreen,
}) {
  final theme = Theme.of(context);

  return ListView(
    controller: scrollController,
    padding: const EdgeInsets.all(16),
    children: [
      for (int i = 0; i < 20; i++)
        ListTile(
          title: Text(
            'Item $i',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
    ],
  );
}
