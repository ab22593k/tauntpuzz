import 'package:jigsaw/domain/models/game_mode.dart';
import 'package:jigsaw/generated/app_localizations.dart';

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

  /// Localized name for a game mode.
  static String localizedName(GameMode mode, AppLocalizations l10n) =>
      switch (mode) {
        GameMode.classic => l10n.gameModeClassic,
        GameMode.speedrun => l10n.gameModeSpeedrun,
        GameMode.blind => l10n.gameModeBlind,
        GameMode.marathon => l10n.gameModeMarathon,
      };

  /// Localized description for a game mode.
  static String localizedDescription(GameMode mode, AppLocalizations l10n) =>
      switch (mode) {
        GameMode.classic => l10n.gameModeClassicDesc,
        GameMode.speedrun => l10n.gameModeSpeedrunDesc,
        GameMode.blind => l10n.gameModeBlindDesc,
        GameMode.marathon => l10n.gameModeMarathonDesc,
      };
}
