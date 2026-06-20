import 'package:flutter/material.dart';

/// Centralized color definitions for the app.
/// 
/// This class contains all the colors used throughout the app,
/// making it easy to maintain a consistent color scheme and
/// update colors in one place.
class AppColors {
  // Prevent instantiation - this is a utility class
  AppColors._();

  // ============================================================
  // PLAYER SECTOR COLORS
  // ============================================================
  // These colors are used for the pie chart sectors on the spinner screen.
  // Each player gets a unique vibrant color from this list.
  // The list uses popular board game player colors.
  
  static const List<Color> sectorColors = [
    Color(0xFFE53935), // Red - Player 1
    Color(0xFF1E88E5), // Blue - Player 2
    Color(0xFF43A047), // Green - Player 3
    Color(0xFFFDD835), // Yellow - Player 4
    Color(0xFF000000), // Black - Player 5
    Color(0xFFFFFFFF), // White - Player 6
    Color(0xFFFB8C00), // Orange - Player 7
    Color(0xFF8E24AA), // Purple - Player 8
    Color(0xFF6D4C41), // Brown - Player 9
    Color(0xFFEC407A), // Pink - Player 10
    Color(0xFF757575), // Gray - Player 11
    Color(0xFF00897B), // Teal - Player 12
    Color(0xFF00ACC1), // Cyan - Player 13
    Color(0xFFD2B48C), // Tan - Player 14
    Color(0xFFFFD700), // Gold - Player 15
    Color(0xFFC0C0C0), // Silver - Player 16
  ];

  // ============================================================
  // GRADIENT COLORS
  // ============================================================
  // Background gradients for different screens
  
  /// Player selection screen gradient (purple tones)
  static final List<Color> playerSelectGradient = [
    Colors.deepPurple.shade900,
    Colors.indigo.shade900,
  ];

  /// Spinner screen gradient (dark tones)
  static final List<Color> spinnerGradient = [
    Colors.grey.shade900,
    Colors.black,
  ];

  // ============================================================
  // UI ELEMENT COLORS
  // ============================================================
  
  /// Primary button color (amber/yellow)
  static const Color primaryButton = Colors.amber;
  
  /// Primary button text color
  static const Color primaryButtonText = Colors.black87;

  /// Semi-transparent white for overlays and backgrounds
  static Color overlayWhite(double alpha) => Colors.white.withValues(alpha: alpha);
  
  /// Semi-transparent black for shadows
  static Color shadowBlack(double alpha) => Colors.black.withValues(alpha: alpha);
}
