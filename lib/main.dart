import 'package:flutter/material.dart';
import 'package:restock/shared/infrastructure/services/auth_status_notifier.dart';
import './injections.dart' as di;
import 'package:restock/shared/infrastructure/navigation/router.dart';

/// The main function is the entry point of the application. It initializes the dependency injection and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupDependencies();  
  await di.serviceLocator<AuthStatusNotifier>().initialize();
  runApp(const RestockApp());
}

/// The main application widget.
class RestockApp extends StatelessWidget {
  const RestockApp({super.key});

  /// Builds the MaterialApp with the specified title, theme, and router configuration.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Restock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: buildRouter(di.serviceLocator<AuthStatusNotifier>()),
    );
  }
}