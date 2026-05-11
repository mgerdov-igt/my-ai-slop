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
  
  /// Maximum additional rotations (randomized)
  /// Total rotations = minSpinRotations + random(0, maxExtraRotations)
  static const int maxExtraRotations = 6;

  // ============================================================
  // MEEPLE WIDGET SIZING
  // ============================================================
  
  /// Size of the meeple container (white circle)
  static const double meepleSize = 240.0;
  
  /// Padding inside the meeple container
  static const double meeplePadding = 10.0;

  // ============================================================
  // ASSET PATHS
  // ============================================================
  
  /// Path to the meeple SVG image
  static const String meepleAssetPath = 'assets/images/meeple.svg';
}
