import 'dart:async';

import 'package:tauntpuzz/domain/models/location.dart';
import 'package:tauntpuzz/helpers/game_mode_helper.dart';
import 'package:flutter/foundation.dart';

/// Mixin that adds blind puzzle mode logic (tiles hide after a delay,
/// tap to reveal temporarily) to a [ChangeNotifier] provider.
mixin PuzzleMixinBlind on ChangeNotifier {
  /// Puzzle size — must be provided by the parent class.
  int get n;

  // ──────────────────────────────────────────────
  // Blind Mode State
  // ──────────────────────────────────────────────

  bool _tilesBlinded = false;
  bool get tilesBlinded => _tilesBlinded;

  final Set<Location> _blindRevealedTiles = {};
  Set<Location> get blindRevealedTiles => Set.unmodifiable(_blindRevealedTiles);

  Timer? _blindHideTimer;

  /// Starts the countdown before tiles are hidden.
  void startBlindTimer() {
    resetBlindState();
    final delay = GameModeHelper.blindHideDelaySeconds(n);
    _blindHideTimer = Timer(Duration(seconds: delay), () {
      _tilesBlinded = true;
      _blindRevealedTiles.clear();
      notifyListeners();
    });
  }

  /// Reveals a tile at [location] for 1.5 seconds (only while blinded).
  void revealBlindTile(Location location) {
    if (!_tilesBlinded) return;
    _blindRevealedTiles.add(location);
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 1500), () {
      _blindRevealedTiles.remove(location);
      notifyListeners();
    });
  }

  /// Whether the tile at [location] is currently revealed.
  bool isTileRevealed(Location location) =>
      _blindRevealedTiles.contains(location);

  /// Resets blind mode state: tiles visible again, timers cancelled.
  void resetBlindState() {
    _tilesBlinded = false;
    _blindRevealedTiles.clear();
    _blindHideTimer?.cancel();
    _blindHideTimer = null;
  }
}
