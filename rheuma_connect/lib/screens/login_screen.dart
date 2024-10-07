import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import 'profile_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;

                try {
                  // Await the login operation
                  await context.read<PatientProvider>().login(email, password);

                  // Extract the patientId from the user object
                  const patientId =
                      '66fee8c8510f3ae604a4e9e2'; // Access the actual ID from the response

                  // After login, fetch patient data

                  await context.read<PatientProvider>().fetchPatient(patientId);

                  // Check if the widget is still mounted before navigating
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => ProfileScreen()),
                    );
                  }
                } catch (error) {
                  if (mounted) {
                    // Display an error message using a valid context
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Login Failed'),
                        content: const Text('Please check your credentials.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          )
                        ],
                      ),
                    );
                  }
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the RegisterScreen (assuming you have the RegisterScreen ready)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterScreen()),
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
