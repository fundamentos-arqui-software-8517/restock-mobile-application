import 'package:flutter/material.dart';
import './injections.dart' as di;
import 'package:restock/shared/infrastructure/navigation/router.dart';

/// The main function is the entry point of the application. It initializes the dependency injection and runs the app.
Future<void> main() async {
  await di.setupDependencies();
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Builds the MaterialApp with the specified title, theme, and router configuration.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Restock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}