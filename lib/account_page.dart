import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui'; // Import untuk efek blur

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AccountPage(),
    );
  }
}

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _isLoggedIn = false;
  String _username = "";
  String _email = "";

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _username = prefs.getString('username') ?? "";
      _email = prefs.getString('email') ?? "";
    });
  }

  Future<void> _registerUser(String username, String email, String password) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill all fields', Colors.red);
      return;
    }

    // Simulating a registration process by saving to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setBool('isLoggedIn', true);

    setState(() {
      _isLoggedIn = true;
      _username = username;
      _email = email;
    });

    _showSnackBar('Registration successful', Colors.green);
    Navigator.pop(context); // Close the registration modal
  }

  Future<void> _loginUser(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill all fields', Colors.red);
      return;
    }

    // Simulating a login process by checking the saved data in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedEmail = prefs.getString('email');

    if (savedUsername == username) {
      setState(() {
        _isLoggedIn = true;
        _username = username;
        _email = savedEmail ?? "";
      });

      _showSnackBar('Login successful', Colors.green);
    } else {
      _showSnackBar('Invalid username or password', Colors.red);
    }
  }

  Future<void> _logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    setState(() {
      _isLoggedIn = false;
      _username = "";
      _email = "";
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // BackdropFilter for blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.1),  // Semi-transparent overlay
            ),
          ),
          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLoggedIn)
                    Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/images/fot1.jpg'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _showLoginOrRegister();
                          },
                          child: const Text('Masuk'),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundImage: AssetImage('assets/images/fot1.jpg'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _username,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _email,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _logoutUser(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 0, 208),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Logout', style: TextStyle(color: Colors.white70)),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (_isLoggedIn) ...[
                    ListTile(
                      leading: const Icon(Icons.favorite, color: Colors.white),
                      title: const Text('Favorites', style: TextStyle(color: Colors.white)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.download, color: Colors.white),
                      title: const Text('Downloads', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginOrRegister() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _registerUser(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                    );
                  },
                  child: const Text('Register'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _loginUser(
                      _usernameController.text,
                      _passwordController.text,
                    );
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
