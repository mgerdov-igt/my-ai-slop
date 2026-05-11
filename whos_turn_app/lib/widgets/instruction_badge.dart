import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Instruction text shown before the user has spun.
/// 
/// A semi-transparent badge that tells the user to tap the meeple.
class InstructionBadge extends StatelessWidget {
  const InstructionBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.overlayWhite(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Tap the meeple to spin!',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
