import 'package:jigsaw/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension LocalizationsExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
