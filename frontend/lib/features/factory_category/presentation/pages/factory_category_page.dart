import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/app/di/injection.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/core/utils/app_toast.dart';
import 'package:factory_management/features/factory_category/domain/entities/category_entity.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_bloc.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_event.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_state.dart';
import 'package:factory_management/l10n/app_localizations.dart';
import 'package:factory_management/shared/widgets/app_dialog.dart';
import 'package:factory_management/shared/widgets/app_text_field.dart';
import 'package:factory_management/shared/widgets/page_layout.dart';
import 'package:factory_management/core/utils/form_draft.dart';

class FactoryCategoryPage extends StatelessWidget {
  const FactoryCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryBloc>()..add(const LoadCategories()),
      child: const _CategoryPageContent(),
    );
  }
}

class _CategoryPageContent extends StatefulWidget {
  const _CategoryPageContent();

  @override
  State<_CategoryPageContent> createState() => _CategoryPageContentState();
}

class _CategoryPageContentState extends State<_CategoryPageContent> {
  String _filter = '';

  void _showForm({CategoryEntity? category}) {
    final l10n = AppLocalizations.of(context)!;
    final draftText = category == null ? (FormDraft.load('draft_category_create')?['name'] ?? '') : category.categoryName;
    final ctrl = TextEditingController(text: draftText);
    final formKey = GlobalKey<FormState>();
    if (category == null) ctrl.addListener(() => FormDraft.save('draft_category_create', {'name': ctrl.text}));
    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: category == null ? l10n.addCategory : l10n.editCategory,
        confirmLabel: category == null ? l10n.actionCreate : l10n.actionUpdate,
        onConfirm: () {
          if (!formKey.currentState!.validate()) return;
          final data = {'category_name': ctrl.text.trim()};
          if (category == null) {
            FormDraft.clear('draft_category_create');
            context.read<CategoryBloc>().add(CreateCategory(data));
          } else {
            context.read<CategoryBloc>().add(UpdateCategory(category.id, data));
          }
          Navigator.of(ctx).pop();
        },
        content: Form(
          key: formKey,
          child: AppTextField(
            label: l10n.fieldCategoryName,
            controller: ctrl,
            validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(CategoryEntity category) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.deleteCategoryTitle,
      message: l10n.deleteCategoryMessage(category.categoryName),
    );
    if (confirmed == true && mounted) {
      context.read<CategoryBloc>().add(DeleteCategory(category.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoryActionSuccess) {
          AppToast.success(context, state.message);
        } else if (state is CategoryError) {
          AppToast.error(context, state.message);
        }
      },
      child: PageLayout(
        title: l10n.navCategories,
        addLabel: l10n.addCategory,
        onAdd: () => _showForm(),
        filterWidgets: [
          FilterField(
            hint: l10n.searchByName,
            onChanged: (v) => setState(() => _filter = v.toLowerCase()),
          ),
        ],
        table: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            final all = state is CategoryLoaded
                ? state.categories
                : (state is CategoryActionSuccess ? state.categories : <CategoryEntity>[]);
            final filtered = _filter.isEmpty
                ? all
                : all.where((c) => c.categoryName.toLowerCase().contains(_filter)).toList();
            return AppTableWrapper(
              columns: [l10n.colId, l10n.fieldCategoryName, l10n.colActions],
              isLoading: state is CategoryLoading,
              error: state is CategoryError ? state.message : null,
              rows: filtered
                  .map((c) => DataRow(cells: [
                        DataCell(Text('${c.id}',
                            style: TextStyle(fontSize: AppFonts.sm, color: AppThemeColors.of(context).textSecondary))),
                        DataCell(Text(c.categoryName, style: const TextStyle(fontWeight: FontWeight.w600))),
                        DataCell(actionCell(context,
                            onEdit: () => _showForm(category: c),
                            onDelete: () => _confirmDelete(c))),
                      ]))
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
