import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from `.env` file located in assets folder
  await dotenv.load(fileName: 'assets/.env');

  // Initialize Supabase with environment variables
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,  // Read from .env
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,  // Read from .env
  );

  runApp(const FrostlineApp());
}

class FrostlineApp extends StatelessWidget {
  const FrostlineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frostline Service App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          surface: const Color(0xFF2D2D2D),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
