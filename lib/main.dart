import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme.dart';
import 'screens/auth_gate.dart';

/// The entry point of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase. 
  // On Web, we provide placeholder options to prevent crashes during UI development.
  // Once 'flutterfire configure' is run, replace this with DefaultFirebaseOptions.
  await Firebase.initializeApp(
    options: kIsWeb 
      ? const FirebaseOptions(
          apiKey: "placeholder-api-key",
          appId: "placeholder-app-id",
          messagingSenderId: "placeholder-sender-id",
          projectId: "placeholder-project-id",
        )
      : null,
  );
  
  runApp(
    const ProviderScope(
      child: TrackNStackApp(),
    ),
  );
}

/// The root widget of the application.
/// This widget sets up the global [MaterialApp] settings including 
/// our custom gamified theme and the initial landing screen.
class TrackNStackApp extends StatelessWidget {
  const TrackNStackApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Track N Stack',
      // Disable the 'Debug' banner in the top-right corner.
      debugShowCheckedModeBanner: false,
      // Apply the custom Emerald Green theme defined in theme.dart.
      theme: AppTheme.darkTheme,
      // The [AuthGate] is our "Security Guard" that decides whether 
      // to show the Login Screen or the Dashboard.
      home: const AuthGate(),
    );
  }
}
