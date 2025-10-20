import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    const String loginMutation = r'''
      mutation Login($email: String!, $password: String!) {
        login(email: $email, password: $password)
      }
    ''';

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

            Mutation(
              options: MutationOptions(
                document: gql(loginMutation),
                onCompleted: (dynamic resultData) async {
                  if (resultData != null && resultData['login'] != null) {
                    final token = resultData['login'];

                    // ✅ Save token to shared preferences
                    await _saveToken(token);

                    final storedToken = await _getToken();
                    print('Stored token: $storedToken');

                    // ✅ Show success dialog
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Login Successful'),
                        content: Text('Token saved locally:\n$token'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // Optionally navigate to another page here
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                onError: (error) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Login Failed'),
                      content: Text(
                        error?.graphqlErrors.isNotEmpty == true
                            ? error!.graphqlErrors.first.message
                            : 'An error occurred',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              builder: (runMutation, result) {
                if (result?.isLoading ?? false) {
                  return const CircularProgressIndicator();
                }

                return ElevatedButton(
                  onPressed: () {
                    runMutation({
                      'email': emailController.text.trim(),
                      'password': passwordController.text.trim(),
                    });
                  },
                  child: const Text('Login'),
                );
              },
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
