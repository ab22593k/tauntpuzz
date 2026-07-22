import 'dart:convert';

import 'package:leafz/domain/models/game_mode.dart';

class Score {
  final int secondsElapsed;
  final int movesCount;
  final int puzzleSize;
  final GameMode gameMode;

  /// When the score was recorded, in milliseconds since epoch.
  ///
  /// Nullable for backward compatibility with scores persisted before this
  /// field was added. Scores with null timestamps are treated as the oldest
  /// when sorting.
  final DateTime? timestamp;

  const Score({
    required this.secondsElapsed,
    required this.movesCount,
    required this.puzzleSize,
    this.gameMode = GameMode.classic,
    this.timestamp,
  });

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      secondsElapsed: json['secondsElapsed'],
      movesCount: json['movesCount'],
      puzzleSize: json['puzzleSize'],
      gameMode: json['gameMode'] != null
          ? GameMode.values.byName(json['gameMode'])
          : GameMode.classic,
      timestamp: json['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['timestamp'] as num).toInt(),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'secondsElapsed': secondsElapsed,
      'movesCount': movesCount,
      'puzzleSize': puzzleSize,
      'gameMode': gameMode.name,
      if (timestamp != null) 'timestamp': timestamp!.millisecondsSinceEpoch,
    };
  }

  static List<dynamic> toJsonList(List<Score> scores) =>
      List<dynamic>.from(scores.map((x) => x.toJson()));

  static List<Score> fromJsonList(dynamic scores) => List<Score>.from(
    json.decode(json.encode(scores)).map((x) => Score.fromJson(x)),
  );
}
