import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/savings_progress_bar.dart';
import '../widgets/quick_log_widget.dart';
import '../widgets/summary_section.dart';

import 'setup_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the real-time user data from Firestore.
    final userDataAsync = ref.watch(userDataProvider);

    return userDataAsync.when(
      data: (user) {
        if (user == null) {
          return const SetupScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('TRACK N STACK'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  ref.read(authServiceProvider).signOut();
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Section
                Text(
                  'Welcome, ${user.displayName}!',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                ),
                Text(
                  'Level 1 Financial Hero (XP: ${user.points})',
                  style: const TextStyle(color: Colors.white38, fontSize: 14),
                ),
                const SizedBox(height: 32),

                // Savings Progress Bar
                const SavingsProgressBar(),
                const SizedBox(height: 32),

                // Quick Log Widget
                const QuickLogWidget(),
                const SizedBox(height: 32),

                // Summary Cards
                const SummarySection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('Error loading profile: $err'),
          ),
        ),
      ),
    );
  }
}
