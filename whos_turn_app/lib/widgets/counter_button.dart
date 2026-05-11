import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// A circular button with + or - icon for adjusting the player count.
/// 
/// Used on the player selection screen to increment/decrement the
/// number of players. The button is disabled (greyed out) when
/// [onPressed] is null.
class CounterButton extends StatelessWidget {
  /// The icon to display (typically Icons.add or Icons.remove)
  final IconData icon;
  
  /// Callback when button is pressed. Pass null to disable the button.
  final VoidCallback? onPressed;

  const CounterButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if button is enabled based on whether callback exists
    final isEnabled = onPressed != null;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 48,
        style: IconButton.styleFrom(
          // Brighter when enabled, very faint when disabled
          backgroundColor: isEnabled
              ? AppColors.overlayWhite(0.2)
              : AppColors.overlayWhite(0.05),
          // White when enabled, grey when disabled
          foregroundColor: isEnabled ? Colors.white : Colors.white30,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
