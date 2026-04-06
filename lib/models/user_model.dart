/// A data model for our user profile in Firestore.
/// 
/// Following our 'Clean Code' principles, this class separates 
/// how our data looks from how it's used in the UI.
class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final int points;
  final double monthlyBudget;
  final Map<String, double> categoryBudgets;
  final double savingsGoalTarget;
  final String savingsGoalName;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.points = 0,
    this.monthlyBudget = 0.0,
    this.categoryBudgets = const {
      'needs': 0.0,
      'wants': 0.0,
      'savings': 0.0,
      'others': 0.0,
    },
    this.savingsGoalTarget = 0.0,
    this.savingsGoalName = 'Main Quest',
  });

  /// Factory constructor to create a [UserModel] from a Map.
  /// Used when retrieving data from Firestore.
  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? 'User',
      photoUrl: data['photoUrl'],
      points: data['points'] ?? 0,
      monthlyBudget: (data['monthlyBudget'] ?? 0.0).toDouble(),
      categoryBudgets: (data['categoryBudgets'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ) ?? const {
        'needs': 0.0,
        'wants': 0.0,
        'savings': 0.0,
        'others': 0.0,
      },
      savingsGoalTarget: (data['savingsGoalTarget'] ?? 0.0).toDouble(),
      savingsGoalName: data['savingsGoalName'] ?? 'Main Quest',
    );
  }

  /// Converts the [UserModel] instance into a Map.
  /// Used when saving data to Firestore.
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'points': points,
      'monthlyBudget': monthlyBudget,
      'categoryBudgets': categoryBudgets,
      'savingsGoalTarget': savingsGoalTarget,
      'savingsGoalName': savingsGoalName,
    };
  }

  /// Leveling Logic: Level = (sqrt(points) / 10).floor() + 1
  int get currentLevel => (Math.sqrt(points) / 10).floor() + 1;

  /// XP required for the NEXT level
  int get xpForNextLevel => Math.pow((currentLevel) * 10, 2).toInt();

  /// XP required for the CURRENT level
  int get xpForCurrentLevel => Math.pow((currentLevel - 1) * 10, 2).toInt();

  /// Progress (0.0 to 1.0) towards the next level
  double get percentToNextLevel {
    final range = xpForNextLevel - xpForCurrentLevel;
    final progress = points - xpForCurrentLevel;
    if (range == 0) return 0.0;
    return (progress / range).clamp(0.0, 1.0);
  }
}

/// Simple Math polyfill for level calculations
class Math {
  static double sqrt(num n) => _sqrt(n.toDouble());
  static double _sqrt(double n) {
    if (n < 0) return double.nan;
    if (n == 0) return 0;
    double x = n;
    double y = 1;
    double e = 0.000001;
    while (x - y > e) {
      x = (x + y) / 2;
      y = n / x;
    }
    return x;
  }

  static num pow(num base, num exponent) {
    num result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}
