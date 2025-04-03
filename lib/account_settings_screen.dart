// ignore_for_file: use_super_parameters, library_private_types_in_public_api
//account_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for text fields
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final user = supabase.auth.currentUser;
    if (user == null) {
      _showSnackBar('No user is logged in.');
      setState(() => _isLoading = false);
      return;
    }

    try {
      // First verify old password
      await supabase.auth.signInWithPassword(
        email: user.email!,
        password: _oldPasswordController.text,
      );

      // Then update to new password
      await supabase.auth.updateUser(
        UserAttributes(password: _newPasswordController.text),
      );

      _showSnackBar('Password updated successfully.');
      _oldPasswordController.clear();
      _newPasswordController.clear();
    } on AuthException catch (e) {
      debugPrint("Auth error updating password: $e");
      _showSnackBar('Password update failed: ${e.message}');
    } catch (e) {
      debugPrint("Error updating password: $e");
      _showSnackBar('Failed to update password.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Password Change Section
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: const InputDecoration(labelText: 'Old Password'),
                  obscureText: true,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    if (value!.length < 6) return 'Minimum 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  child: _isLoading 
                      ? const CircularProgressIndicator()
                      : const Text('Update Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
