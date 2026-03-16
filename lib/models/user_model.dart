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

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.points = 0,
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
    };
  }
}
