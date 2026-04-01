**PROMPTS**

*SETUP SECTION*

[x] 1. Analyze my REQUIREMENTS.md file. To begin Phase 1, Step 1.1, generate a pubspec.yaml file that includes the following dependencies: flutter_riverpod, firebase_core, firebase_auth, cloud_firestore, shared_preferences, and google_sign_in. Ensure all versions are compatible with the latest Flutter stable release.

[x] 2. Create a file lib/theme.dart that defines a ThemeData class. Since this is a gamified app, use a vibrant primary color (like Emerald Green) and a high-contrast dark secondary color. Ensure it includes custom TextTheme and rounded ButtonThemeData.

[x] 3. Update main.dart to initialize Firebase and apply this theme to the MaterialApp. Constraint Check: Do not write any feature logic yet. Only implement the dependencies and the theme as requested."


*MVP SECTION*

[x] 4. Flush out the placeholder login screen to be a full signup screen. Stick to the themes and make it feel mystical with icons and colors. under the log in screen, have a register link that goes to a screen where the user can sign up instead of log in. for now, its ok to have the register screen just be a placeholder screen. there should be email and password feilds, and then an option to sign up with google (even though thats not hooked up yet) 

[x] 5. I just created the tracknstack firebase database, now connect it through the code and make it so that a user can create a profile or sign up through the appropriate buttons on the log in screen. Make the sign up page flushed out and on theme, and avalible through the link on the log in screen. once the user has signed up or logged in, take them to the dashboard homepage. 

[x] 6. make the key icon on the sign up page the same green as the buttons. Also make the background of the screen a brown instead of black, and change that in the theme so theres no black in the color scheme. 

[x] 7. for the sign in and log in pages, have all the necessary error messages on theme with the theme.dart file and general vibe of the app. make sure there is error handling and error messages for wrong email/password, already used emails, and any other common errors. 44

[x] 8. flush out the dashboard, dont hard code the user name after the welcome, make it the actual user name that was specificied when the user signed up/ logged in. This dashbaprd screen is going to be for when a user already has an account, so make a savings bar and the quic log widgets/ summary widgets that are just cards that a user is inputing their transactions and getting a running summary of their transactions (refer to requirements.md number 5 and 6)

[x] 9. Fix: Resolve infinite loading during registration and ensure mandatory onboarding flow. The sign-up process was hanging while waiting for Firestore sync. Update AuthService to use offline persistence for the initial profile and ensure that the DashboardScreen correctly redirects new users to the SetupScreen (Requirement 12) by delaying the Firestore document creation until the setup ritual is complete.

