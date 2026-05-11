import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../painters/painters.dart';
import '../widgets/widgets.dart';

/// Represents the lifecycle of a spin interaction.
enum SpinState {
  /// No spin has occurred yet — shows instruction badge
  idle,
  /// Animation is currently running — shows nothing
  spinning,
  /// Spin is complete — shows result badge
  done,
}

/// Screen 2: The Spinner
/// 
/// This screen shows:
/// - Static colored pie sectors (one per player)
/// - A spinning meeple in the center that the user taps
/// - Result display after spin completes
/// 
/// ANIMATION FLOW:
/// 1. User taps meeple → [_spin] is called
/// 2. Animation starts with ease-out curve (fast start, slow finish)
/// 3. After [AppConstants.spinDurationSeconds] seconds, animation completes
/// 4. Winner is calculated based on final rotation angle
/// 5. Result badge displays the winning player
/// 
/// STATE:
/// - [_spinState]: Current lifecycle state of the spin
/// - [_currentRotation]: Accumulated meeple angle in radians
/// - [_selectedPlayer]: Index of winning player (null until spin completes)
class SpinnerScreen extends StatefulWidget {
  /// Number of players (determines sector count)
  final int playerCount;

  const SpinnerScreen({super.key, required this.playerCount});

  @override
  State<SpinnerScreen> createState() => _SpinnerScreenState();
}

class _SpinnerScreenState extends State<SpinnerScreen>
    with SingleTickerProviderStateMixin {
  // ============================================================
  // ANIMATION
  // ============================================================

  /// Controls timing of the spin animation; reused across spins
  late final AnimationController _controller;

  /// Interpolates rotation values from start to end for each spin
  late Animation<double> _animation;

  /// Applies the easing curve; stored as a field so it can be disposed
  /// before being replaced on each new spin
  CurvedAnimation? _curvedAnimation;

  // ============================================================
  // STATE
  // ============================================================

  /// Current lifecycle state of the spin interaction
  SpinState _spinState = SpinState.idle;

  /// Accumulated rotation angle in radians (grows across multiple spins)
  double _currentRotation = 0;

  /// Index of selected player after spin (0-based), null while spinning
  int? _selectedPlayer;

  /// Random number generator for spin variation
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: AppConstants.spinDurationSeconds),
    );

    // Register the frame listener once here instead of re-adding it on
    // every spin. Since _animation is reassigned each spin, this safely
    // reads the latest tween value on every tick.
    _controller.addListener(_onAnimationTick);

    // Initialise with a trivial tween so _animation is never unset
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  @override
  void dispose() {
    _curvedAnimation?.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Updates [_currentRotation] on every animation frame.
  void _onAnimationTick() {
    setState(() => _currentRotation = _animation.value);
  }

  /// Starts the spin animation.
  /// 
  /// HOW THE SPIN WORKS:
  /// 1. Calculate total rotation = (random full spins) + (random extra angle)
  /// 2. Create a Tween from current rotation to (current + total)
  /// 3. Apply easeOutCubic curve for natural deceleration
  /// 4. When complete, calculate which sector the meeple points to
  void _spin() {
    if (_spinState == SpinState.spinning) return;

    setState(() {
      _spinState = SpinState.spinning;
      _selectedPlayer = null;
    });

    // Random number of full rotations for visual effect, plus a fractional
    // angle that determines the actual winner
    final fullRotations = AppConstants.minSpinRotations +
        _random.nextInt(AppConstants.maxExtraRotations);
    final extraRotation = _random.nextDouble() * 2 * pi;
    final totalRotation = fullRotations * 2 * pi + extraRotation;

    // Dispose old CurvedAnimation before creating a replacement to remove
    // its internal listener from _controller
    _curvedAnimation?.dispose();
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      // easeOutCubic: fast start, gradually slows to a halt (realistic spinner)
      curve: Curves.easeOutCubic,
    );

    _animation = Tween<double>(
      begin: _currentRotation,
      end: _currentRotation + totalRotation,
    ).animate(_curvedAnimation!);

    _controller.reset();
    _controller.forward().then((_) => _calculateWinner());
  }

  /// Calculates which player won based on the final rotation angle.
  /// 
  /// The meeple SVG points upward (12 o'clock) at angle 0. Sectors are also
  /// laid out starting at the top, so the winning sector is simply whichever
  /// sector the meeple's tip is pointing at after normalising to 0–2π.
  void _calculateWinner() {
    final normalizedRotation = _currentRotation % (2 * pi);
    final sectorAngle = (2 * pi) / widget.playerCount;
    final selectedIndex =
        (normalizedRotation / sectorAngle).floor() % widget.playerCount;

    setState(() {
      _spinState = SpinState.done;
      _selectedPlayer = selectedIndex;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.spinnerGradient,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Layer 1: Static colored sectors (full screen)
              _buildSectors(),
              // Layer 2: Spinning meeple (center)
              _buildMeeple(),
              // Layer 3: Back button (top-right)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              // Layer 4: Result badge or instructions (bottom / top)
              Positioned.fill(child: _buildBottomUI()),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the static colored sector background.
  Widget _buildSectors() {
    return CustomPaint(
      painter: SectorPainter(
        playerCount: widget.playerCount,
        colors: AppColors.sectorColors,
        selectedPlayer: _selectedPlayer,
      ),
      size: Size.infinite,
    );
  }

  /// Builds the tappable spinning meeple in the center.
  Widget _buildMeeple() {
    return Center(
      child: GestureDetector(
        onTap: _spin,
        child: SpinningMeeple(rotation: _currentRotation),
      ),
    );
  }

  /// True when the meeple is pointing generally downward (π/2 to 3π/2).
  /// Used to reposition the result badge so it doesn't overlap the meeple tip.
  bool get _meeplePointsDown {
    final normalized = _currentRotation % (2 * pi);
    return normalized > pi / 2 && normalized < 3 * pi / 2;
  }

  /// Builds the overlay area that shows instructions or the result badge.
  /// 
  /// Badge is placed at the bottom normally, or at the top when the meeple
  /// tip is pointing downward to avoid overlapping it.
  Widget _buildBottomUI() {
    final showAtTop = _spinState == SpinState.done && _meeplePointsDown;
    return Stack(
      children: [
        Positioned(
          top: showAtTop ? 40 : null,
          bottom: showAtTop ? null : 40,
          left: 0,
          right: 0,
          child: Center(child: _buildResultOrInstructions()),
        ),
      ],
    );
  }

  /// Shows the result badge, instruction badge, or nothing depending on state.
  Widget _buildResultOrInstructions() {
    switch (_spinState) {
      case SpinState.done:
        return ResultBadge(selectedPlayer: _selectedPlayer!);
      case SpinState.idle:
        return const InstructionBadge();
      case SpinState.spinning:
        return const SizedBox.shrink();
    }
  }
}
