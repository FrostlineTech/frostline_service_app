// merchandise_screen.dart
import 'package:flutter/material.dart';
import 'app_drawer.dart'; // Add this import
import 'package:supabase_flutter/supabase_flutter.dart'; // Make sure you import this to get the user

class MerchandiseScreen extends StatelessWidget {
  const MerchandiseScreen({Key? key}) : super(key: key);

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
        title: const Text("Merchandise"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Merchandise',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Example of merchandise items (you can replace with actual data)
            MerchandiseItem(name: "T-Shirt", price: "\$19.99"),
            MerchandiseItem(name: "Hat", price: "\$9.99"),
            MerchandiseItem(name: "Mug", price: "\$14.99"),
          ],
        ),
      ),
    );
  }
}

class MerchandiseItem extends StatelessWidget {
  final String name;
  final String price;

  const MerchandiseItem({
    Key? key,
    required this.name,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(name),
        subtitle: Text(price),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$name added to cart')),
            );
          },
        ),
      ),
    );
  }
}
