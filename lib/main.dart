import 'package:chat_app/layout/home_layout.dart';
import 'package:chat_app/screens/auth/login/login_screen.dart';
import 'package:chat_app/screens/auth/signup/signup_screen.dart';
import 'package:chat_app/screens/profile/profile_screen.dart';
import 'package:chat_app/screens/search/search_screen.dart';
import 'package:chat_app/screens/startup_screen.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: StartUpScreen.routeName,
            routes: {
              StartUpScreen.routeName: (c) => const StartUpScreen(),
              HomeLayout.routeName: (c) => const HomeLayout(),
              LoginScreen.routeName: (c) => const LoginScreen(),
              SignupScreen.routeName: (c) => const SignupScreen(),
              SearchScreen.routeName: (c) => const SearchScreen(),
              ProfileScreen.routeName: (c) => ProfileScreen(),
            },
          );
        });
  }
}
