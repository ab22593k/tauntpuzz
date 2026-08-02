import 'package:leafz/domain/models/game_mode.dart';
import 'package:leafz/helpers/game_mode_helper.dart';
import 'package:leafz/ui/features/puzzle/view_models/game_mode_strategy.dart';

/// Adds a countdown timer: [speedrunCountdownSeconds] provides the limit
/// for the current puzzle size.  Timer display is handled by the UI layer
/// ([StopWatchProvider]).
class SpeedrunGameModeStrategy extends GameModeStrategy {
  @override
  GameMode get mode => GameMode.speedrun;

  GameModeStrategyHost? _host;

  @override
  void onActivate(GameModeStrategyHost host) {
    _host = host;
  }

  @override
  void onDeactivate(GameModeStrategyHost host) {
    _host = null;
  }

  @override
  int get speedrunCountdownSeconds {
    final host = _host;
    return switch (host) {
      final h? => GameModeHelper.speedrunCountdownSeconds(h.n),
      _ => 0,
    };
  }
}
