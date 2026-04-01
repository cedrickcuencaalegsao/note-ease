import 'package:flutter/material.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => AppLayoutState();
}

class AppLayoutState extends State<AppLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text("Home Page")),
    const Center(child: Text("My Notes")),
    const Center(child: Text("Add Notes")),
    const Center(child: Text("Notifications Page")),
    const Center(child: Text("Profile Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Note Ease")),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.notes_outlined), label: "Notes"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Note"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
