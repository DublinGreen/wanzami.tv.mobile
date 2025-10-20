import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Add login logic (GraphQL later)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login pressed')),
                );
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Landing'),
            ),
          ],
        ),
      ),
    );
  }
}
