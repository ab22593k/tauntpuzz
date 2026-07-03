import 'package:leafy/domain/models/location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';

void main() {
  Location targetLocation = const Location(x: 2, y: 2);

  group('Location model', () {
    test('Supports value comparison', () {
      check(const Location(x: 2, y: 2)).equals(targetLocation);
      check(const Location(x: 3, y: 2)).not((it) => it.equals(targetLocation));
    });

    test('Check if a location is located left of target location', () {
      check(targetLocation.isLeftOf(const Location(x: 3, y: 2))).isTrue();
      check(targetLocation.isLeftOf(const Location(x: 3, y: 3))).isFalse();
    });

    test('Check if a location is located right of target location', () {
      check(targetLocation.isRightOf(const Location(x: 1, y: 2))).isTrue();
      check(targetLocation.isRightOf(const Location(x: 3, y: 3))).isFalse();
    });

    test('Check if a location is located top of target location', () {
      check(targetLocation.isTopOf(const Location(x: 2, y: 3))).isTrue();
      check(targetLocation.isTopOf(const Location(x: 3, y: 3))).isFalse();
    });

    test('Check if a location is located bottom of target location', () {
      check(targetLocation.isBottomOf(const Location(x: 2, y: 1))).isTrue();
      check(targetLocation.isTopOf(const Location(x: 1, y: 3))).isFalse();
    });

    test('Check if a location is located around target location', () {
      check(
        targetLocation.isLocatedAround(const Location(x: 1, y: 2)),
      ).isTrue();
      check(
        targetLocation.isLocatedAround(const Location(x: 2, y: 2)),
      ).isFalse();
    });

    test('Compare locations - Check if a location before or after another', () {
      check(targetLocation.compareTo(const Location(x: 3, y: 3))).equals(-1);
      check(targetLocation.compareTo(const Location(x: 1, y: 1))).equals(1);
      check(targetLocation.compareTo(const Location(x: 2, y: 2))).equals(0);
    });

    test('Returns correct model from json map', () {
      Map<String, dynamic> locationJson = {'x': 0, 'y': 0};
      Location expectedLocation = const Location(x: 0, y: 0);

      check(Location.fromJson(locationJson)).equals(expectedLocation);
    });

    test('Returns json map from model', () {
      Location location = const Location(x: 0, y: 1);

      check(location.toJson()['x']).equals(0);
      check(location.toJson()['y']).equals(1);
    });

    test('toString prints correctly', () {
      Location location = const Location(x: 2, y: 1);

      check(location.toString()).equals('(1, 2)');
    });
  });
}
