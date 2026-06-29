// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get signInTagline => 'Smart inventory · Real-time control';

  @override
  String get signInWelcome => 'Welcome back';

  @override
  String get signInSubtitle => 'Manage your global inventory network';

  @override
  String get signInEmailLabel => 'EMAIL ADDRESS';

  @override
  String get signInEmailHint => 'name@company.com';

  @override
  String get signInPasswordLabel => 'PASSWORD';

  @override
  String get signInSubmit => 'Login';

  @override
  String get signInForgotPassword => 'Forgot your password?';

  @override
  String get signInFailed => 'Sign in failed';

  @override
  String get signInInvalidCredentials => 'Invalid email or password';
}
