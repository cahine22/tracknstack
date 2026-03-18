import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

/// The top-level [ConsumerWidget] that listens for authentication changes.
/// 
/// Instead of a complex splash screen or routing logic, we use an [AuthGate].
/// This widget "watches" the [authStateProvider] and swaps the screen 
/// instantaneously based on the result. 
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // [ref.watch] ensures this build() function runs every time the 
    // user's authentication status (logged in/out) changes.
    final authState = ref.watch(authStateProvider);

    // Using .when() is the standard Riverpod way to handle 
    // Data, Loading, and Error states cleanly.
    return authState.when(
      data: (user) {
        // If user != null, they are authenticated. Go to the main app!
        if (user != null) {
          return const DashboardScreen();
        } else {
          // If null, they need to log in or register.
          return const LoginScreen();
        }
      },
      // Show a loading spinner while the Firebase SDK connects to the cloud.
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      // Handle rare network or Firebase errors during the initial check.
      error: (e, stack) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  'A mystical error blocks the gate:',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
