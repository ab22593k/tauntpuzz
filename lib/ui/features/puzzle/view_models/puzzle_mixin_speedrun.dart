import 'package:jigsaw/helpers/game_mode_helper.dart';
import 'package:flutter/foundation.dart';

/// Mixin that adds speedrun puzzle mode fields (countdown override and
/// countdown seconds getter) to a [ChangeNotifier] provider.
///
/// ## Position in the mixin chain
/// This is the **leftmost** puzzle mixin — it depends only on `n`, which is
/// provided directly by [PuzzleProvider]. Mixins applied to its right
/// (e.g. [PuzzleMixinBlind], [PuzzleMixinMarathon]) inherit its symbols.
///
/// Full chain: `Speedrun → Blind → Marathon → Core → Orchestrator`
mixin PuzzleMixinSpeedrun on ChangeNotifier {
  /// Puzzle size — must be provided by the parent class.
  int get n;

  // ──────────────────────────────────────────────
  // Speedrun State
  // ──────────────────────────────────────────────

  /// Override value for the stop-watch seconds, used when
  /// the provider needs to control the elapsed/countdown time.
  int stopWatchSecondsOverride = 0;

  /// Speedrun: countdown seconds for the current puzzle size.
  int get speedrunCountdownSeconds =>
      GameModeHelper.speedrunCountdownSeconds(n);
}
