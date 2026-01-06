import 'package:flutter/material.dart';
import 'package:bongpal/presentation/home/home_screen.dart';

void main() {
  runApp(const SubbyApp());
}

class SubbyApp extends StatelessWidget {
  const SubbyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subby',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1ABC9C)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
