import 'package:flutter/material.dart';

class TestAppHarness extends StatelessWidget {
  const TestAppHarness({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }
}
