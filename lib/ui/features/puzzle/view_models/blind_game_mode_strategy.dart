import 'dart:async';

import 'package:leafz/domain/models/game_mode.dart';
import 'package:leafz/domain/models/location.dart';
import 'package:leafz/helpers/game_mode_helper.dart';
import 'package:leafz/ui/core/animations/animations_manager.dart';
import 'package:leafz/ui/features/puzzle/view_models/game_mode_strategy.dart';

/// Tile numbers hide after a short delay; tap to reveal momentarily.
class BlindGameModeStrategy extends GameModeStrategy {
  @override
  GameMode get mode => GameMode.blind;

  GameModeStrategyHost? _host;

  bool _tilesBlinded = false;
  @override
  bool get tilesBlinded => _tilesBlinded;

  final Set<Location> _blindRevealedTiles = {};
  @override
  Set<Location> get blindRevealedTiles =>
      Set<Location>.unmodifiable(_blindRevealedTiles);

  Timer? _blindHideTimer;

  // ── Lifecycle ──

  @override
  void onActivate(GameModeStrategyHost host) {
    _host = host;
  }

  @override
  void onDeactivate(GameModeStrategyHost host) {
    resetBlindState();
    _host = null;
  }

  @override
  void onPuzzleGenerated(GameModeStrategyHost host) {
    startBlindTimer();
  }

  // ── Blind state ──

  @override
  void startBlindTimer() {
    resetBlindState();
    final host = _host;
    if (host == null) return;
    final delay = GameModeHelper.blindHideDelaySeconds(host.n);
    _blindHideTimer = Timer(Duration(seconds: delay), () {
      _tilesBlinded = true;
      _blindRevealedTiles.clear();
      host.notifyListeners();
    });
  }

  @override
  void revealBlindTile(Location location) {
    if (!_tilesBlinded) return;
    _blindRevealedTiles.add(location);
    _host?.notifyListeners();
    Future.delayed(AnimationsManager.blindRevealAutoHide, () {
      _blindRevealedTiles.remove(location);
      _host?.notifyListeners();
    });
  }

  @override
  bool isTileRevealed(Location location) =>
      _blindRevealedTiles.contains(location);

  @override
  void resetBlindState() {
    _tilesBlinded = false;
    _blindRevealedTiles.clear();
    _blindHideTimer?.cancel();
    _blindHideTimer = null;
  }
}
