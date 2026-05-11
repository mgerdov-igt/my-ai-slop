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
  // The list supports up to 12 players (the app's maximum).
  
  static const List<Color> sectorColors = [
    Color(0xFFE53935), // Red - Player 1
    Color(0xFF1E88E5), // Blue - Player 2
    Color(0xFF43A047), // Green - Player 3
    Color(0xFFFFB300), // Amber - Player 4
    Color(0xFF8E24AA), // Purple - Player 5
    Color(0xFF00ACC1), // Cyan - Player 6
    Color(0xFFFF7043), // Deep Orange - Player 7
    Color(0xFF5C6BC0), // Indigo - Player 8
    Color(0xFF26A69A), // Teal - Player 9
    Color(0xFFEC407A), // Pink - Player 10
    Color(0xFF66BB6A), // Light Green - Player 11
    Color(0xFFAB47BC), // Light Purple - Player 12
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
  static const Color primaryButtonText = Color(0xDD000000); // Colors.black87

  /// Semi-transparent white for overlays and backgrounds
  static Color overlayWhite(double alpha) => Colors.white.withValues(alpha: alpha);
  
  /// Semi-transparent black for shadows
  static Color shadowBlack(double alpha) => Colors.black.withValues(alpha: alpha);
}
