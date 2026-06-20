import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

/// Persists customized sector colors per player count.
class SectorColorPreferences {
  SectorColorPreferences._();

  static final Map<int, List<Color>> _sessionCache = <int, List<Color>>{};

  static String _keyForPlayerCount(int playerCount) =>
      'sector_colors_$playerCount';

  /// Returns cached colors synchronously for [playerCount], or null if the
  /// cache has not been populated yet for that count.
  static List<Color>? getCached(int playerCount) {
    final cached = _sessionCache[playerCount];
    if (cached != null && cached.length == playerCount) {
      return List<Color>.from(cached);
    }
    return null;
  }

  /// Loads colors for [playerCount] from storage, or defaults if unset/invalid.
  static Future<List<Color>> loadColors(int playerCount) async {
    final cached = _sessionCache[playerCount];
    if (cached != null && cached.length == playerCount) {
      return List<Color>.from(cached);
    }

    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_keyForPlayerCount(playerCount));
    if (values != null && values.length == playerCount) {
      final parsedExact = _parseColors(values, playerCount);
      if (parsedExact != null) {
        _sessionCache[playerCount] = List<Color>.from(parsedExact);
        return parsedExact;
      }
    }

    // If exact colors do not exist for this player count, inherit from a
    // larger saved setup by taking its first N sector colors.
    for (int count = AppConstants.maxPlayers; count > playerCount; count--) {
      final largerValues = prefs.getStringList(_keyForPlayerCount(count));
      if (largerValues == null || largerValues.length != count) continue;

      final parsedLarger = _parseColors(largerValues, count);
      if (parsedLarger != null) {
        final inherited = List<Color>.from(parsedLarger.take(playerCount));
        _sessionCache[playerCount] = List<Color>.from(inherited);
        return inherited;
      }
    }

    final defaults = List<Color>.from(AppColors.sectorColors.take(playerCount));
    _sessionCache[playerCount] = List<Color>.from(defaults);
    return defaults;
  }

  /// Saves colors for [playerCount].
  static Future<void> saveColors(int playerCount, List<Color> colors) async {
    final normalized = List<Color>.from(colors.take(playerCount));
    _sessionCache[playerCount] = normalized;

    final prefs = await SharedPreferences.getInstance();
    final values = normalized
        .map((color) => color.toARGB32().toString())
        .toList(growable: false);
    await prefs.setStringList(_keyForPlayerCount(playerCount), values);
  }

  static List<Color>? _parseColors(List<String> values, int expectedCount) {
    final parsed = values
        .map((value) => int.tryParse(value))
        .whereType<int>()
        .map(Color.new)
        .toList(growable: false);

    if (parsed.length != expectedCount) {
      return null;
    }

    return parsed;
  }
}
