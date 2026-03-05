import 'package:flutter/material.dart';
import 'database/hive_service.dart';
import 'screens/welcome_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive and Database
  final hiveService = HiveService();
  await hiveService.init();

  runApp(const TimetableApp());
}

class TimetableApp extends StatelessWidget {
  const TimetableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timetable Generator',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const WelcomeScreen(),
    );
  }
}
