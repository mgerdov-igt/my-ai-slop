import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../painters/painters.dart';
import '../widgets/widgets.dart';

/// Screen 2: The Spinner
/// 
/// This screen shows:
/// - Static colored pie sectors (one per player)
/// - A spinning meeple in the center that the user taps
/// - Result display after spin completes
/// - Spin Again and Back buttons
/// 
/// ANIMATION FLOW:
/// 1. User taps meeple → _spin() is called
/// 2. Animation starts with ease-out curve (fast start, slow finish)
/// 3. After 5 seconds, animation completes
/// 4. Winner is calculated based on final rotation angle
/// 5. Result badge displays the winning player
/// 
/// STATE:
/// - _currentRotation: Current angle of meeple in radians
/// - _selectedPlayer: Index of winning player (null until spin completes)
/// - _isSpinning: True while animation is running
/// - _hasSpun: True after first spin (shows "Spin Again" button)
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
  // ANIMATION CONTROLLER
  // ============================================================
  // Controls the timing of the spin animation
  late AnimationController _controller;
  
  // The actual animation that interpolates rotation values
  late Animation<double> _animation;
  
  // ============================================================
  // STATE VARIABLES
  // ============================================================
  
  /// Current rotation angle in radians (accumulates across spins)
  double _currentRotation = 0;
  
  /// Index of selected player after spin (0-based), null while spinning
  int? _selectedPlayer;
  
  /// True while the spin animation is running
  bool _isSpinning = false;
  
  /// True after the user has spun at least once
  bool _hasSpun = false;
  
  /// Random number generator for spin variation
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    // Duration matches the total spin time
    _controller = AnimationController(
      vsync: this, // Syncs to screen refresh for smooth animation
      duration: Duration(seconds: AppConstants.spinDurationSeconds),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when widget is removed
    _controller.dispose();
    super.dispose();
  }

  /// Starts the spin animation.
  /// 
  /// HOW THE SPIN WORKS:
  /// 1. Calculate total rotation = (random full spins) + (random extra angle)
  /// 2. Create a Tween from current rotation to (current + total)
  /// 3. Apply easeOutCubic curve for natural deceleration
  /// 4. Listen to animation values to update _currentRotation
  /// 5. When complete, calculate which sector the meeple points to
  void _spin() {
    // Prevent starting a new spin while one is in progress
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
      _hasSpun = true;
      _selectedPlayer = null; // Clear previous result
    });

    // Calculate how much to rotate:
    // - 3-6 full rotations (2π each) for visual effect
    // - Plus a random extra angle to determine winner
    final fullRotations = AppConstants.minSpinRotations + 
        _random.nextInt(AppConstants.maxExtraRotations);
    final extraRotation = _random.nextDouble() * 2 * pi;
    final totalRotation = fullRotations * 2 * pi + extraRotation;

    // Create the animation from current position to final position
    _animation = Tween<double>(
      begin: _currentRotation,
      end: _currentRotation + totalRotation,
    ).animate(CurvedAnimation(
      parent: _controller,
      // easeOutCubic: fast at start, gradually slows down (like a real spinner)
      curve: Curves.easeOutCubic,
    ));

    // Update _currentRotation on each frame
    _animation.addListener(() {
      setState(() {
        _currentRotation = _animation.value;
      });
    });

    // Start the animation
    _controller.reset();
    _controller.forward().then((_) {
      // Animation complete - calculate winner
      _calculateWinner();
    });
  }

  /// Calculates which player won based on the final rotation angle.
  /// 
  /// The meeple points "up" at angle 0, so we need to figure out
  /// which sector is at the top when the meeple stops.
  void _calculateWinner() {
    // Normalize rotation to 0-2π range
    final normalizedRotation = _currentRotation % (2 * pi);
    
    // Calculate the angle span of each sector
    final sectorAngle = (2 * pi) / widget.playerCount;
    
    // Determine which sector the rotation points to
    final selectedIndex = (normalizedRotation / sectorAngle).floor() % widget.playerCount;
    
    setState(() {
      _isSpinning = false;
      _selectedPlayer = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Dark gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.spinnerGradient,
          ),
        ),
        child: SafeArea(
          // Stack allows layering: sectors behind, meeple on top
          child: Stack(
            children: [
              // Layer 1: Static colored sectors (full screen)
              _buildSectors(),
              
              // Layer 2: Spinning meeple (center)
              _buildMeeple(),
              
              // Layer 3: Back button top-right
              Positioned(
                top: 8,
                right: 8,
                child: SafeArea(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              // Layer 4: Result badge / instructions
              Positioned.fill(child: _buildBottomUI()),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the static colored sector background
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

  /// Builds the spinning meeple in the center
  Widget _buildMeeple() {
    return Center(
      child: GestureDetector(
        onTap: _spin, // Tap to spin
        child: SpinningMeeple(rotation: _currentRotation),
      ),
    );
  }

  /// True if the meeple is pointing generally downward
  bool get _meeplePointsDown {
    final normalized = _currentRotation % (2 * pi);
    return normalized > pi / 2 && normalized < 3 * pi / 2;
  }

  /// Builds the UI area with result badge or instructions
  Widget _buildBottomUI() {
    final pointsDown = _selectedPlayer != null && _meeplePointsDown;
    return Stack(
      children: [
        Positioned(
          top: pointsDown ? 40 : null,
          bottom: pointsDown ? null : 40,
          left: 0,
          right: 0,
          child: Center(child: _buildResultOrInstructions()),
        ),
      ],
    );
  }

  /// Shows either the result badge or instruction text
  Widget _buildResultOrInstructions() {
    if (_selectedPlayer != null) {
      // Spin complete - show winner
      return ResultBadge(selectedPlayer: _selectedPlayer!);
    } else if (!_hasSpun) {
      // Haven't spun yet - show instructions
      return const InstructionBadge();
    }
    // Currently spinning - show nothing
    return const SizedBox.shrink();
  }
}
