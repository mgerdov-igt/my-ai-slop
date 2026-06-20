import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Custom painter that draws the colored player sectors.
///
/// HOW IT WORKS:
/// - Divides the screen into equal pie slices (one per player)
/// - Each slice gets a unique color from [AppColors.sectorColors]
/// - The selected player's sector is highlighted with full opacity
/// - Other sectors are slightly dimmed (70% opacity)
/// - White separator lines are drawn between sectors
///
/// COORDINATE SYSTEM:
/// - Angles start at π/2 (pointing down, 6 o'clock position)
/// - Angles increase clockwise
/// - Each sector spans (2π / playerCount) radians
class SectorPainter extends CustomPainter {
  /// Number of players (determines how many sectors to draw)
  final int playerCount;

  /// Colors to use for each sector
  final List<Color> colors;

  /// Currently selected player index (0-based), or null if none selected
  final int? selectedPlayer;

  SectorPainter({
    required this.playerCount,
    required this.colors,
    this.selectedPlayer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Use the larger dimension so sectors bleed off all screen edges
    final radius = max(size.width, size.height);
    final sweepAngle = (2 * pi) / playerCount;

    _drawSectors(canvas, center, radius, sweepAngle);
    _drawSeparators(canvas, center, radius, sweepAngle);
    if (selectedPlayer != null) {
      _drawSelectedHighlight(canvas, size, center, radius, sweepAngle);
    }
  }

  /// Draws all filled sector arcs, dimming unselected ones.
  void _drawSectors(
    Canvas canvas,
    Offset center,
    double radius,
    double sweepAngle,
  ) {
    // Reuse a single Paint object across iterations to reduce GC pressure
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < playerCount; i++) {
      // Sector 0 starts at the bottom (add π/2 to offset from 3 o'clock)
      final startAngle = (sweepAngle * i) + pi / 2;
      final color = colors[i % colors.length];

      // Dim all sectors when a winner is shown; brighten the selected one
      paint.color = selectedPlayer == i ? color : color.withValues(alpha: 0.7);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true, // useCenter connects arc to center, making a pie slice
        paint,
      );
    }
  }

  /// Draws white separator lines between sectors.
  void _drawSeparators(
    Canvas canvas,
    Offset center,
    double radius,
    double sweepAngle,
  ) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < playerCount; i++) {
      final startAngle = (sweepAngle * i) + pi / 2;
      final lineEnd = Offset(
        center.dx + radius * cos(startAngle),
        center.dy + radius * sin(startAngle),
      );
      canvas.drawLine(center, lineEnd, linePaint);
    }
  }

  /// Draws the highlight overlay, circle badge, and player number
  /// for the winning sector.
  void _drawSelectedHighlight(
    Canvas canvas,
    Size size,
    Offset center,
    double radius,
    double sweepAngle,
  ) {
    final startAngle = (sweepAngle * selectedPlayer!) + pi / 2;

    // Semi-transparent white overlay on the winning sector
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      true,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );

    // Position the player-number badge along the mid-angle of the sector
    final midAngle = startAngle + sweepAngle / 2;
    final textRadius = min(size.width, size.height) * 0.32;
    final badgeCenter = Offset(
      center.dx + textRadius * cos(midAngle),
      center.dy + textRadius * sin(midAngle),
    );

    // White circle background for the number
    final circleRadius = min(size.width, size.height) * 0.09;
    canvas.drawCircle(badgeCenter, circleRadius, Paint()..color = Colors.white);

    // Player number label (1-based)
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${selectedPlayer! + 1}',
        style: TextStyle(
          color: colors[selectedPlayer! % colors.length],
          fontSize: min(size.width, size.height) * 0.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      badgeCenter - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant SectorPainter oldDelegate) {
    return oldDelegate.selectedPlayer != selectedPlayer ||
        oldDelegate.playerCount != playerCount ||
        oldDelegate.colors != colors;
  }
}
