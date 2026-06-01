import 'package:flutter/material.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/theme/app_theme.dart';

class CompactTag extends StatelessWidget {
  final String label;
  final bool muted;

  const CompactTag(this.label, {super.key, this.muted = false});

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: muted ? c.tableHeader : c.chipBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppFonts.xs,
          color: muted ? c.textSecondary : c.chipText,
        ),
      ),
    );
  }
}
