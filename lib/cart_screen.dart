//cart_screen.dart
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample cart items. In a real app, you would fetch this from a database or a state management solution.
    final List<Map<String, String>> cartItems = [
      {'name': 'Merchandise Item 1', 'price': '\$15.00'},
      {'name': 'Merchandise Item 2', 'price': '\$30.00'},
      {'name': 'Merchandise Item 3', 'price': '\$25.00'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: const Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Items in your cart:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(item['name']!),
                          subtitle: Text(item['price']!),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              // In a real app, this would remove the item from the cart
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${item['name']} removed from cart'),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$70.00', // Calculate total based on cart items
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to checkout screen (not implemented yet)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Proceeding to Checkout')),
                          );
                        },
                        child: const Text('Checkout'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
