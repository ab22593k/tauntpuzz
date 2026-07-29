import 'package:leafz/domain/models/game_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';

void main() {
  group('GameMode', () {
    test('has exactly 4 variants', () {
      check(GameMode.values).length.equals(4);
    });

    test('values.byName round-trips all variants', () {
      for (final mode in GameMode.values) {
        check(GameMode.values.byName(mode.name)).equals(mode);
      }
    });
  });
}
