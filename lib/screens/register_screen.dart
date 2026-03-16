import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

/// The screen where new users can "Join the Quest" and create their profile.
/// 
/// This screen follows our 'Emerald Green' gamified theme and 
/// interacts directly with the [AuthService] to create a user in 
/// both Firebase Auth and Firestore.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // Use text controllers to capture user input from the fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  // Track loading state to show a spinner when the "Quest" begins.
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  /// The logic to trigger the signup quest.
  Future<void> _signUpQuest() async {
    // Basic validation: Ensure fields aren't empty.
    if (_emailController.text.trim().isEmpty || 
        _passwordController.text.trim().isEmpty || 
        _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required to begin the quest.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Call our [AuthService] via Riverpod to create the account.
      // This will also create their Firestore profile.
      await ref.read(authServiceProvider).signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );

      // If successful, the [AuthGate] will automatically transition 
      // the user to the Dashboard once the auth state changes.
      if (mounted) {
        Navigator.pop(context); // Go back to Login (then AuthGate handles it)
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join quest: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join the Quest'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // --- Mystical Branding Section ---
              Center(
                child: Icon(
                  Icons.vpn_key_rounded, // Updated to Key icon
                  size: 80,
                  color: primaryColor, // Same green as the buttons
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Create Your Legend',
                style: textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your details to start your financial journey.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),

              // --- Credential Input Section ---
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Hero Name (Display Name)',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 20),
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
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Secret Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              
              const SizedBox(height: 40),

              // --- Action Button ---
              ElevatedButton(
                onPressed: _isLoading ? null : _signUpQuest,
                child: _isLoading 
                  ? CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary) 
                  : const Text('Begin Journey'),
              ),
              
              const SizedBox(height: 20),

              // --- Back to Login ---
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Already have a legend? Back to Login'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
