import 'package:flutter/material.dart';
import '../layout/layout.dart';
import 'package:money_ease/pages/auth/auth.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => AuthWrapperState();
}

class AuthWrapperState extends State<AuthWrapper> {
  bool isLoggedIn = true;

  void login() {
    setState(() {
      isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isLoggedIn){
      return const AppLayout();
    } else {
      return AuthPage();
    }
  }
}
