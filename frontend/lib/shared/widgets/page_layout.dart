import 'dart:math';
import 'package:flutter/material.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_sizes.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/l10n/app_localizations.dart';
import 'package:factory_management/shared/widgets/app_button.dart';

class PageLayout extends StatelessWidget {
  final String title;
  final String addLabel;
  final VoidCallback onAdd;
  final List<Widget> filterWidgets;
  final Widget table;

  const PageLayout({
    super.key,
    required this.title,
    required this.addLabel,
    required this.onAdd,
    required this.filterWidgets,
    required this.table,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    return Container(
      color: c.scaffoldBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: c.surface,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Text(title, style: TextStyle(fontSize: AppFonts.heading, fontWeight: FontWeight.w700, color: c.textPrimary)),
                const Spacer(),
                AppButton(label: addLabel, icon: Icons.add, onPressed: onAdd),
              ],
            ),
          ),
          Divider(height: 1, color: c.border),
          Container(
            color: c.surface,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: filterWidgets,
            ),
          ),
          Divider(height: 1, color: c.border),
          Expanded(child: table),
        ],
      ),
    );
  }
}

class FilterField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final IconData icon;

  const FilterField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.icon = Icons.search,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    return SizedBox(
      width: 220,
      height: 38,
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(fontSize: AppFonts.base, color: c.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: c.textHint, fontSize: AppFonts.base),
          prefixIcon: Icon(icon, size: AppSizes.iconSizeSm, color: c.textHint),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          filled: true,
          fillColor: c.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            borderSide: BorderSide(color: c.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            borderSide: BorderSide(color: c.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            borderSide: BorderSide(color: c.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class FilterDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T?>> items;
  final ValueChanged<T?> onChanged;
  final IconData icon;

  const FilterDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.icon = Icons.filter_list,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    return SizedBox(
      width: 220,
      height: 38,
      child: DropdownButtonHideUnderline(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: c.background,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(
              color: value != null ? c.primary : c.border,
              width: value != null ? 1.5 : 1,
            ),
          ),
          child: DropdownButton<T?>(
            value: value,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, size: AppSizes.iconSizeSm, color: c.textHint),
            hint: Row(
              children: [
                Icon(icon, size: AppSizes.iconSizeSm, color: c.textHint),
                const SizedBox(width: 6),
                Text(hint, style: TextStyle(color: c.textHint, fontSize: AppFonts.base)),
              ],
            ),
            selectedItemBuilder: (context) => items.map((item) {
              if (item.value == null) {
                return Row(children: [
                  Icon(icon, size: AppSizes.iconSizeSm, color: c.textHint),
                  const SizedBox(width: 6),
                  Text(hint, style: TextStyle(color: c.textHint, fontSize: AppFonts.base)),
                ]);
              }
              return Align(alignment: Alignment.centerLeft, child: item.child);
            }).toList(),
            items: items,
            onChanged: onChanged,
            style: TextStyle(fontSize: AppFonts.base, color: c.textPrimary),
            dropdownColor: c.surface,
          ),
        ),
      ),
    );
  }
}

class AppTableWrapper extends StatelessWidget {
  final List<String> columns;
  final List<DataRow> rows;
  final bool isLoading;
  final String? error;

  const AppTableWrapper({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppThemeColors.of(context);
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: c.primary));
    }
    if (error != null) {
      final isNetworkError = error == 'Unable to reach server';
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isNetworkError ? Icons.cloud_off_outlined : Icons.error_outline,
              size: 48,
              color: isNetworkError ? c.textHint : c.error,
            ),
            const SizedBox(height: 12),
            Text(
              isNetworkError ? l10n.unableToReachServer : error!,
              style: TextStyle(color: c.textPrimary, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            if (isNetworkError) ...[
              const SizedBox(height: 4),
              Text(l10n.checkBackendRunning, style: TextStyle(color: c.textSecondary, fontSize: 13)),
            ],
          ],
        ),
      );
    }
    if (rows.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: c.textHint),
            const SizedBox(height: 12),
            Text(l10n.noData, style: TextStyle(color: c.textSecondary, fontSize: AppFonts.base)),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = max(AppSizes.tableMinWidth, constraints.maxWidth - 2 * AppSizes.base);
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.base),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              side: BorderSide(color: c.border),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: tableWidth),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(c.tableHeader),
                  headingRowHeight: AppSizes.tableHeaderHeight,
                  dataRowMinHeight: AppSizes.tableRowHeight,
                  dataRowMaxHeight: AppSizes.tableRowHeight + 16,
                  dividerThickness: 1,
                  columnSpacing: 20,
                  horizontalMargin: 20,
                  columns: columns
                      .map((col) => DataColumn(
                            label: Text(col,
                                style: TextStyle(
                                    fontSize: AppFonts.sm,
                                    fontWeight: FontWeight.w600,
                                    color: c.textSecondary)),
                          ))
                      .toList(),
                  rows: rows,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget actionCell(BuildContext context, {required VoidCallback onEdit, required VoidCallback onDelete}) {
  final l10n = AppLocalizations.of(context)!;
  final c = AppThemeColors.of(context);
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.edit_outlined, size: AppSizes.iconSize),
        color: c.primary,
        tooltip: l10n.actionEdit,
        onPressed: onEdit,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
      const SizedBox(width: 8),
      IconButton(
        icon: const Icon(Icons.delete_outline, size: AppSizes.iconSize),
        color: c.error,
        tooltip: l10n.actionDelete,
        onPressed: onDelete,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    ],
  );
}
