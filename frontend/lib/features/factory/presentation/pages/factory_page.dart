import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/app/di/injection.dart';
import 'package:factory_management/core/utils/app_toast.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_bloc.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_event.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_state.dart';
import 'package:factory_management/features/factory/presentation/widgets/factory_form_dialog.dart';
import 'package:factory_management/features/factory/presentation/widgets/factory_table.dart';
import 'package:factory_management/features/factory_category/domain/entities/category_entity.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_bloc.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_event.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_state.dart';
import 'package:factory_management/l10n/app_localizations.dart';
import 'package:factory_management/shared/widgets/app_dialog.dart';
import 'package:factory_management/shared/widgets/page_layout.dart';

class FactoryPage extends StatelessWidget {
  const FactoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<FactoryBloc>()..add(const LoadFactories())),
        BlocProvider(create: (_) => sl<CategoryBloc>()..add(const LoadCategories())),
      ],
      child: const _FactoryPageContent(),
    );
  }
}

class _FactoryPageContent extends StatefulWidget {
  const _FactoryPageContent();

  @override
  State<_FactoryPageContent> createState() => _FactoryPageContentState();
}

class _FactoryPageContentState extends State<_FactoryPageContent> {
  String _nameFilter = '';
  String _productFilter = '';
  int? _categoryFilter;

  void _reload() {
    context.read<FactoryBloc>().add(LoadFactories(
          name: _nameFilter.isEmpty ? null : _nameFilter,
          productName: _productFilter.isEmpty ? null : _productFilter,
        ));
  }

  void _showAdd() => showDialog(
        context: context,
        builder: (_) => FactoryFormDialog(
          onSubmit: (data) {
            context.read<FactoryBloc>().add(CreateFactory(data));
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      );

  void _showEdit(FactoryEntity factory) => showDialog(
        context: context,
        builder: (_) => FactoryFormDialog(
          factory: factory,
          onSubmit: (data) {
            context.read<FactoryBloc>().add(UpdateFactory(factory.id, data));
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      );

  Future<void> _confirmDelete(FactoryEntity factory) async {
    final confirmed = await showConfirmDialog(context);
    if (confirmed == true && mounted) {
      context.read<FactoryBloc>().add(DeleteFactory(factory.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<FactoryBloc, FactoryState>(
      listener: (context, state) {
        if (state is FactoryActionSuccess) {
          AppToast.success(context, state.message);
        } else if (state is FactoryError) {
          AppToast.error(context, state.message);
        }
      },
      child: PageLayout(
        title: l10n.navFactories,
        addLabel: l10n.addFactory,
        onAdd: _showAdd,
        filterWidgets: [
          FilterField(
            hint: l10n.searchByName,
            onChanged: (v) {
              _nameFilter = v;
              _reload();
            },
          ),
          FilterField(
            hint: l10n.searchByProduct,
            icon: Icons.inventory_2_outlined,
            onChanged: (v) {
              _productFilter = v;
              _reload();
            },
          ),
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, catState) {
              final cats = catState is CategoryLoaded ? catState.categories : <CategoryEntity>[];
              return FilterDropdown<int>(
                hint: l10n.searchByCategory,
                icon: Icons.category_outlined,
                value: _categoryFilter,
                items: [
                  DropdownMenuItem<int?>(value: null, child: Text(l10n.allCategories)),
                  ...cats.map((c) => DropdownMenuItem<int?>(value: c.id, child: Text(c.categoryName))),
                ],
                onChanged: (v) => setState(() => _categoryFilter = v),
              );
            },
          ),
        ],
        table: BlocBuilder<FactoryBloc, FactoryState>(
          builder: (context, state) {
            final all = state is FactoryLoaded
                ? state.factories
                : (state is FactoryActionSuccess ? state.factories : <FactoryEntity>[]);
            final displayed = _categoryFilter == null
                ? all
                : all.where((f) => f.factoryCategoryId == _categoryFilter).toList();
            return FactoryTable(
              factories: displayed,
              isLoading: state is FactoryLoading,
              error: state is FactoryError ? state.message : null,
              onEdit: _showEdit,
              onDelete: _confirmDelete,
            );
          },
        ),
      ),
    );
  }
}
