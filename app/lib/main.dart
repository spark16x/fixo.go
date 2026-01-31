import 'package:flutter/material.dart';
import 'screens/splash.dart';
mport 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fixo.go',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}

