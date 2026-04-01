import 'package:flutter/material.dart';
import './shared//components//layout//layout.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Note Ease",
      debugShowCheckedModeBanner: false,
      home: AppLayout(),
    );
  }
}
