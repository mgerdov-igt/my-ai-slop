/// Centralized constants for the app.
/// 
/// This file contains magic numbers and configuration values
/// that are used across the app. Keeping them here makes it
/// easy to tweak the app's behavior without hunting through code.
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // ============================================================
  // PLAYER COUNT LIMITS
  // ============================================================
  
  /// Minimum number of players allowed
  static const int minPlayers = 2;
  
  /// Maximum number of players allowed
  static const int maxPlayers = 12;
  
  /// Default starting player count
  static const int defaultPlayers = 6;

  // ============================================================
  // SPINNER ANIMATION
  // ============================================================
  
  /// How long the spin animation takes (in seconds)
  static const int spinDurationSeconds = 8;
  
  /// Minimum number of full rotations during a spin
  static const int minSpinRotations = 5;
  
  /// Maximum additional rotations (randomized).
  /// [Random.nextInt] returns 0 to maxExtraRotations-1, so actual
  /// total rotations range from minSpinRotations to
  /// minSpinRotations + maxExtraRotations - 1.
  static const int maxExtraRotations = 6;

  // ============================================================
  // MEEPLE WIDGET SIZING
  // ============================================================
  
  /// Size of the meeple container
  static const double meepleSize = 240.0;
  
  /// Padding inside the meeple container
  static const double meeplePadding = 10.0;

  // ============================================================
  // UI SHAPE CONSTANTS
  // ============================================================
  
  /// Border radius used for result and instruction badges
  static const double badgeBorderRadius = 20.0;
  
  /// Border radius used for the START button
  static const double startButtonBorderRadius = 30.0;
}
