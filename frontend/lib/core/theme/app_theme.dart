import 'package:flutter/material.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_sizes.dart';

// ─── Color tokens ────────────────────────────────────────────────────────────

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.primary,
    required this.primaryLight,
    required this.surface,
    required this.background,
    required this.scaffoldBg,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.border,
    required this.divider,
    required this.success,
    required this.successLight,
    required this.error,
    required this.errorLight,
    required this.tableHeader,
    required this.chipBg,
    required this.chipText,
    required this.drawerBg,
    required this.drawerItem,
    required this.drawerItemActive,
    required this.drawerItemActiveBg,
  });

  final Color primary;
  final Color primaryLight;
  final Color surface;
  final Color background;
  final Color scaffoldBg;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color border;
  final Color divider;
  final Color success;
  final Color successLight;
  final Color error;
  final Color errorLight;
  final Color tableHeader;
  final Color chipBg;
  final Color chipText;
  final Color drawerBg;
  final Color drawerItem;
  final Color drawerItemActive;
  final Color drawerItemActiveBg;

  static AppThemeColors of(BuildContext context) =>
      Theme.of(context).extension<AppThemeColors>()!;

  static const light = AppThemeColors(
    primary: Color(0xFF2563EB),
    primaryLight: Color(0xFFEFF6FF),
    surface: Color(0xFFFFFFFF),
    background: Color(0xFFF8FAFC),
    scaffoldBg: Color(0xFFF1F5F9),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    textHint: Color(0xFF94A3B8),
    border: Color(0xFFE2E8F0),
    divider: Color(0xFFF1F5F9),
    success: Color(0xFF16A34A),
    successLight: Color(0xFFF0FDF4),
    error: Color(0xFFDC2626),
    errorLight: Color(0xFFFEF2F2),
    tableHeader: Color(0xFFF8FAFC),
    chipBg: Color(0xFFEFF6FF),
    chipText: Color(0xFF2563EB),
    drawerBg: Color(0xFF0F172A),
    drawerItem: Color(0xFF94A3B8),
    drawerItemActive: Color(0xFFFFFFFF),
    drawerItemActiveBg: Color(0xFF1E3A5F),
  );

  static const dark = AppThemeColors(
    primary: Color(0xFF3B82F6),
    primaryLight: Color(0xFF1E3A5F),
    surface: Color(0xFF1E2130),
    background: Color(0xFF252837),
    scaffoldBg: Color(0xFF161822),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textHint: Color(0xFF475569),
    border: Color(0xFF2D3148),
    divider: Color(0xFF1E2130),
    success: Color(0xFF22C55E),
    successLight: Color(0xFF14231C),
    error: Color(0xFFF87171),
    errorLight: Color(0xFF2D1515),
    tableHeader: Color(0xFF1A1D2E),
    chipBg: Color(0xFF1E3A5F),
    chipText: Color(0xFF60A5FA),
    drawerBg: Color(0xFF0A0D1A),
    drawerItem: Color(0xFF64748B),
    drawerItemActive: Color(0xFFFFFFFF),
    drawerItemActiveBg: Color(0xFF1E3A5F),
  );

  @override
  AppThemeColors copyWith({
    Color? primary,
    Color? primaryLight,
    Color? surface,
    Color? background,
    Color? scaffoldBg,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? border,
    Color? divider,
    Color? success,
    Color? successLight,
    Color? error,
    Color? errorLight,
    Color? tableHeader,
    Color? chipBg,
    Color? chipText,
    Color? drawerBg,
    Color? drawerItem,
    Color? drawerItemActive,
    Color? drawerItemActiveBg,
  }) =>
      AppThemeColors(
        primary: primary ?? this.primary,
        primaryLight: primaryLight ?? this.primaryLight,
        surface: surface ?? this.surface,
        background: background ?? this.background,
        scaffoldBg: scaffoldBg ?? this.scaffoldBg,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textHint: textHint ?? this.textHint,
        border: border ?? this.border,
        divider: divider ?? this.divider,
        success: success ?? this.success,
        successLight: successLight ?? this.successLight,
        error: error ?? this.error,
        errorLight: errorLight ?? this.errorLight,
        tableHeader: tableHeader ?? this.tableHeader,
        chipBg: chipBg ?? this.chipBg,
        chipText: chipText ?? this.chipText,
        drawerBg: drawerBg ?? this.drawerBg,
        drawerItem: drawerItem ?? this.drawerItem,
        drawerItemActive: drawerItemActive ?? this.drawerItemActive,
        drawerItemActiveBg: drawerItemActiveBg ?? this.drawerItemActiveBg,
      );

  @override
  AppThemeColors lerp(AppThemeColors? other, double t) {
    if (other == null) return this;
    return AppThemeColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      background: Color.lerp(background, other.background, t)!,
      scaffoldBg: Color.lerp(scaffoldBg, other.scaffoldBg, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      tableHeader: Color.lerp(tableHeader, other.tableHeader, t)!,
      chipBg: Color.lerp(chipBg, other.chipBg, t)!,
      chipText: Color.lerp(chipText, other.chipText, t)!,
      drawerBg: Color.lerp(drawerBg, other.drawerBg, t)!,
      drawerItem: Color.lerp(drawerItem, other.drawerItem, t)!,
      drawerItemActive:
          Color.lerp(drawerItemActive, other.drawerItemActive, t)!,
      drawerItemActiveBg:
          Color.lerp(drawerItemActiveBg, other.drawerItemActiveBg, t)!,
    );
  }
}

// ─── Theme controller ─────────────────────────────────────────────────────────

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController._() : super(ThemeMode.light);
  static final instance = ThemeController._();

  bool get isDark => value == ThemeMode.dark;
  void toggle() => value = isDark ? ThemeMode.light : ThemeMode.dark;
}

// ─── ThemeData builders ───────────────────────────────────────────────────────

ThemeData _base(AppThemeColors c, Brightness brightness) => ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppFonts.inter,
      extensions: [c],
      colorScheme: ColorScheme.fromSeed(
        seedColor: c.primary,
        brightness: brightness,
        surface: c.surface,
      ),
      scaffoldBackgroundColor: c.scaffoldBg,
      cardTheme: CardThemeData(
        elevation: 0,
        color: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: c.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: c.primary, width: 1.5),
        ),
        hintStyle: TextStyle(color: c.textHint, fontSize: AppFonts.base),
        labelStyle: TextStyle(color: c.textSecondary, fontSize: AppFonts.base),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          textStyle: const TextStyle(
              fontSize: AppFonts.base,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.inter),
        ),
      ),
      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 0),
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: AppFonts.base, color: c.textPrimary),
        bodyMedium: TextStyle(fontSize: AppFonts.sm, color: c.textSecondary),
        titleMedium: TextStyle(
            fontSize: AppFonts.lg,
            fontWeight: FontWeight.w600,
            color: c.textPrimary),
        titleLarge: TextStyle(
            fontSize: AppFonts.xl,
            fontWeight: FontWeight.w700,
            color: c.textPrimary),
        labelLarge: TextStyle(
            fontSize: AppFonts.base,
            fontWeight: FontWeight.w600,
            color: c.textPrimary),
      ),
      dialogTheme: DialogThemeData(backgroundColor: c.surface),
      popupMenuTheme: PopupMenuThemeData(color: c.surface),
    );

final lightTheme = _base(AppThemeColors.light, Brightness.light);
final darkTheme = _base(AppThemeColors.dark, Brightness.dark);
