// app_drawer.dart
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Update the imports as necessary
import 'login_screen.dart';
import 'signup_screen.dart';
import 'account_settings_screen.dart';
import 'merchandise_screen.dart';
import 'schedule_service_screen.dart';

class AppDrawer extends StatelessWidget {
  final String userName;
  final bool isLoading;
  final bool isUserLoggedIn;
  final Function onSignOut;

  const AppDrawer({
    Key? key,
    required this.userName,
    required this.isLoading,
    required this.isUserLoggedIn,
    required this.onSignOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Frostline Solutions LLC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 10),
                if (isLoading)
                  const CircularProgressIndicator(color: Colors.white)
                else if (isUserLoggedIn)
                  Text(
                    'Welcome $userName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                else
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (isUserLoggedIn)
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => onSignOut(),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule, color: Colors.blue),
            title: const Text(
              'Schedule a Service',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScheduleServiceScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.store, color: Colors.blue),
            title: const Text(
              'Merchandise',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MerchandiseScreen()),
              );
            },
          ),
          if (isUserLoggedIn)
            const SizedBox(height: 20),
          if (isUserLoggedIn)
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.blue),
              title: const Text(
                'My Account',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountSettingsScreen()),
                );
              },
            ),
        ],
      ),
    );
  }
}
