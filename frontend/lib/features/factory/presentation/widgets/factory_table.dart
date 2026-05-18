// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/l10n/app_localizations.dart';
import 'package:factory_management/shared/widgets/page_layout.dart';

class FactoryTable extends StatelessWidget {
  final List<FactoryEntity> factories;
  final bool isLoading;
  final String? error;
  final void Function(FactoryEntity) onEdit;
  final void Function(FactoryEntity) onDelete;

  const FactoryTable({
    super.key,
    required this.factories,
    required this.onEdit,
    required this.onDelete,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppThemeColors.of(context);
    return AppTableWrapper(
      columns: [
        l10n.colId,
        l10n.colName,
        l10n.colCategory,
        l10n.colPhone,
        l10n.colWechat,
        l10n.colAddress,
        l10n.colProducts,
        l10n.colActions,
      ],
      isLoading: isLoading,
      error: error,
      rows: factories
          .map((f) => DataRow(cells: [
                DataCell(Text('${f.id}',
                    style: TextStyle(
                        fontSize: AppFonts.sm, color: c.textSecondary))),
                DataCell(_CopyableCell(f.name,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
                DataCell(Text(f.factoryCategory?.categoryName ?? '—',
                    style: const TextStyle(fontSize: AppFonts.base))),
                DataCell(_CopyableCell(f.phone,
                    style: TextStyle(
                        fontSize: AppFonts.sm, color: c.textSecondary))),
                DataCell(_CopyableCell(f.wechatId,
                    style: TextStyle(
                        fontSize: AppFonts.sm, color: c.textSecondary))),
                DataCell(_CopyableCell(f.address,
                    style: TextStyle(
                        fontSize: AppFonts.sm, color: c.textSecondary))),
                DataCell(
                  Wrap(
                    spacing: 4,
                    children: f.products
                        .take(3)
                        .map((p) => Chip(
                              label: Text(p.name,
                                  style: TextStyle(
                                      fontSize: AppFonts.xs,
                                      color: c.chipText)),
                              backgroundColor: c.chipBg,
                              side: BorderSide.none,
                              padding: EdgeInsets.zero,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList()
                      ..addAll(f.products.length > 3
                          ? [
                              Chip(
                                label: Text('+${f.products.length - 3}',
                                    style: TextStyle(
                                        fontSize: AppFonts.xs,
                                        color: c.textSecondary)),
                                backgroundColor: c.tableHeader,
                                side: BorderSide.none,
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              )
                            ]
                          : []),
                  ),
                ),
                DataCell(actionCell(context,
                    onEdit: () => onEdit(f), onDelete: () => onDelete(f))),
              ]))
          .toList(),
    );
  }
}

class _CopyableCell extends StatelessWidget {
  final String? value;
  final TextStyle? style;

  const _CopyableCell(this.value, {this.style});

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) {
      return Text('—', style: style);
    }
    return Tooltip(
      message: 'Click to copy',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async {
            bool copied = false;
            // execCommand MUST run synchronously before any await,
            // otherwise the browser's user-gesture context is lost.
            try {
              final ta = html.TextAreaElement()
                ..value = value!
                ..setAttribute('readonly', '')
                ..style.position = 'absolute'
                ..style.left = '-9999px';
              html.document.body!.append(ta);
              ta.select();
              copied = html.document.execCommand('copy');
              ta.remove();
            } catch (_) {}
            // Also try the async clipboard API (works on HTTPS).
            if (!copied) {
              try {
                await Clipboard.setData(ClipboardData(text: value!));
                copied = true;
              } catch (_) {}
            }
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(copied ? 'Copied: $value' : 'Copy failed'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  width: 220,
                ),
              );
            }
          },
          child: Text(value!, style: style),
        ),
      ),
    );
  }
}
