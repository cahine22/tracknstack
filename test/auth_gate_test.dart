import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracknstack/screens/auth_gate.dart';
import 'package:tracknstack/providers/auth_provider.dart';
import 'package:tracknstack/screens/login_screen.dart';
import 'package:tracknstack/screens/dashboard_screen.dart';

// Mock User class for testing
class MockUser extends Fake implements User {
  @override
  String get uid => '12345';
  @override
  String get email => 'test@example.com';
}

void main() {
  testWidgets('AuthGate shows LoginScreen when not authenticated', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override the authStateProvider to return null (not authenticated)
          authStateProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const MaterialApp(
          home: AuthGate(),
        ),
      ),
    );

    // Initial load will show loading spinner
    await tester.pump(); // Start building the widget tree
    await tester.pump(const Duration(milliseconds: 100)); // Finish loading stream

    // Verify that LoginScreen is shown
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Unlock your financial mastery.'), findsOneWidget);
  });

  testWidgets('AuthGate shows DashboardScreen when authenticated', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override the authStateProvider to return a mock user (authenticated)
          authStateProvider.overrideWith((ref) => Stream.value(MockUser())),
        ],
        child: const MaterialApp(
          home: AuthGate(),
        ),
      ),
    );

    // Initial load will show loading spinner
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify that DashboardScreen is shown
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Track N Stack Dashboard'), findsOneWidget);
  });

  testWidgets('AuthGate shows loading screen initially', (WidgetTester tester) async {
    // Build our app with a stream that doesn't emit immediately
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: const MaterialApp(
          home: AuthGate(),
        ),
      ),
    );

    // Verify that a CircularProgressIndicator is shown during loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
