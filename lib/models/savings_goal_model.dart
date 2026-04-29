class SavingsGoalModel {
  final String id;
  final String name;
  final double target;
  final double baseAmount; // Total savings when this goal started
  final bool isCompleted;

  SavingsGoalModel({
    required this.id,
    required this.name,
    required this.target,
    this.baseAmount = 0.0,
    this.isCompleted = false,
  });

  factory SavingsGoalModel.fromMap(Map<String, dynamic> data, String id) {
    return SavingsGoalModel(
      id: id,
      name: data['name'] ?? 'Goal',
      target: (data['target'] ?? 0.0).toDouble(),
      baseAmount: (data['baseAmount'] ?? 0.0).toDouble(),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'target': target,
      'baseAmount': baseAmount,
      'isCompleted': isCompleted,
    };
  }
}
