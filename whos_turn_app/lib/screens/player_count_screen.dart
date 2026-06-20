import 'dart:math';

import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../painters/painters.dart';
import '../services/sector_color_preferences.dart';
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

class _PlayerCountScreenState extends State<PlayerCountScreen>
    with TickerProviderStateMixin {
  // Current player count, starts at the default (6)
  int _playerCount = AppConstants.defaultPlayers;

  /// Colors used by the animated watermark background.
  List<Color> _watermarkColors = List<Color>.from(
    AppColors.sectorColors.take(AppConstants.defaultPlayers),
  );

  /// Slowly rotates the background sectors.
  late final AnimationController _watermarkRotationController;

  /// Drives the initial ease-in fade of the watermark on screen entry.
  late final AnimationController _watermarkFadeController;
  late final Animation<double> _watermarkFadeAnim;

  /// Prevents stale async color loads from overwriting newer selections.
  int _loadToken = 0;

  @override
  void initState() {
    super.initState();

    // Pre-seed from session cache synchronously so the very first frame
    // already has the correct colors. This prevents AnimatedSwitcher from
    // firing a crossfade transition the instant the screen appears.
    final cached = SectorColorPreferences.getCached(_playerCount);
    if (cached != null) {
      _watermarkColors = cached;
    }

    _watermarkRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 90),
    )..repeat();

    _watermarkFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _watermarkFadeAnim = CurvedAnimation(
      parent: _watermarkFadeController,
      curve: Curves.easeIn,
    );
    _watermarkFadeController.forward();

    _refreshWatermarkColors();
  }

  @override
  void dispose() {
    _watermarkRotationController.dispose();
    _watermarkFadeController.dispose();
    super.dispose();
  }

  void _updatePlayerCount(int nextCount) {
    setState(() {
      _playerCount = nextCount;
      // Immediate fallback so the animation updates instantly while persisted
      // colors are fetched asynchronously.
      _watermarkColors = List<Color>.from(
        AppColors.sectorColors.take(nextCount),
      );
    });
    _refreshWatermarkColors();
  }

  Future<void> _refreshWatermarkColors() async {
    // Apply session cache synchronously — zero-frame latency within a session.
    final cached = SectorColorPreferences.getCached(_playerCount);
    if (cached != null) {
      if (!_colorsMatch(cached, _watermarkColors)) {
        setState(() => _watermarkColors = cached);
      }
      return;
    }

    // Cold start: fetch from disk.
    final currentToken = ++_loadToken;
    final loaded = await SectorColorPreferences.loadColors(_playerCount);
    if (!mounted || currentToken != _loadToken) return;
    if (!_colorsMatch(loaded, _watermarkColors)) {
      setState(() => _watermarkColors = loaded);
    }
  }

  /// Returns true when [a] and [b] contain the same color values in order.
  static bool _colorsMatch(List<Color> a, List<Color> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Decreases player count by 1 (if above minimum)
  void _decrementPlayers() {
    if (_playerCount > AppConstants.minPlayers) {
      _updatePlayerCount(_playerCount - 1);
    }
  }

  /// Increases player count by 1 (if below maximum)
  void _incrementPlayers() {
    if (_playerCount < AppConstants.maxPlayers) {
      _updatePlayerCount(_playerCount + 1);
    }
  }

  /// Navigates to the spinner screen with the selected player count.
  /// On return, replays the watermark fade-in and refreshes colors in case
  /// the user customised sectors while on the spinner screen.
  void _startGame() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => SpinnerScreen(playerCount: _playerCount),
          ),
        )
        .then((_) {
          if (!mounted) return;
          _watermarkFadeController
            ..reset()
            ..forward();
          _refreshWatermarkColors();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: FadeTransition(
              opacity: _watermarkFadeAnim,
              child: _buildWatermarkBackground(),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xB3161720), Color(0xCC07080C)],
                ),
              ),
            ),
          ),
          SafeArea(
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
                    style: TextStyle(fontSize: 20, color: Colors.white70),
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
        ],
      ),
    );
  }

  Widget _buildWatermarkBackground() {
    final displayColors = _watermarkColors
        .take(_playerCount)
        .map((color) => color.withValues(alpha: 0.28))
        .toList(growable: false);

    final backgroundKey =
        '${_playerCount}_'
        '${displayColors.map((c) => c.toARGB32()).join('_')}';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.985, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: _WatermarkLayer(
        key: ValueKey(backgroundKey),
        playerCount: _playerCount,
        colors: displayColors,
        rotationController: _watermarkRotationController,
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C2A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
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
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.startButtonBorderRadius,
          ),
        ),
      ),
      child: const Text(
        'START',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _WatermarkLayer extends StatelessWidget {
  final int playerCount;
  final List<Color> colors;
  final AnimationController rotationController;

  const _WatermarkLayer({
    super.key,
    required this.playerCount,
    required this.colors,
    required this.rotationController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: rotationController,
      builder: (context, _) {
        return Transform.rotate(
          angle: rotationController.value * 2 * pi,
          child: CustomPaint(
            painter: SectorPainter(
              playerCount: playerCount,
              colors: colors,
              selectedPlayer: null,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}
