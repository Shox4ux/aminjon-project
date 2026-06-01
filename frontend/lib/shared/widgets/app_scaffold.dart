import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_sizes.dart';
import 'package:factory_management/core/locale/locale_controller.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/l10n/app_localizations.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width < AppSizes.mobileBreakpoint;
    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppThemeColors.of(context).drawerBg,
          foregroundColor: Colors.white,
          title: Text(l10n.appName, style: const TextStyle(fontSize: AppFonts.lg, fontWeight: FontWeight.w700)),
        ),
        drawer: const _AppDrawer(),
        body: child,
      );
    }
    return Scaffold(
      body: Row(
        children: [
          const _AppDrawer(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final location = GoRouterState.of(context).uri.path;
    final c = AppThemeColors.of(context);
    return SizedBox(
      width: AppSizes.drawerWidth,
      child: Drawer(
        elevation: 0,
        backgroundColor: c.drawerBg,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: c.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.factory_outlined, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      l10n.appName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppFonts.md,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppFonts.inter,
                      ),
                    ),
                  ],
                ),
              ),
              _DrawerItem(
                icon: Icons.factory_outlined,
                label: l10n.navFactories,
                path: '/factories',
                isActive: location.startsWith('/factories'),
              ),
              _DrawerItem(
                icon: Icons.inventory_2_outlined,
                label: l10n.navProducts,
                path: '/products',
                isActive: location.startsWith('/products'),
              ),
              _DrawerItem(
                icon: Icons.category_outlined,
                label: l10n.navCategories,
                path: '/categories',
                isActive: location.startsWith('/categories'),
              ),
              const Spacer(),
              // Theme toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: ValueListenableBuilder<ThemeMode>(
                  valueListenable: ThemeController.instance,
                  builder: (_, mode, __) {
                    final isDark = mode == ThemeMode.dark;
                    return Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        onTap: ThemeController.instance.toggle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Icon(
                                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                                size: AppSizes.iconSize,
                                color: c.drawerItem,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                isDark ? l10n.lightMode : l10n.darkMode,
                                style: TextStyle(
                                  color: c.drawerItem,
                                  fontSize: AppFonts.base,
                                  fontFamily: AppFonts.inter,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Language switcher
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: ValueListenableBuilder<Locale>(
                  valueListenable: LocaleController.instance,
                  builder: (_, currentLocale, __) => Row(
                    children: [
                      for (final entry in const [
                        ('EN', 'en'),
                        ('RU', 'ru'),
                        ('UZ', 'uz'),
                      ])
                        _LangButton(
                          label: entry.$1,
                          localeCode: entry.$2,
                          isActive: currentLocale.languageCode == entry.$2,
                          drawerColors: c,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final String label;
  final String localeCode;
  final bool isActive;
  final AppThemeColors drawerColors;

  const _LangButton({
    required this.label,
    required this.localeCode,
    required this.isActive,
    required this.drawerColors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => LocaleController.instance.setLocale(Locale(localeCode)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isActive ? drawerColors.primary.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isActive ? drawerColors.primary : drawerColors.drawerItem.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? drawerColors.primary : drawerColors.drawerItem,
              fontSize: AppFonts.xs,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              fontFamily: AppFonts.inter,
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String path;
  final bool isActive;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          onTap: () {
            context.replace(path);
            if (Scaffold.of(context).isDrawerOpen) {
              Navigator.of(context).pop();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? c.drawerItemActiveBg : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: AppSizes.iconSize,
                  color: isActive ? c.drawerItemActive : c.drawerItem,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? c.drawerItemActive : c.drawerItem,
                    fontSize: AppFonts.base,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: AppFonts.inter,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
