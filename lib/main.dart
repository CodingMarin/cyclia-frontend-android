import 'package:cyclia/screens/auth/authgate.dart';
import 'package:cyclia/screens/auth/forgotpassword.dart';
import 'package:cyclia/screens/auth/login.dart';
import 'package:cyclia/screens/auth/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyclia',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        // '/phone': (context) => const OTPSignUp(),
        // '/otp': (context) => const OTPSignUp(),
        '/register': (context) => const Register(),
        '/login': (context) => const Login(),
        '/forgot': (context) => const ForgotPassword(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
