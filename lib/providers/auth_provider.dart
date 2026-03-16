import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

/// Provider for the [AuthService] instance.
/// 
/// We use a provider so that any widget can easily access 
/// our authentication logic without having to manually 
/// instantiate it. It's the "link" between services and the UI.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// A [StreamProvider] that provides real-time updates on the user's status.
/// 
/// When a user logs in, this provider will emit a [User] object.
/// When they log out, it emits 'null'. 
/// 
/// The [AuthGate] widget is the primary "consumer" of this provider.
final authStateProvider = StreamProvider<User?>((ref) {
  // We 'watch' the [authServiceProvider] to get access to its functions.
  final authService = ref.watch(authServiceProvider);
  // Return the underlying Firebase Auth stream.
  return authService.authStateChanges;
});
