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
/// - Angles start at -π/2 (pointing up, 12 o'clock position)
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
    // Calculate center point and radius
    // We use the larger dimension to ensure sectors cover the entire screen
    final center = Offset(size.width / 2, size.height / 2);
    final radius = max(size.width, size.height);
    
    // Calculate the angle each sector spans
    // Full circle (2π radians) divided by number of players
    final sweepAngle = (2 * pi) / playerCount;

    // Draw each player's sector
    for (int i = 0; i < playerCount; i++) {
      // Calculate starting angle for this sector
      // We subtract π/2 so sector 0 starts at the top (12 o'clock)
      final startAngle = (sweepAngle * i) - pi / 2;
      
      // Get color for this sector (cycling through colors if > 12 players)
      final color = colors[i % colors.length];
      
      // Create paint with appropriate opacity
      // Selected sector is brighter, others are dimmed
      final paint = Paint()
        ..color = selectedPlayer == i
            ? color
            : color.withValues(alpha: 0.7)
        ..style = PaintingStyle.fill;

      // Draw the pie slice (arc from center)
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true, // useCenter: connects arc ends to center, making a pie slice
        paint,
      );

      // Draw white separator line at the start of each sector
      final linePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      // Calculate the end point of the separator line
      final lineEnd = Offset(
        center.dx + radius * cos(startAngle),
        center.dy + radius * sin(startAngle),
      );
      canvas.drawLine(center, lineEnd, linePaint);
    }

    // Draw extra highlight on the selected sector
    if (selectedPlayer != null) {
      final startAngle = (sweepAngle * selectedPlayer!) - pi / 2;
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        highlightPaint,
      );

      // Draw player number in the center of the highlighted sector
      final midAngle = startAngle + sweepAngle / 2;
      final textRadius = min(size.width, size.height) * 0.32;
      final textCenter = Offset(
        center.dx + textRadius * cos(midAngle),
        center.dy + textRadius * sin(midAngle),
      );

      // Draw white circle background
      final circleRadius = min(size.width, size.height) * 0.09;
      canvas.drawCircle(
        textCenter,
        circleRadius,
        Paint()..color = Colors.white,
      );

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
        textCenter - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant SectorPainter oldDelegate) {
    // Only repaint if something changed that affects the visuals
    return oldDelegate.selectedPlayer != selectedPlayer ||
        oldDelegate.playerCount != playerCount;
  }
}
