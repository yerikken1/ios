import 'package:flutter/material.dart';
import 'screens/photo_diary_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PhotoDiaryApp());
}

class PhotoDiaryApp extends StatelessWidget {
  const PhotoDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Narxoz Photo Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315C9B)),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const PhotoDiaryScreen(),
    );
  }
}
