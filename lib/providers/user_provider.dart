import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'auth_provider.dart';

/// Provider for the [UserService] singleton.
final userServiceProvider = Provider<UserService>((ref) => UserService());

/// A [StreamProvider] that supplies real-time [UserModel] data.
/// 
/// This is our core 'Store' for user data. Any screen can 
/// use this to show the user's name, profile pic, or points.
final userDataProvider = StreamProvider<UserModel?>((ref) {
  // First, we 'watch' the [authStateProvider] to get the current UID.
  final authUser = ref.watch(authStateProvider).value;
  final userService = ref.watch(userServiceProvider);

  // If we don't have a logged-in user yet, emit 'null'.
  if (authUser == null) return Stream.value(null);

  // Otherwise, start streaming data from Firestore.
  return userService.getUserData(authUser.uid);
});
