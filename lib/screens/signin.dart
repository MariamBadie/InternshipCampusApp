import 'package:campus_app/backend/Controller/userController.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding for better spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            children: [
              SizedBox(
                width: 250, // Adjust width as needed
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0), // Rounded borders
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding to fit inside the SizedBox
                  ),
                ),
              ),
              const SizedBox(height: 16), // Add spacing between the fields
              SizedBox(
                width: 250, // Adjust width as needed
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.security),
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0), // Rounded borders
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding to fit inside the SizedBox
                  ),
                ),
              ),
              const SizedBox(height: 16), // Add spacing before the button
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot Your Password?",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 16), // Add spacing before the button
              ElevatedButton(
                child: const Text('Log in'),
                onPressed: () {
                  // Get the username from the controller
                  final username = _usernameController.text;
                 _authService.signInWithEmailPassword(username,_passwordController.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
