import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mh_app/pages/splash_Screen.dart';
import 'package:mh_app/pages/test_form.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print("Firebase is connected");
  } catch (e) {
    print("Firebase is not connected $e");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: spl_screen(),
    );
  }
}
