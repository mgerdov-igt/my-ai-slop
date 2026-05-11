import 'package:flutter/material.dart';
import 'screens/screens.dart';

/// Entry point of the Who's Turn app.
/// 
/// This app helps determine which player goes first in a board game
/// by spinning a meeple over colored player sectors.
void main() {
  runApp(const WhosTurnApp());
}

/// Root widget of the application.
/// 
/// Sets up:
/// - Material 3 theming with dark purple color scheme
/// - Debug banner disabled for clean UI
/// - PlayerCountScreen as the home screen
class WhosTurnApp extends StatelessWidget {
  const WhosTurnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // App name shown in app switchers
      title: "Who's Turn",
      
      // Hide the debug banner in the corner
      debugShowCheckedModeBanner: false,
      
      // Dark theme with purple accent
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      
      // Start at the player selection screen
      home: const PlayerCountScreen(),
    );
  }
}
