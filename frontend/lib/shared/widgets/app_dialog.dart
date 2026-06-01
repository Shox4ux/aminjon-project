import 'package:flutter/material.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_sizes.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/l10n/app_localizations.dart';
import 'package:factory_management/shared/widgets/app_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final bool isLoading;
  final double maxWidth;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.onConfirm,
    this.isLoading = false,
    this.maxWidth = AppSizes.dialogMaxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppThemeColors.of(context);
    return Dialog(
      backgroundColor: c.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: TextStyle(fontSize: AppFonts.xl, fontWeight: FontWeight.w700, color: c.textPrimary)),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, size: AppSizes.iconSize, color: c.textSecondary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Divider(height: 20, color: c.border),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: content,
              ),
            ),
            Divider(height: 24, color: c.border),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    label: l10n.actionCancel,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  AppButton(
                    label: confirmLabel,
                    onPressed: onConfirm,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showConfirmDialog(BuildContext context, {String? title, String? message}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogCtx) {
      final l10n = AppLocalizations.of(dialogCtx)!;
      final c = AppThemeColors.of(dialogCtx);
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
        backgroundColor: c.surface,
        title: Text(
          title ?? l10n.confirmDeleteTitle,
          style: TextStyle(fontSize: AppFonts.lg, fontWeight: FontWeight.w700, color: c.textPrimary),
        ),
        content: Text(message ?? l10n.confirmDeleteMessage, style: TextStyle(color: c.textSecondary)),
        actions: [
          AppButton(
            label: l10n.actionCancel,
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(dialogCtx).pop(false),
          ),
          const SizedBox(width: 8),
          AppButton(
            label: l10n.actionDelete,
            variant: AppButtonVariant.danger,
            onPressed: () => Navigator.of(dialogCtx).pop(true),
          ),
        ],
      );
    },
  );
}
