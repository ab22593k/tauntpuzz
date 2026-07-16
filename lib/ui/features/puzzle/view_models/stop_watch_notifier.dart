import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class StopWatchState {
  final int secondsElapsed;
  final bool isCountDown;
  final int countdownInitial;
  final int countdownRemaining;
  final bool isPaused;

  const StopWatchState({
    this.secondsElapsed = 0,
    this.isCountDown = false,
    this.countdownInitial = 0,
    this.countdownRemaining = 0,
    this.isPaused = false,
  });

  bool get isCountdownExpired => isCountDown && countdownRemaining <= 0;

  StopWatchState copyWith({
    int? secondsElapsed,
    bool? isCountDown,
    int? countdownInitial,
    int? countdownRemaining,
    bool? isPaused,
  }) {
    return StopWatchState(
      secondsElapsed: secondsElapsed ?? this.secondsElapsed,
      isCountDown: isCountDown ?? this.isCountDown,
      countdownInitial: countdownInitial ?? this.countdownInitial,
      countdownRemaining: countdownRemaining ?? this.countdownRemaining,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}

class StopWatchNotifier extends Notifier<StopWatchState> {
  StreamSubscription<int>? _subscription;

  @override
  StopWatchState build() {
    ref.onDispose(() => _subscription?.cancel());
    return const StopWatchState();
  }

  void init(int persistedSeconds) {
    state = state.copyWith(secondsElapsed: persistedSeconds);
  }

  void configureCountdown(int totalSeconds) {
    state = state.copyWith(
      isCountDown: true,
      countdownInitial: totalSeconds,
      countdownRemaining: totalSeconds,
      secondsElapsed: 0,
    );
  }

  void disableCountdown() {
    state = state.copyWith(
      isCountDown: false,
      countdownInitial: 0,
      countdownRemaining: 0,
    );
  }

  void start() {
    if (_subscription case var sub? when sub.isPaused) {
      sub.resume();
      state = state.copyWith(isPaused: false);
    } else {
      _subscription =
          Stream.periodic(const Duration(seconds: 1), (x) => 1 + x++).listen((
            _,
          ) {
            if (state.isCountDown && state.countdownRemaining > 0) {
              state = state.copyWith(
                countdownRemaining: state.countdownRemaining - 1,
              );
            } else if (!state.isCountDown) {
              state = state.copyWith(secondsElapsed: state.secondsElapsed + 1);
            }
          });
      state = state.copyWith(isPaused: false);
    }
  }

  void stop() {
    if (_subscription case var sub? when !sub.isPaused) {
      sub.pause();
      state = state.copyWith(
        isPaused: true,
        secondsElapsed: 0,
        isCountDown: false,
        countdownInitial: 0,
        countdownRemaining: 0,
      );
    }
  }

  void cancel() {
    _subscription?.cancel();
    _subscription = null;
  }
}

final stopWatchProvider = NotifierProvider<StopWatchNotifier, StopWatchState>(
  StopWatchNotifier.new,
);
