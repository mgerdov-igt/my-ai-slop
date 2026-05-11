import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Action buttons shown at the bottom of the spinner screen.
/// 
/// Contains:
/// - "Spin Again" button (only shown after first spin)
/// - "Back" button to return to player selection
class SpinnerActionButtons extends StatelessWidget {
  /// Whether the user has already spun at least once
  final bool hasSpun;
  
  /// Callback when "Spin Again" is pressed
  final VoidCallback onSpinAgain;
  
  /// Callback when "Back" is pressed
  final VoidCallback onBack;

  const SpinnerActionButtons({
    super.key,
    required this.hasSpun,
    required this.onSpinAgain,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Only show "Spin Again" after the first spin
        if (hasSpun)
          ElevatedButton.icon(
            onPressed: onSpinAgain,
            icon: const Icon(Icons.refresh),
            label: const Text('Spin Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryButton,
              foregroundColor: AppColors.primaryButtonText,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        const SizedBox(width: 16),
        // Back button is always visible
        TextButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white70,
          ),
        ),
      ],
    );
  }
}
