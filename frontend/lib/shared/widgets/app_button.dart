import 'package:flutter/material.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_sizes.dart';
import 'package:factory_management/core/theme/app_theme.dart';

enum AppButtonVariant { primary, secondary, danger, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool small;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    final (bg, fg, border) = switch (variant) {
      AppButtonVariant.primary => (c.primary, Colors.white, Colors.transparent),
      AppButtonVariant.secondary => (c.surface, c.textPrimary, c.border),
      AppButtonVariant.danger => (c.error, Colors.white, Colors.transparent),
      AppButtonVariant.ghost => (Colors.transparent, c.textSecondary, Colors.transparent),
    };

    final h = small ? 32.0 : AppSizes.buttonHeight;
    final hPad = small ? 10.0 : 16.0;
    final fontSize = small ? AppFonts.sm : AppFonts.base;

    return SizedBox(
      height: h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          side: border == Colors.transparent ? BorderSide.none : BorderSide(color: border),
          padding: EdgeInsets.symmetric(horizontal: hPad),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600, fontFamily: AppFonts.inter),
        ),
        child: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: fg),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: small ? AppSizes.iconSizeSm : AppSizes.iconSize),
                    const SizedBox(width: 6),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}
