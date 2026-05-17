/// Represents the active game mode variant.
enum GameMode {
  /// Standard puzzle — solve at your own pace.
  classic,

  /// Timer counts down from a size-dependent limit. Timer stops at 0, keep solving.
  speedrun,

  /// Tile numbers hide after a short period. Tap to reveal momentarily.
  blind,

  /// Chain-solve through a user-defined size range.
  marathon,
}
