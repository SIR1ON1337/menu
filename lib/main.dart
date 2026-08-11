import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SkyBarApp(),
    ),
  );
}

class SkyBarApp extends StatelessWidget {
  const SkyBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SKY Bar & Lounge',
      debugShowCheckedModeBanner: false,
      theme: SkyTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
