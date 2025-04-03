//signup_screen.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final InputDecoration _inputDecoration = const InputDecoration(
    labelStyle: TextStyle(color: Colors.white),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      _showSnackBar("Please fill in all fields.");
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showSnackBar("Please enter a valid email address");
      return;
    }

    if (password.length < 6) {
      _showSnackBar("Password must be at least 6 characters");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final AuthResponse response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        _showSnackBar("Sign up failed. Please try again.");
        return;
      }

      // Ensure user ID is correctly retrieved
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        _showSnackBar("Error retrieving user ID.");
        return;
      }

      // Insert user data into the 'users' table
      try {
        await Supabase.instance.client.from('users').upsert({
          'id': userId,  // Make sure this matches auth.uid()
          'name': name,
          'email': email,
        }).select().single();

        _showSnackBar("Sign-up successful! Welcome!");
        _clearFields();
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        _showSnackBar("Failed to save user data: $e");
      }
    } on AuthException catch (e) {
      _showSnackBar(e.message);
    } catch (e) {
      _showSnackBar("An unexpected error occurred");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _clearFields() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF2D2D2D),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add the logo at the top of the screen
              Center(
                child: Image.asset(
                  'assets/logo.png', // Ensure your logo.png is in the assets folder
                  height: 350, // Adjust size as needed
                  width: 350,
                ),
              ),
              const SizedBox(height: 30), // Spacing between logo and input fields

              // Name input field
              TextField(
                controller: _nameController,
                decoration: _inputDecoration.copyWith(labelText: "Name"),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              
              // Email input field
              TextField(
                controller: _emailController,
                decoration: _inputDecoration.copyWith(labelText: "Email"),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
              ),
              const SizedBox(height: 16),

              // Password input field
              TextField(
                controller: _passwordController,
                decoration: _inputDecoration.copyWith(
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _signUp(),
              ),
              const SizedBox(height: 32),
              
              // Sign Up button
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
