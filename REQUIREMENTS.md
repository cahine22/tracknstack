## Project Requirements: Track N Stack 
Developer: Caroline Hines
Description: A gamified financial tracker and budgeting app that gives the user daily and weekly challenges to complete in efforts to make consistant healthy financial habits and decisions

## AI Assistant Guardrails 
Gemini: When reading this file to implement a step, you MUST adhere to the following architectural rules:
1. State Management: Use flutter_riverpod exclusively. Do not use setState for complex logic.
2. Architecture: Maintain strict separation of concerns:
● /models: Pure Dart data classes (use json_serializable or freezed if helpful).
● /services: Backend/API communication only. No UI code.
● /providers: Riverpod providers linking services to the UI.
● /screens & /widgets: UI only. Keep files small. Extract complex widgets into their own files.
3. Local Storage: Use shared_preferences for local app state (e.g., theme toggles, onboarding
status).
4. Database: Use FIrebase Firestone for persistent cloud data.
5. Stepwise Execution: Only implement the specific step requested in the prompt. Do not jump ahead.

## Features

*Full-Stack Integration (Milestone 2 Requirements)*
Ensuring data persistence and security as per the SYE rubric. 
1.  Multi-Provider Auth: A secure gate requiring Google Sign-In or Email/Password via Firebase.Cloud Data Sync: All transactions, quest history, and level progress must sync to Firestore to allow multi-device acces
2. The "Auth Gate": A top-level widget that listens to the Firebase Auth stream to toggle between the Login/Register screens and the Dashboard.

*The Gamified Financial Dashboard (The "Home" Screen)*
The primary interface where users visualize their financial health through a gaming lens.
3. Savings Progress Bar: A prominent visual element at the top showing the percentage completion of a user-defined savings goal, which is updated every time the user logs any type of transaction or savings.
4. The "Character" Avatar: A graphic with the user's current level and XP earned through the challenges they complete, the logs/streaks they keep up, ect.
5. Quick-Log Widget: A simplified entry point to add a transaction (Amount, Category, Date) without leaving the main screen.
6. Summary Cards: Weekly/Monthly breakdowns showing "Budget vs. Actual" spending in specific categories. Can click on the card to get a more in depth look into their transaction history.

*Dynamic Quest & Challenge System*
The core engagement engine that converts financial tasks into "missions
7. Daily Quests: Non-negotiable daily tasks, such as "Log/Review today's spending" that provide small XP boosts.
8. Weekly "Boss" Challenges: High-stakes, opt-in challenges (e.g., "No-Buy Weekend" or "Save $50 extra this week").
9. Streak Multiplier: A logic system that increases XP rewards for every consecutive day a user logs a transaction or completes a quest.

*Progression & Reward Framework*
The system that handles the leveling logic and user growth.
10. Leveling Logic: Define XP thresholds for level-ups. XP is earned by completing quests, staying under budget, and logging data consistently
11. Unlockables: Upon reaching certain levels, users unlock UI customizations (like new icons for their avatar).






