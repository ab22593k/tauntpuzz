import 'dart:ui';

import 'package:jigsaw/domain/models/position.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';

void main() {
  group('Position model', () {
    Position targetPosition = const Position(left: 10, top: 10);

    test('Supports value comparison', () {
      check(const Position(left: 10, top: 10)).equals(targetPosition);
      check(
        const Position(left: 10, top: 10, right: null, bottom: null),
      ).equals(targetPosition);

      check(
        const Position(left: 10, top: 200),
      ).not((it) => it.equals(targetPosition));
      check(
        const Position(left: 10, top: null),
      ).not((it) => it.equals(targetPosition));
    });

    group('Position lerp functionality', () {
      Position startPosition = const Position(left: 10, top: 10);
      Position endPosition = const Position(left: 100, top: 100);

      test('Returns zero position if one is null', () {
        check(
          Position.lerp(startPosition, null, 0),
        ).equals(const Position.zero());
      });

      test('Returns same start position if lerp double is 0', () {
        check(
          Position.lerp(startPosition, endPosition, 0),
        ).equals(startPosition);
      });

      test('Returns correct lerpDouble values between two positions', () {
        double t = 0.5;
        double? newLeft = lerpDouble(
          startPosition.left ?? 0,
          endPosition.left ?? 0,
          t,
        );
        double? newTop = lerpDouble(
          startPosition.top ?? 0,
          endPosition.top ?? 0,
          t,
        );
        check(
          Position.lerp(startPosition, endPosition, t),
        ).equals(Position(left: newLeft, top: newTop));
      });

      test('Returns same end position if lerp double is 1', () {
        check(Position.lerp(startPosition, endPosition, 1)).equals(endPosition);
      });

      test(
        'Returns same start position if lerp double is 0 and one position param in null',
        () {
          check(
            Position.lerp(startPosition, const Position(left: 10), 0),
          ).equals(startPosition);
        },
      );

      test('toString prints correctly', () {
        Position position = const Position(left: 10.222, top: 20.666);

        check(position.toString()).equals('20.67, null, null, 10.22');
      });

      test('copyWith updates position', () {
        Position position = const Position(left: 10, top: 20);

        check(position.copyWith().bottom).isNull();
        check(position.copyWith(bottom: 0).bottom).equals(0);
      });
    });
  });
}
