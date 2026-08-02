import 'dart:ui';

import 'package:leafz/ui/core/animations/position_tween.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Model that sets values for left, top, right, and bottom
/// of a widget to position it at most times in a [Stack] widget
class Position extends Equatable {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  const Position({this.left, this.top, this.right, this.bottom});

  const Position.zero() : left = 0, top = 0, bottom = 0, right = 0;

  @override
  String toString() =>
      '${top?.toStringAsFixed(2)}, ${right?.toStringAsFixed(2)}, ${bottom?.toStringAsFixed(2)}, ${left?.toStringAsFixed(2)}';

  @override
  List<Object?> get props => [left, top];

  Position copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Position(
      left: left ?? this.left,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
    );
  }

  /// Lerp implementation for providing the ability to create a [Tween] of type [Position]
  ///
  /// See [PositionTween]
  static Position lerp(Position? a, Position? b, double t) {
    if ((a, b) case (var from?, var to?)) {
      return Position(
        left: from.left == null && to.left == null
            ? null
            : lerpDouble((from.left ?? 0), (to.left ?? 0), t),
        right: from.right == null && to.right == null
            ? null
            : lerpDouble((from.right ?? 0), (to.right ?? 0), t),
        top: from.top == null && to.top == null
            ? null
            : lerpDouble((from.top ?? 0), (to.top ?? 0), t),
        bottom: from.bottom == null && to.bottom == null
            ? null
            : lerpDouble((from.bottom ?? 0), (to.bottom ?? 0), t),
      );
    }
    return const Position.zero();
  }
}
