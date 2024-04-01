import 'package:driveit/pages/auth/signin_page.dart';
import 'package:driveit/pages/auth/signup_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _showSignInPage = true;

  void togglePages() {
    setState(() {
      _showSignInPage = !_showSignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSignInPage) {
      return SignInPage(showSignUpPage: togglePages);
    } else {
      return SignUpPage(showSignInPage: togglePages);
    }
  }
}
