import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../widgets/widgets.dart';
import 'spinner_screen.dart';

/// Screen 1: Player Count Selection
/// 
/// This is the entry screen where users select how many players
/// will be playing (2-12). The user can:
/// - Tap + to increase player count
/// - Tap - to decrease player count
/// - Tap START to proceed to the spinner
/// 
/// STATE:
/// - _playerCount: Current selected number of players
class PlayerCountScreen extends StatefulWidget {
  const PlayerCountScreen({super.key});

  @override
  State<PlayerCountScreen> createState() => _PlayerCountScreenState();
}

class _PlayerCountScreenState extends State<PlayerCountScreen> {
  // Current player count, starts at the default (6)
  int _playerCount = AppConstants.defaultPlayers;

  /// Decreases player count by 1 (if above minimum)
  void _decrementPlayers() {
    if (_playerCount > AppConstants.minPlayers) {
      setState(() => _playerCount--);
    }
  }

  /// Increases player count by 1 (if below maximum)
  void _incrementPlayers() {
    if (_playerCount < AppConstants.maxPlayers) {
      setState(() => _playerCount++);
    }
  }

  /// Navigates to the spinner screen with the selected player count
  void _startGame() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SpinnerScreen(playerCount: _playerCount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Purple gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.playerSelectGradient,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Who's Turn?",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black45,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select number of players',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 60),
                // Player count selector (- [count] +)
                _buildPlayerCounter(),
                const SizedBox(height: 60),
                // Start button
                _buildStartButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the player count selector row
  Widget _buildPlayerCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decrement button (disabled at minimum)
        CounterButton(
          icon: Icons.remove,
          onPressed: _playerCount > AppConstants.minPlayers
              ? _decrementPlayers
              : null,
        ),
        // Current count display
        Container(
          width: 120,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.overlayWhite(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '$_playerCount',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        // Increment button (disabled at maximum)
        CounterButton(
          icon: Icons.add,
          onPressed: _playerCount < AppConstants.maxPlayers
              ? _incrementPlayers
              : null,
        ),
      ],
    );
  }

  /// Builds the START button
  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: _startGame,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryButton,
        foregroundColor: AppColors.primaryButtonText,
        padding: const EdgeInsets.symmetric(
          horizontal: 48,
          vertical: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.startButtonBorderRadius),
        ),
      ),
      child: const Text(
        'START',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
