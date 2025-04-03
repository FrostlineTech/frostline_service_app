// service_tracking_screen.dart

import 'package:flutter/material.dart';
import 'app_drawer.dart'; // Add the import statement for AppDrawer

class ServiceTrackingScreen extends StatelessWidget {
  const ServiceTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Service Tracking"),
      ),
      drawer: AppDrawer( // Now AppDrawer is recognized because it's imported
        userName: 'User', // Replace with actual username if available
        isLoading: false, // Replace with actual loading state if necessary
        isUserLoggedIn: true, // Replace with actual user logged in state
        onSignOut: () {
          // Add your sign-out logic here if needed
        },
      ),
      body: Center(
        child: const Text(
          'Service Tracking Page', // Replace this with your service tracking content
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
