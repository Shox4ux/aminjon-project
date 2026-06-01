import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:factory_management/app/app.dart';
import 'package:factory_management/app/di/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // ignore: avoid_print
    print('FlutterError: ${details.exception}\n${details.stack}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    // ignore: avoid_print
    print('PlatformDispatcher error: $error\n$stack');
    return true;
  };

  setupDependencies();
  runApp(const App());
}
