import 'package:leafy/domain/models/location.dart';
import 'package:leafy/domain/models/tile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';

void main() {
  Tile tile = const Tile(
    value: 2,
    currentLocation: Location(x: 1, y: 3),
    correctLocation: Location(x: 2, y: 1),
  );

  group('Tile Model', () {
    test('Checks if tile is at correct location', () {
      Tile correctLocationTile = const Tile(
        value: 2,
        correctLocation: Location(x: 2, y: 1),
        currentLocation: Location(x: 2, y: 1),
      );

      Tile incorrectLocationTile = const Tile(
        value: 1,
        correctLocation: Location(x: 1, y: 1),
        currentLocation: Location(x: 2, y: 1),
      );

      check(correctLocationTile.isAtCorrectLocation).isTrue();
      check(incorrectLocationTile.isAtCorrectLocation).isFalse();
    });

    test('Returns correct model from json map', () {
      Map<String, dynamic> tileJson = {
        'value': 1,
        'tileIsWhiteSpace': false,
        'currentLocation': {'x': 1, 'y': 1},
        'correctLocation': {'x': 1, 'y': 1},
      };

      Tile expectedTile = const Tile(
        value: 1,
        currentLocation: Location(x: 1, y: 1),
        correctLocation: Location(x: 1, y: 1),
      );

      check(Tile.fromJson(tileJson)).equals(expectedTile);
    });

    test('Returns json map from model', () {
      Tile tile = const Tile(
        value: 1,
        currentLocation: Location(x: 1, y: 1),
        correctLocation: Location(x: 1, y: 1),
      );

      final json = tile.toJson();
      check(json['value']).equals(1);
      check(json['tileIsWhiteSpace']).equals(false);
      check((json['currentLocation'] as Map)['x']).equals(1);
      check((json['currentLocation'] as Map)['y']).equals(1);
      check((json['correctLocation'] as Map)['x']).equals(1);
      check((json['correctLocation'] as Map)['y']).equals(1);
    });

    test('toString prints correctly', () {
      check(tile.toString()).equals(
        'Tile(value: 2, correctLocation: (1, 2), currentLocation: (3, 1))',
      );
    });

    test('copyWith updates tile', () {
      check(tile.copyWith().currentLocation).equals(const Location(x: 1, y: 3));
      check(
        tile
            .copyWith(currentLocation: const Location(x: 2, y: 1))
            .currentLocation,
      ).equals(const Location(x: 2, y: 1));
    });
  });
}
