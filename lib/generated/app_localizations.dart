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
    Locale('fr')
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'tauntpuzz'**
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

AppLocalizations lookupAppLocalizations(Locale locale) =>
    switch (locale.languageCode) {
      'ar' => AppLocalizationsAr(),
      'en' => AppLocalizationsEn(),
      'fr' => AppLocalizationsFr(),
      _ => throw FlutterError(
          'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
          'an issue with the localizations generation tool. Please file an issue '
          'on GitHub with a reproducible sample app and the gen-l10n configuration '
          'that was used.'),
    };
