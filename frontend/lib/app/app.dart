import 'package:flutter/material.dart';
import 'package:factory_management/app/router/app_router.dart';
import 'package:factory_management/core/locale/locale_controller.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleController.instance,
      builder: (_, locale, __) => ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeController.instance,
        builder: (_, mode, __) => MaterialApp.router(
          title: 'Factory Management',
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          themeMode: mode,
          theme: lightTheme,
          darkTheme: darkTheme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
