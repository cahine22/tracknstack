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
}
