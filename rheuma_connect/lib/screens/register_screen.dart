import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final username = usernameController.text;
                final email = emailController.text;
                final password = passwordController.text;
                final confirmPassword = confirmPasswordController.text;

                if (password != confirmPassword) {
                  // Use the context from the current widget
                  _showErrorDialog(context, 'Error', 'Passwords do not match.');
                  return;
                }

                try {
                  await context
                      .read<PatientProvider>()
                      .register(username, email, password);

                  // Ensure that the widget is still mounted before navigating
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  }
                } catch (error) {
                  if (mounted) {
                    _showErrorDialog(
                        context, 'Registration Failed', 'Please try again.');
                  }
                }
              },
              child: const Text('Sign Up'),
            ),
            TextButton(
              onPressed: () {
                // Ensure that the widget is still mounted before navigating
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                }
              },
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to show the dialog using a valid BuildContext
  void _showErrorDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
