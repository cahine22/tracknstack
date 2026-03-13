import 'package:flutter/material.dart';

/// Placeholder screen for new users to "Join the Quest".
/// 
/// For now, this is a simple screen as per Prompt 4, 
/// allowing us to focus on the Login UI first.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join the Quest'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome, // Mystical star icon
              size: 80,
              color: Color(0xFF50C878), // Emerald Green
            ),
            const SizedBox(height: 24),
            Text(
              'Create Your Legend',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const Text(
              'Registration is coming soon...',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
