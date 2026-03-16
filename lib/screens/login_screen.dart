import 'package:flutter/material.dart';
import 'register_screen.dart';

/// The primary entrance to the app's "Financial Quest".
/// 
/// This screen uses our custom [AppTheme] to create a 
/// mystical, high-contrast gaming environment.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Use text controllers to capture user input from the fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Standard practice: Dispose of controllers when the widget is 
    // removed from the tree to prevent memory leaks.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using [Theme.of(context)] ensures our UI stays in sync 
    // with the Emerald Green theme we defined earlier.
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              
              // --- Mystical Branding Section ---
              Center(
                child: Icon(
                  Icons.vpn_key_rounded, // A "Key to the Kingdom" icon
                  size: 80,
                  color: primaryColor, 
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Track N Stack',
                style: textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Unlock your financial mastery.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 60),

              // --- Credential Input Section ---
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true, // Hide password characters
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              
              // Helper text for returning users
              const Text(
                'Enter your credentials to resume your journey.',
                style: TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),

              // --- Action Buttons ---
              ElevatedButton(
                onPressed: () {
                  // TODO: Connect to AuthService.signIn()
                },
                child: const Text('Resume Quest'),
              ),
              const SizedBox(height: 20),
              
              // Google Sign-In Placeholder (Requirement #1)
              OutlinedButton.icon(
                onPressed: () {
                  // Placeholder for Google Auth logic
                },
                icon: const Icon(Icons.g_mobiledata, size: 32),
                label: const Text('Sign in with Google'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- Navigation to Register ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("New to the quest? "),
                  GestureDetector(
                    onTap: () {
                      // Navigate to our newly created Register screen.
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: Text(
                      "Join now.",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
