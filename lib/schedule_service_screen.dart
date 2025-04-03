// schedule_service_screen.dart
import 'package:flutter/material.dart';
import 'app_drawer.dart'; // Import the AppDrawer
import 'package:supabase_flutter/supabase_flutter.dart'; // Ensure correct imports

class ScheduleServiceScreen extends StatelessWidget {
  const ScheduleServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser; // Declare 'user' here

    return Scaffold(
      drawer: AppDrawer(
        userName: user?.userMetadata?['name'] ?? 'User', // Use the user's name if logged in
        isLoading: false,
        isUserLoggedIn: user != null,
        onSignOut: () {
          // Implement sign-out logic here
        },
      ),
      appBar: AppBar(
        title: const Text('Schedule a Service'),
      ),
      body: Center(
        child: const Text('Service scheduling interface goes here!'),
      ),
    );
  }
}
