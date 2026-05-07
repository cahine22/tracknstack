import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/challenge_model.dart';
import '../providers/user_provider.dart';

class WeeklyChallengeWidget extends ConsumerWidget {
  final UserModel user;

  const WeeklyChallengeWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Identify the 2 active challenges from the pool
    final activeChallenges = ChallengeModel.pool
        .where((c) => user.activeWeeklyChallenges.contains(c.id))
        .toList();

    if (activeChallenges.isEmpty) {
      // Trigger a refresh if none are active
      Future.microtask(() => ref.read(userServiceProvider).refreshWeeklyChallenges(user.uid));
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'WEEKLY CHALLENGES',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    letterSpacing: 2.0,
                    color: Colors.orangeAccent,
                  ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.bolt, color: Colors.orangeAccent, size: 16),
          ],
        ),
        const SizedBox(height: 12),
        ...activeChallenges.map((challenge) {
          final isAccepted = user.acceptedWeeklyChallenges.contains(challenge.id);
          final isCompleted = user.completedWeeklyChallenges.contains(challenge.id);

          return _ChallengeCard(
            challenge: challenge,
            isAccepted: isAccepted,
            isCompleted: isCompleted,
            uid: user.uid,
          );
        }),
      ],
    );
  }
}

class _ChallengeCard extends ConsumerWidget {
  final ChallengeModel challenge;
  final bool isAccepted;
  final bool isCompleted;
  final String uid;

  const _ChallengeCard({
    required this.challenge,
    required this.isAccepted,
    required this.isCompleted,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? theme.primaryColor
              : (isAccepted ? Colors.orangeAccent.withValues(alpha: 0.5) : Colors.white10),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCompleted ? Icons.workspace_premium : Icons.shield_rounded,
                color: isCompleted ? theme.primaryColor : (isAccepted ? Colors.orangeAccent : Colors.white24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  challenge.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.white38 : Colors.white,
                  ),
                ),
              ),
              Text(
                '+${challenge.xpReward} XP',
                style: const TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            challenge.description,
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 16),
          if (isCompleted)
            const Row(
              children: [
                Icon(Icons.check, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text('Challenge Vanquished!', style: TextStyle(color: Colors.green, fontSize: 12)),
              ],
            )
          else if (isAccepted)
            Row(
              children: [
                const Text('QUEST ACTIVE', style: TextStyle(color: Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => ref.read(userServiceProvider).completeWeeklyChallenge(uid, challenge.id, challenge.xpReward),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(80, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('Claim Reward', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          else
            ElevatedButton(
              onPressed: () => ref.read(userServiceProvider).acceptChallenge(uid, challenge.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 36),
              ),
              child: const Text('Accept Challenge'),
            ),
        ],
      ),
    );
  }
}
