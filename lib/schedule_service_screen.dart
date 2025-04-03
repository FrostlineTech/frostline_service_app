import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleServiceScreen extends StatefulWidget {
  const ScheduleServiceScreen({Key? key}) : super(key: key);

  @override
  _ScheduleServiceScreenState createState() => _ScheduleServiceScreenState();
}

class _ScheduleServiceScreenState extends State<ScheduleServiceScreen> {
  DateTime? _selectedDate;
  TextEditingController _noteController = TextEditingController();

  final List<Map<String, String>> _services = [
    {
      'title': 'Custom Pc Build',
      'image': 'assets/logo.png', // Path to the image
      'description': 'Have Frostline Build a Custom Pc Attuned to your needs and budget. The biggest bang for your buck.'
    },
    {
      'title': 'Service 2',
      'image': 'assets/logo.png', // Path to the image
      'description': 'Description for Service 2'
    },
    {
      'title': 'Service 3',
      'image': 'assets/logo.png', // Path to the image
      'description': 'Description for Service 3'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      drawer: AppDrawer(
        userName: user?.userMetadata?['name'] ?? 'User',
        isLoading: false,
        isUserLoggedIn: user != null,
        onSignOut: () {
          // Implement sign-out logic here
        },
      ),
      appBar: AppBar(
        title: const Text('Schedule a Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Notes input
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Additional Notes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // List of services
            Expanded(
              child: ListView.builder(
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  final service = _services[index];
                  return ServiceCard(
                    service: service,
                    onSchedulePressed: () => _showDatePicker(service['title']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker(String serviceTitle) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      // After selecting a date, schedule the service
      _scheduleService(serviceTitle, _selectedDate!, _noteController.text);
    }
  }

  Future<void> _scheduleService(String serviceTitle, DateTime date, String notes) async {
    final user = Supabase.instance.client.auth.currentUser;
    
    if (user != null) {
      try {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Service scheduled successfully!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to schedule service: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to schedule a service')),
      );
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}

class ServiceCard extends StatelessWidget {
  final Map<String, String> service;
  final VoidCallback onSchedulePressed;

  const ServiceCard({
    Key? key,
    required this.service,
    required this.onSchedulePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Service Image
          Image.asset(
            service['image']!,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Title
                Text(
                  service['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // Service Description
                Text(
                  service['description']!,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Schedule Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: onSchedulePressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colors.blue, // Blue button
                  foregroundColor: Colors.white, // White text
                ),
                child: const Text('Schedule'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}