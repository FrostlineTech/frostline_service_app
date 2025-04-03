// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'account_settings_screen.dart'; // Import the AccountSettingsScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isLoading = false;

  // Controllers for the PC specs
  final _processorController = TextEditingController();
  final _ramController = TextEditingController();
  final _gpuController = TextEditingController();
  bool _isEditingSpecs = false;  // Track whether the user is editing the specs

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchPCSpecs();
  }

  Future<void> _fetchUserName() async {
    setState(() => _isLoading = true);
    final user = supabase.auth.currentUser;

    if (user != null) {
      try {
        final response = await supabase
            .from('users')
            .select('name')
            .eq('id', user.id)
            .single();

        if (mounted) {
          setState(() {
            userName = response['name'] ?? "User";
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        debugPrint("Error fetching user name: $e");
      }
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _fetchPCSpecs() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;  // No user is logged in, so no PC specs

    try {
      final response = await supabase
          .from('pc_specs')
          .select()
          .eq('user_id', user.id)
          .single();

      if (mounted) {
        setState(() {
          _processorController.text = response['processor'] ?? '';
          _ramController.text = response['ram'] ?? '';
          _gpuController.text = response['gpu'] ?? '';
        });
      }
    } catch (e) {
      debugPrint("Error fetching PC specs: $e");
    }
  }

  Future<void> _savePCSpecs() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;  // No user is logged in, so don't save PC specs

    try {
      await supabase.from('pc_specs').upsert({
        'user_id': user.id,
        'processor': _processorController.text,
        'ram': _ramController.text,
        'gpu': _gpuController.text,
      });

      setState(() {
        _isEditingSpecs = false;  // Disable editing after saving
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PC Specs saved successfully')),
      );
    } catch (e) {
      debugPrint("Error saving PC specs: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save PC Specs')),
      );
    }
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
      if (mounted) {
        setState(() {
          userName = "";
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      debugPrint("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      drawer: Drawer(
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
                  if (_isLoading)
                    const CircularProgressIndicator(color: Colors.white)
                  else if (user != null)
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
                  if (user != null)
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: _signOut,
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
            if (user != null) // Show "My Account" button only if user is logged in
              ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.blue),
                title: const Text(
                  'My Account',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
                  );
                },
              ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF2D2D2D),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Start your journey here!!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frostline Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome - $userName',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isEditingSpecs = !_isEditingSpecs;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'My PC',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          if (_isEditingSpecs)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _processorController,
                                  decoration: const InputDecoration(labelText: 'Processor'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                TextField(
                                  controller: _ramController,
                                  decoration: const InputDecoration(labelText: 'RAM'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                TextField(
                                  controller: _gpuController,
                                  decoration: const InputDecoration(labelText: 'GPU'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _savePCSpecs,
                                  child: const Text('Save Specs'),
                                ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Processor: ${_processorController.text}'),
                                Text('RAM: ${_ramController.text}'),
                                Text('GPU: ${_gpuController.text}'),
                              ],
                            ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _isEditingSpecs ? _savePCSpecs : null,
                            icon: const Icon(Icons.settings),
                            label: const Text('Settings'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to service scheduling page
                            },
                            child: const Text('Schedule a Service'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
