/// A data model for the Weekly "Boss" Challenges.
class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final String type; // e.g., 'no-buy', 'savings-boost', 'category-limit'

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.type,
  });

  /// The pool of available weekly challenges.
  static const List<ChallengeModel> pool = [
    ChallengeModel(
      id: 'no_buy_weekend',
      title: 'No-Buy Weekend',
      description: 'Spend \$0 on "Wants" from Friday to Sunday.',
      xpReward: 200,
      type: 'no-buy',
    ),
    ChallengeModel(
      id: 'savings_dash',
      title: 'Savings Dash',
      description: 'Log at least \$50 in "Savings" this week.',
      xpReward: 150,
      type: 'savings-boost',
    ),
    ChallengeModel(
      id: 'needs_only',
      title: 'Needs Only Day',
      description: 'Spend only on "Needs" for 24 hours.',
      xpReward: 100,
      type: 'category-limit',
    ),
    ChallengeModel(
      id: 'frugal_feast',
      title: 'Frugal Feast',
      description: 'Keep your "Wants" spending under \$20 for the week.',
      xpReward: 300,
      type: 'category-limit',
    ),
    ChallengeModel(
      id: 'stack_master',
      title: 'Stack Master',
      description: 'Complete 3 daily quests in a row.',
      xpReward: 250,
      type: 'streak',
    ),
    ChallengeModel(
      id: 'budget_sentry',
      title: 'Budget Sentry',
      description: 'Log every transaction for 7 days straight.',
      xpReward: 400,
      type: 'streak',
    ),
    ChallengeModel(
      id: 'impulse_blocker',
      title: 'Impulse Blocker',
      description: 'Wait 24 hours before logging any "Wants" transaction > \$50.',
      xpReward: 150,
      type: 'behavior',
    ),
    ChallengeModel(
      id: 'coffee_strike',
      title: 'Coffee Strike',
      description: 'Zero spending in the "Others" category for 3 days.',
      xpReward: 120,
      type: 'category-limit',
    ),
    ChallengeModel(
      id: 'double_down',
      title: 'Double Down',
      description: 'Log 2 savings transactions in a single day.',
      xpReward: 180,
      type: 'savings-boost',
    ),
    ChallengeModel(
      id: 'titan_saver',
      title: 'Titan Saver',
      description: 'Increase your total savings by 5% this week.',
      xpReward: 500,
      type: 'savings-boost',
    ),
  ];
}
