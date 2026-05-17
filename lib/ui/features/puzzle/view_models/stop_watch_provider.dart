import 'dart:async';

import 'package:tauntpuzz/data/services/storage_service.dart';
import 'package:flutter/cupertino.dart';

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
    if (streamSubscription != null && streamSubscription!.isPaused) {
      streamSubscription!.resume();
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
    if (streamSubscription != null && !streamSubscription!.isPaused) {
      streamSubscription!.pause();
      secondsElapsed = 0;
      isCountDown = false;
      countdownInitial = 0;
      countdownRemaining = 0;
      notifyListeners();
      storageService.set(StorageKey.secondsElapsed, secondsElapsed);
    }
  }

  void cancel() {
    if (streamSubscription != null) {
      streamSubscription!.cancel();
    }
  }
}
