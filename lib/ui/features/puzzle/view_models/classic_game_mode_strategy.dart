import 'package:leafz/domain/models/game_mode.dart';
import 'package:leafz/ui/features/puzzle/view_models/game_mode_strategy.dart';

/// No special behavior beyond the core tile-swapping puzzle.
class ClassicGameModeStrategy extends GameModeStrategy {
  @override
  GameMode get mode => GameMode.classic;

  // All lifecycle hooks use default no-ops.
  // Score saving is handled by PuzzleProvider.handlePuzzleSolved.
}
