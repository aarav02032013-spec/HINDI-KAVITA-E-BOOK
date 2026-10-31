import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Note: For live mobile deployment, ensure google-services.json (Android)
  // or GoogleService-Info.plist (iOS) is added via FlutterFire CLI.
  try {
    await Firebase.initializeApp();
    // Enable offline disk persistence for offline reading
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    debugPrint('Firebase initialization note: $e');
  }

  runApp(const HindiKavitaApp());
}

class HindiKavitaApp extends StatelessWidget {
  const HindiKavitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'कविता सागर',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF78350F), // Rich warm amber
        scaffoldBackgroundColor: const Color(0xFFFAF7F2), // Light parchment background
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Color(0xFFFAF7F2),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

