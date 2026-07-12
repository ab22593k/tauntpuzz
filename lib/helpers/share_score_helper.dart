import 'package:leafy/helpers/duration_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper class that handles sharing puzzle score
///
/// e.g. sharing, launching a url, shared text, ...
class ShareScoreHelper {
  /// Url for Twitter intent to launch twitter with tweet content
  static const String twitterIntentUrl = 'https://twitter.com/intent/tweet';

  /// Open a link using the url_launcher package
  ///
  /// Check if link can be opened first
  static Future<void> openLink(String url, {VoidCallback? onError}) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (onError case var cb?) {
      cb();
    }
  }

  /// Get the puzzle solved text based on score
  static String getPuzzleSolvedText(
    int movesCount,
    Duration duration,
    int tilesCount,
  ) {
    return 'I just solved this $tilesCount-Tile Leafy slide puzzle in ${DurationHelper.toFormattedTime(duration)} with $movesCount moves!';
  }

  /// Get the link to Twitter with text and url params filled based on score
  static String getTwitterShareLink(
    int movesCount,
    Duration duration,
    int tilesCount,
  ) {
    final text = getPuzzleSolvedText(movesCount, duration, tilesCount);
    return '$twitterIntentUrl?text=${Uri.encodeQueryComponent(text)}';
  }
}
