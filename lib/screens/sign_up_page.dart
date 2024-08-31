import 'dart:async';
import 'package:flutter/material.dart';
import 'package:campus_app/backend/Controller/registerController.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  //final RegisterController _registerController = RegisterController.instance;

  bool _isValidEmail = true;

  bool _validateEmail(String email) {
    // Define your email pattern here
    String pattern = r'^[^@]+@(student\.guc\.edu\.eg|student\.edu\.eg|edu\.eg|gmail.com)$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  Future<void> _registerAndVerifyEmail() async {
    if (_formKey.currentState!.validate() && _isValidEmail) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      String? result = await RegisterController.instance.registerUser(email, password);

      if (result == 'verified') {
        // Registration successful, show check email dialog
        _showCheckEmailDialog();

        // Start polling for email verification
        _startEmailVerificationPolling();
      } else {
        // Show error dialog
        _showErrorDialog('errore');
      }
    }
  }

  void _showCheckEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Check Your Email'),
          content: const Text('A verification link has been sent to your email. Please verify your email to complete the registration.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _startEmailVerificationPolling() {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      bool isVerified = await RegisterController.instance.checkEmailVerified();
      if (isVerified) {
        timer.cancel();
        _showSuccessDialog();
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Successfully Registered'),
          content: const Text('Your email has been verified. You can now log in.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to another screen if needed
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isValidEmail = _validateEmail(value);
                      });
                    },
                  ),
                  if (!_isValidEmail)
                    const Text(
                      'Invalid email format',
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _registerAndVerifyEmail,
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}