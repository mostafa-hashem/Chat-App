import 'package:chat_app/layout/home_layout.dart';
import 'package:chat_app/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import '../helper/helper_functions.dart';

class StartUpScreen extends StatefulWidget {
  const StartUpScreen({super.key});

  static const String routeName = "StartUpScreen";

  @override
  State<StartUpScreen> createState() => _StartUpScreenState();
}

class _StartUpScreenState extends State<StartUpScreen> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSignedIn ? const HomeLayout() : const LoginScreen();
  }
}
