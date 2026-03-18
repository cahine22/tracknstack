import 'package:flutter/material.dart';

/// A styled action button for "The Quest".
/// 
/// This widget provides a consistent look for the primary 
/// buttons and handles loading states automatically.
class QuestButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const QuestButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading 
        ? CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary) 
        : Text(label),
    );
  }
}
