import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Leafy'**
  String get appTitle;

  /// The application subtitle
  ///
  /// In en, this message translates to:
  /// **'Slide Puzzle'**
  String get appSubtitle;

  /// Language picker section title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language picker section description
  ///
  /// In en, this message translates to:
  /// **'Switch app language'**
  String get switchLanguage;

  /// Puzzle size settings section title
  ///
  /// In en, this message translates to:
  /// **'Puzzle Size'**
  String get puzzleSize;

  /// Puzzle size settings section description
  ///
  /// In en, this message translates to:
  /// **'Choose your grid'**
  String get chooseGrid;

  /// Warning label when changing puzzle size
  ///
  /// In en, this message translates to:
  /// **'Resets progress'**
  String get resetsProgress;

  /// Latest scores section title
  ///
  /// In en, this message translates to:
  /// **'Latest Scores'**
  String get latestScores;

  /// Empty state message when no scores exist
  ///
  /// In en, this message translates to:
  /// **'Solve your first puzzle!'**
  String get solveFirstPuzzle;

  /// Empty state subtitle when no scores exist
  ///
  /// In en, this message translates to:
  /// **'Scores will appear here'**
  String get scoresWillAppear;

  /// Reset puzzle button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Reset confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset your puzzle?'**
  String get resetConfirm;

  /// Share score button label
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Footer text before 'Flutter'
  ///
  /// In en, this message translates to:
  /// **'Built with '**
  String get builtWith;

  /// Version label prefix
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// 404 page not found title
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// 404 page not found message
  ///
  /// In en, this message translates to:
  /// **'The page you\'re looking for doesn\'t exist.'**
  String get pageNotFoundMessage;

  /// Dark mode toggle section title
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Theme toggle section description
  ///
  /// In en, this message translates to:
  /// **'Choose your theme'**
  String get toggleDarkMode;

  /// Light theme option label
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// System theme option label
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// Dark theme option label
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// Game mode section title
  ///
  /// In en, this message translates to:
  /// **'Game Mode'**
  String get gameMode;

  /// Game mode section description
  ///
  /// In en, this message translates to:
  /// **'Select a challenge variant'**
  String get chooseMode;

  /// Stat label for elapsed time
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Stat label for move count
  ///
  /// In en, this message translates to:
  /// **'Moves'**
  String get moves;

  /// Stat label for correct tile count
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// Puzzle solved dialog title
  ///
  /// In en, this message translates to:
  /// **'Congrats! You did it!'**
  String get congratsTitle;

  /// Puzzle solved dialog subtitle
  ///
  /// In en, this message translates to:
  /// **'You solved the puzzle! Share your score to challenge your friends'**
  String get congratsSubtitle;

  /// Restart puzzle button label
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// Alert dialog confirm button
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Alert dialog cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Drawer menu button tooltip
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Stats pane section title
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// Marathon mode range selector label
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get range;

  /// Marathon mode start size label
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// Marathon mode end size label
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// Classic game mode name
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get gameModeClassic;

  /// Speedrun game mode name
  ///
  /// In en, this message translates to:
  /// **'Speedrun'**
  String get gameModeSpeedrun;

  /// Blind game mode name
  ///
  /// In en, this message translates to:
  /// **'Blind'**
  String get gameModeBlind;

  /// Marathon game mode name
  ///
  /// In en, this message translates to:
  /// **'Marathon'**
  String get gameModeMarathon;

  /// Classic game mode description
  ///
  /// In en, this message translates to:
  /// **'Solve at your own pace'**
  String get gameModeClassicDesc;

  /// Speedrun game mode description
  ///
  /// In en, this message translates to:
  /// **'Beat the countdown'**
  String get gameModeSpeedrunDesc;

  /// Blind game mode description
  ///
  /// In en, this message translates to:
  /// **'Tiles hide — tap to peek'**
  String get gameModeBlindDesc;

  /// Marathon game mode description
  ///
  /// In en, this message translates to:
  /// **'Chain-solve across sizes'**
  String get gameModeMarathonDesc;

  /// Moves count display in score dialog
  ///
  /// In en, this message translates to:
  /// **'{count} Moves'**
  String movesCountLabel(Object count);

  /// Encouragement phrase when puzzle starts
  ///
  /// In en, this message translates to:
  /// **'Good luck!'**
  String get phraseGoodLuck;

  /// Encouragement phrase when puzzle starts
  ///
  /// In en, this message translates to:
  /// **'You can do it!'**
  String get phraseYouCanDoIt;

  /// Encouragement phrase when puzzle starts
  ///
  /// In en, this message translates to:
  /// **'I believe in you!'**
  String get phraseIBelieveInYou;

  /// Encouragement phrase when doing well
  ///
  /// In en, this message translates to:
  /// **'Keep going!'**
  String get phraseKeepGoing;

  /// Encouragement phrase when doing well
  ///
  /// In en, this message translates to:
  /// **'You\'\'re doing great!'**
  String get phraseYoureDoingGreat;

  /// Encouragement phrase when doing well
  ///
  /// In en, this message translates to:
  /// **'Not much left!'**
  String get phraseNotMuchLeft;

  /// Celebration phrase when puzzle solved
  ///
  /// In en, this message translates to:
  /// **'You Are AMAZING!'**
  String get phraseYouAreAmazing;

  /// Celebration phrase when puzzle solved
  ///
  /// In en, this message translates to:
  /// **'You Are AWESOME!'**
  String get phraseYouAreAwesome;

  /// Celebration phrase when puzzle solved
  ///
  /// In en, this message translates to:
  /// **'Wow! You Did It!'**
  String get phraseWowYouDidIt;

  /// Playful phrase when hard puzzle selected
  ///
  /// In en, this message translates to:
  /// **'You sure you can handle all of that?!'**
  String get phraseSureYouCanHandle;

  /// Playful phrase when hard puzzle selected
  ///
  /// In en, this message translates to:
  /// **'WOW! That\'\'s not easy!'**
  String get phraseWOWThatsNotEasy;

  /// Playful phrase when hard puzzle selected
  ///
  /// In en, this message translates to:
  /// **'Easy is boring'**
  String get phraseEasyIsBoring;

  /// Encouragement phrase when puzzle takes long
  ///
  /// In en, this message translates to:
  /// **'This is taking too long!'**
  String get phraseThisIsTakingTooLong;

  /// Encouragement phrase when puzzle takes long
  ///
  /// In en, this message translates to:
  /// **'Don\'\'t lose hope'**
  String get phraseDontLoseHope;

  /// Encouragement phrase when puzzle takes long
  ///
  /// In en, this message translates to:
  /// **'Better late than never'**
  String get phraseBetterLateThanNever;

  /// Dash mascot introduction
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'\'m Dash'**
  String get dashIntro;

  /// Dash describes what he represents
  ///
  /// In en, this message translates to:
  /// **'The mascot for Flutter & Dart'**
  String get dashMascotOf;

  /// Dash mentions the app is built with Flutter/Dart
  ///
  /// In en, this message translates to:
  /// **'Which is what this app is built with!'**
  String get dashBuiltWith;

  /// Dash explains his role
  ///
  /// In en, this message translates to:
  /// **'And I\'\'m an astronaut here'**
  String get dashAstronaut;

  /// Dash suggests his nickname
  ///
  /// In en, this message translates to:
  /// **'So you can call me Leafy'**
  String get dashCallMeLeafy;

  /// Dash annoyed by repeated taps
  ///
  /// In en, this message translates to:
  /// **'You can stop poking me now'**
  String get dashStopPoking;

  /// Dash suggests playing instead of tapping
  ///
  /// In en, this message translates to:
  /// **'Why don\'\'t you play with the puzzle instead???'**
  String get dashPlayInstead;

  /// Dash getting annoyed
  ///
  /// In en, this message translates to:
  /// **'You\'\'re starting to annoy me!'**
  String get dashAnnoying;

  /// Dash gives up being annoyed
  ///
  /// In en, this message translates to:
  /// **'Argh! Never mind!'**
  String get dashNeverMind;

  /// Dash resigned to continued tapping
  ///
  /// In en, this message translates to:
  /// **'You\'\'ll probably keep doing this'**
  String get dashKeepDoingThis;

  /// Dash threatens to reset his dialogue
  ///
  /// In en, this message translates to:
  /// **'I can start over you know!!'**
  String get dashStartOver;

  /// Dash admits he didn't reset
  ///
  /// In en, this message translates to:
  /// **'Nah I didn\'\'t start over'**
  String get dashNahDidntStartOver;

  /// Dash will reset now
  ///
  /// In en, this message translates to:
  /// **'Now I will...'**
  String get dashNowIWill;

  /// Dash still hasn't reset
  ///
  /// In en, this message translates to:
  /// **'Still didn\'\'t'**
  String get dashStillDidnt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
