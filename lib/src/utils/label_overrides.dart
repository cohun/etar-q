
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'Add meg az email címed';

  @override
  String get passwordInputLabel => 'Add meg a jelszavad';

  @override
  String get confirmPasswordInputLabel => 'Add meg mégegyszer a jelszavad';

  @override
  String get deleteAccount => 'Fiók törlése';

  @override
  String get forgotPasswordButtonLabel => 'Elfelejtettem a jelszavamat';

  @override
  String get isNotAValidEmailErrorText => 'Helytelen email cím';

  @override
  String get signInText => 'Bejelentkezés';

  @override
  String get signOutButtonText => 'Kijelentkezés';

  @override
  String get signInActionText => 'Bejelentkezés';

  @override
  String get registerActionText => 'Regisztrálj';

  @override
  String get registerHintText => 'Nincs még fiókod?';

  @override
  String get registerText => 'Regisztráció';

  @override
  String get signInHintText => 'Már van fiókod?';

  @override
  String get forgotPasswordHintText =>
      'Add meg az email címed, ahová kapsz egy linket új jelszó megadáshoz.';

  @override
  String get forgotPasswordViewTitle => 'Elfelejtett jelszó';

  @override
  String get resetPasswordButtonLabel => 'Új jelszó kérés';

  @override
  String get goBackButtonLabel => "Vissza";
}