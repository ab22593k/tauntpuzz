import 'package:lullaby/domain/models/game_mode.dart';

/// Constants and helpers shared across the game mode system.
class GameModeHelper {
  /// Speedrun: seconds allocated per puzzle size.
  /// Formula: max(60, size² × 15 - 60)
  static int speedrunCountdownSeconds(int puzzleSize) =>
      [60, 180, 300, 480][puzzleSize - 3];

  /// Blind: seconds before tile numbers are hidden.
  /// Formula: size × 5 + (size - 3) × 5
  static int blindHideDelaySeconds(int puzzleSize) =>
      puzzleSize * 5 + (puzzleSize - 3) * 5;

  /// Human-readable label for a mode.
  static String displayName(GameMode mode) => switch (mode) {
        GameMode.classic => 'Classic',
        GameMode.speedrun => 'Speedrun',
        GameMode.blind => 'Blind',
        GameMode.marathon => 'Marathon',
      };

  /// Short description of the mode.
  static String description(GameMode mode) => switch (mode) {
        GameMode.classic => 'Solve at your own pace',
        GameMode.speedrun => 'Beat the countdown',
        GameMode.blind => 'Tiles hide — tap to peek',
        GameMode.marathon => 'Chain-solve across sizes',
      };
}
