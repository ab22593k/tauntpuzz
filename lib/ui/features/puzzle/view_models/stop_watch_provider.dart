import 'dart:async';

import 'package:lullaby/data/services/storage_service.dart';
import 'package:flutter/cupertino.dart';

/// Manages the puzzle timer using a periodic stream.
///
/// Supports two modes:
/// - **Count-up** (classic / blind / marathon): increments [secondsElapsed]
///   each second and persists the value to [StorageService].
/// - **Countdown** (speedrun): counts down from a configured total, sets
///   [isCountdownExpired] when it reaches zero.
///
/// Lifecycle:
///   1. `init()` — restores [secondsElapsed] from storage
///   2. `configureCountdown()` — switches to countdown mode
///   3. `start()` — begins/resumes the timer stream
///   4. `stop()` — pauses and resets all state; persists zero
///   5. `cancel()` — disposes of the stream subscription (use in dispose)
///
/// In count-up mode, persisting happens on every tick so the elapsed time
/// survives app restarts. In countdown mode, no persistence is needed since
/// the timer resets on each puzzle.
class StopWatchProvider with ChangeNotifier {
  Stream<int> timeStream =
      Stream.periodic(const Duration(seconds: 1), (x) => 1 + x++);

  final StorageService storageService;

  StopWatchProvider(this.storageService);

  StreamSubscription<int>? streamSubscription;

  int secondsElapsed = 0;

  /// Countdown mode (used by Speedrun)
  bool isCountDown = false;
  int countdownInitial = 0;
  int countdownRemaining = 0;
  bool get isCountdownExpired => isCountDown && countdownRemaining <= 0;
  bool get isPaused => streamSubscription?.isPaused ?? false;

  void init() {
    secondsElapsed = storageService.get(StorageKey.secondsElapsed) ?? 0;
  }

  void configureCountdown(int totalSeconds) {
    isCountDown = true;
    countdownInitial = totalSeconds;
    countdownRemaining = totalSeconds;
    secondsElapsed = 0;
    notifyListeners();
  }

  void disableCountdown() {
    isCountDown = false;
    countdownInitial = 0;
    countdownRemaining = 0;
    notifyListeners();
  }

  void start() {
    if (streamSubscription case var sub? when sub.isPaused) {
      sub.resume();
    } else {
      streamSubscription = timeStream.listen((_) {
        if (isCountDown) {
          if (countdownRemaining > 0) {
            countdownRemaining--;
          }
        } else {
          secondsElapsed++;
        }
        notifyListeners();
        if (!isCountDown) {
          storageService.set(StorageKey.secondsElapsed, secondsElapsed);
        }
      });
    }
  }

  void stop() {
    if (streamSubscription case var sub? when !sub.isPaused) {
      sub.pause();
      secondsElapsed = 0;
      isCountDown = false;
      countdownInitial = 0;
      countdownRemaining = 0;
      notifyListeners();
      storageService.set(StorageKey.secondsElapsed, secondsElapsed);
    }
  }

  void cancel() {
    if (streamSubscription case var sub?) {
      sub.cancel();
    }
  }
}
