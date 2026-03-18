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
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'An unexpected error occurred during your registration: $e';
    }
  }

  /// Authenticate an existing user.
  /// 
  /// [email] and [password] are checked against Firebase's stored credentials.
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'An unexpected error occurred while resuming your quest: $e';
    }
  }

  /// Helper to convert cryptic Firebase codes into mystical, helpful messages.
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No legend found with this email. Perhaps you need to register?';
      case 'wrong-password':
        return 'The secret password you provided does not match our scrolls.';
      case 'email-already-in-use':
        return 'This email is already tied to another hero\'s quest.';
      case 'invalid-email':
        return 'The email format seems to be missing some magic.';
      case 'weak-password':
        return 'Your secret password is too weak. Strengthen it to protect your gold.';
      case 'operation-not-allowed':
        return 'The gates of this quest are currently closed (Auth not enabled in Firebase).';
      case 'user-disabled':
        return 'This hero\'s account has been banished from the realm.';
      default:
        return 'A mystical error has blocked your path: ${e.message}';
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
