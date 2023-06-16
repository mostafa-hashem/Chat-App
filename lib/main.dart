import 'package:chat_app/helper/helper_functions.dart';
import 'package:chat_app/layout/home_layout.dart';
import 'package:chat_app/screens/auth/login/login_screen.dart';
import 'package:chat_app/screens/auth/signup/signup_screen.dart';
import 'package:chat_app/screens/chat/chat_screen.dart';
import 'package:chat_app/screens/groups/groups_screen.dart';
import 'package:chat_app/screens/profile/profile_screen.dart';
import 'package:chat_app/screens/search/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        print("Value: $value");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Is SignedIn: $_isSignedIn");
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: _isSignedIn ? const HomeLayout() : const LoginScreen(),
            routes: {
              HomeLayout.routeName: (c) => const HomeLayout(),
              LoginScreen.routeName: (c) => const LoginScreen(),
              SignupScreen.routeName: (c) => const SignupScreen(),
              SearchScreen.routeName: (c) => const SearchScreen(),
              ProfileScreen.routeName: (c) => ProfileScreen(),
              GroupsScreen.routeName: (c) => const GroupsScreen(),
            },
          );
        });
  }
}
