// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get signInTagline => 'Inventario inteligente · Control en tiempo real';

  @override
  String get signInWelcome => 'Bienvenido de vuelta';

  @override
  String get signInSubtitle => 'Gestiona tu red de inventario global';

  @override
  String get signInEmailLabel => 'CORREO ELECTRÓNICO';

  @override
  String get signInEmailHint => 'nombre@empresa.com';

  @override
  String get signInPasswordLabel => 'CONTRASEÑA';

  @override
  String get signInSubmit => 'Iniciar sesión';

  @override
  String get signInForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signInFailed => 'Error al iniciar sesión';

  @override
  String get signInInvalidCredentials => 'Correo o contraseña inválidos';
}
