import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nirmitee/config_main.dart';
import 'package:nirmitee/presentation/routes/routes.dart';

void main() {
  configMain();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: kDebugMode,
      routerConfig: RouteGenerator.router,
    );
  }
}
