import 'package:flutter/material.dart';
import 'app_theme.dart';
import './pages/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NoteEaseApp());
}

class NoteEaseApp extends StatelessWidget {
  const NoteEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteEase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}
