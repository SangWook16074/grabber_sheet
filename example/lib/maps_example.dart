import 'package:material_ui/material_ui.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

class MapsExamplePage extends StatefulWidget {
  const MapsExamplePage({super.key});

  @override
  State<MapsExamplePage> createState() => _MapsExamplePageState();
}

class _MapsExamplePageState extends State<MapsExamplePage> {
  final GrabberSheetController _controller = GrabberSheetController();

  final List<_Place> _places = const [
    _Place('Blue Bottle Coffee', '4.8 · 2 min away', 'Open · Coffee shop'),
    _Place('Han River Bakery', '4.7 · 4 min away', 'Fresh pastries'),
    _Place('Maple Brunch House', '4.6 · 6 min away', 'Popular for brunch'),
    _Place('City Museum', '4.9 · 8 min away', 'Tickets available'),
    _Place('Seoul Forest Walk', '4.8 · 9 min away', 'Scenic outdoor spot'),
    _Place('Riverside Market', '4.5 · 11 min away', 'Local food + shopping'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F1E8),
      body: Stack(
        children: [
          const _FakeMapBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(18),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search places, coffee, museums...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: _controller.maximize,
                          icon: const Icon(Icons.tune),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Wrap(
                    spacing: 8,
                    children: [
                      _MapChip(label: 'Open now'),
                      _MapChip(label: 'Top rated'),
                      _MapChip(label: 'Within 10 min'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GrabberSheet(
            controller: _controller,
            initialChildSize: 0.34,
            minChildSize: 0.20,
            maxChildSize: 0.88,
            snap: true,
            snapSizes: const [0.34, 0.55, 0.88],
            showScrim: true,
            scrimColor: Colors.black54,
            backgroundColor: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            grabberStyle: GrabberStyle(
              width: 52,
              height: 5,
              color: Colors.grey.shade400,
              radius: const Radius.circular(999),
            ),
            headerAreaPadding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            header: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '12 places nearby',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _controller.minimize,
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Map'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'A product-style example of a search results sheet layered over map content.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            builder: (context, scrollController) {
              return ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: _places.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final place = _places[index];
                  return Card(
                    elevation: 0,
                    color: const Color(0xFFF7F7F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4ECFF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.place_outlined),
                      ),
                      title: Text(
                        place.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(place.meta),
                            const SizedBox(height: 4),
                            Text(place.caption),
                          ],
                        ),
                      ),
                      trailing: FilledButton.tonal(
                        onPressed: _controller.maximize,
                        child: const Text('View'),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _controller.maximize,
        icon: const Icon(Icons.expand_less),
        label: const Text('Open results'),
      ),
    );
  }
}

class _FakeMapBackground extends StatelessWidget {
  const _FakeMapBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color(0xFFDCEFD9)),
        Positioned.fill(child: CustomPaint(painter: _MapPainter())),
        const Positioned(top: 140, left: 48, child: _MapMarker(label: 'Cafe')),
        const Positioned(
          top: 220,
          right: 70,
          child: _MapMarker(label: 'Museum'),
        ),
        const Positioned(top: 310, left: 120, child: _MapMarker(label: 'Park')),
        const Positioned(
          top: 380,
          right: 120,
          child: _MapMarker(label: 'Market'),
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0x99FFFFFF)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    final riverPaint = Paint()
      ..color = const Color(0xFFB8DFFF)
      ..strokeWidth = 36
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.05, size.height * 0.15),
      Offset(size.width * 0.9, size.height * 0.32),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.75),
      Offset(size.width * 0.82, size.height * 0.42),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.55),
      Offset(size.width * 0.9, size.height * 0.9),
      riverPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1F6FFF),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MapChip extends StatelessWidget {
  const _MapChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
      side: BorderSide.none,
      elevation: 1,
    );
  }
}

class _Place {
  const _Place(this.name, this.meta, this.caption);

  final String name;
  final String meta;
  final String caption;
}
