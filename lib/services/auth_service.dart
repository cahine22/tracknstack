import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'user_service.dart';

/// Pure logic class for [Firebase Authentication] services.
/// 
/// Following our 'Separation of Concerns' (Guardrail 2), this class 
/// contains NO UI code. Its only job is to wrap Firebase Auth SDK 
/// calls in a cleaner, maintainable interface.
class AuthService {
  // Use the default [FirebaseAuth] singleton instance.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  /// Exposes the current authentication state as a [Stream].
  /// 
  /// The [AuthGate] widget listens to this stream to decide 
  /// between the Dashboard and Login screens.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Create a new account using Email and Password.
  /// 
  /// [email] and [password] are provided by the user in the Register screen.
  /// Throws a [FirebaseAuthException] if the signup fails (e.g., weak password).
  Future<UserCredential?> signUp(String email, String password, String displayName) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardrail: Ensure we have a user before saving to Firestore.
      if (credential.user != null) {
        final newUser = UserModel(
          uid: credential.user!.uid,
          email: email,
          displayName: displayName,
        );
        // Save the new user profile in Firestore immediately.
        await _userService.saveUser(newUser);
      }
      
      return credential;
    } catch (e) {
      // Re-throw so the UI can catch it and show an error Snackbar.
      rethrow;
    }
  }

  /// Authenticate an existing user.
  /// 
  /// [email] and [password] are checked against Firebase's stored credentials.
  /// Throws a [FirebaseAuthException] if sign-in fails (e.g., wrong password).
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Sign the current user out.
  /// 
  /// This will trigger the [authStateChanges] stream to emit 'null',
  /// which in turn tells the [AuthGate] to switch back to the Login screen.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
