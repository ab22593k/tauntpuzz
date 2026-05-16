// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'tauntpuzz';

  @override
  String get appSubtitle => 'Puzzle Glissant';

  @override
  String get language => 'Langue';

  @override
  String get switchLanguage => 'Changer la langue';

  @override
  String get puzzleSize => 'Taille du Puzzle';

  @override
  String get chooseGrid => 'Choisissez votre grille';

  @override
  String get resetsProgress => 'Réinitialise la progression';

  @override
  String get latestScores => 'Meilleurs Scores';

  @override
  String get solveFirstPuzzle => 'Résolvez votre premier puzzle !';

  @override
  String get scoresWillAppear => 'Les scores apparaîtront ici';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get resetConfirm =>
      'Êtes-vous sûr de vouloir réinitialiser le puzzle ?';

  @override
  String get share => 'Partager';

  @override
  String get builtWith => 'Construit avec ';

  @override
  String get version => 'Version';

  @override
  String get pageNotFound => 'Page introuvable';

  @override
  String get pageNotFoundMessage => 'La page que vous cherchez n\'existe pas.';
}
