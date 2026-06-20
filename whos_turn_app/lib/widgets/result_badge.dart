import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Displays the result of the spin - which player goes first.
///
/// Shows a colored badge with "Player X goes first!" text.
/// The badge color matches the selected player's sector color.
class ResultBadge extends StatelessWidget {
  /// The selected player index (0-based)
  final int selectedPlayer;

  /// Current sector colors for the active player count.
  final List<Color> sectorColors;

  const ResultBadge({
    super.key,
    required this.selectedPlayer,
    required this.sectorColors,
  });

  @override
  Widget build(BuildContext context) {
    // Get the color for this player's sector
    final color = sectorColors[selectedPlayer % sectorColors.length];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
        boxShadow: [
          BoxShadow(color: AppColors.shadowBlack(0.3), blurRadius: 10),
        ],
      ),
      // Display 1-based player number (more natural for users)
      child: Text(
        'Player ${selectedPlayer + 1} goes first!',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
