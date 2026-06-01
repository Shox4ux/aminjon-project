import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/app/di/injection.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_sizes.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/core/utils/app_toast.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_bloc.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_event.dart';
import 'package:factory_management/features/factory/presentation/bloc/factory_state.dart';
import 'package:factory_management/features/product/domain/entities/model_entity.dart';
import 'package:factory_management/features/product/domain/entities/product_entity.dart';
import 'package:factory_management/features/product/presentation/bloc/product_bloc.dart';
import 'package:factory_management/features/product/presentation/bloc/product_event.dart';
import 'package:factory_management/features/product/presentation/bloc/product_state.dart';
import 'package:factory_management/features/product/presentation/widgets/product_form_dialog.dart';
import 'package:factory_management/l10n/app_localizations.dart';
import 'package:factory_management/shared/widgets/app_dialog.dart';
import 'package:factory_management/shared/widgets/compact_tag.dart';
import 'package:factory_management/shared/widgets/page_layout.dart';

const double _colIdWidth = 48;
const double _colNameWidth = 180;
const double _colActionsWidth = 72;

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => sl<ProductBloc>()..add(const LoadProducts())),
        BlocProvider(
            create: (_) => sl<FactoryBloc>()..add(const LoadFactories())),
      ],
      child: const _ProductPageContent(),
    );
  }
}

class _ProductPageContent extends StatefulWidget {
  const _ProductPageContent();

  @override
  State<_ProductPageContent> createState() => _ProductPageContentState();
}

class _ProductPageContentState extends State<_ProductPageContent> {
  String _nameFilter = '';
  int? _factoryFilter;

  List<FactoryEntity> _getFactories(FactoryState state) {
    if (state is FactoryLoaded) return state.factories;
    if (state is FactoryActionSuccess) return state.factories;
    return [];
  }

  void _showForm({ProductEntity? product}) {
    final factories = _getFactories(context.read<FactoryBloc>().state);
    showDialog(
      context: context,
      builder: (_) => ProductFormDialog(
        product: product,
        factories: factories,
        onSubmit: (data) {
          if (product == null) {
            context.read<ProductBloc>().add(CreateProduct(data));
          } else {
            context.read<ProductBloc>().add(UpdateProduct(product.id, data));
          }
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    );
  }

  Future<void> _confirmDelete(ProductEntity product) async {
    final confirmed = await showConfirmDialog(context);
    if (confirmed == true && mounted) {
      context.read<ProductBloc>().add(DeleteProduct(product.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductActionSuccess) {
          AppToast.success(context, state.message);
        } else if (state is ProductError) {
          AppToast.error(context, state.message);
        }
      },
      child: PageLayout(
        title: l10n.navProducts,
        addLabel: l10n.addProduct,
        onAdd: () => _showForm(),
        filterWidgets: [
          FilterField(
            hint: l10n.searchByName,
            onChanged: (v) => setState(() => _nameFilter = v.toLowerCase()),
          ),
          BlocBuilder<FactoryBloc, FactoryState>(
            builder: (context, factState) {
              final factories = _getFactories(factState);
              return FilterDropdown<int>(
                hint: l10n.filterByFactory,
                icon: Icons.factory_outlined,
                value: _factoryFilter,
                items: [
                  DropdownMenuItem<int?>(
                      value: null, child: Text(l10n.allFactories)),
                  ...factories.map((f) =>
                      DropdownMenuItem<int?>(value: f.id, child: Text(f.name))),
                ],
                onChanged: (v) => setState(() => _factoryFilter = v),
              );
            },
          ),
        ],
        table: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            final all = state is ProductLoaded
                ? state.products
                : (state is ProductActionSuccess
                    ? state.products
                    : <ProductEntity>[]);
            final displayed = all.where((p) {
              final matchesName = _nameFilter.isEmpty ||
                  p.name.toLowerCase().contains(_nameFilter);
              final matchesFactory =
                  _factoryFilter == null || p.factoryId == _factoryFilter;
              return matchesName && matchesFactory;
            }).toList();
            return _ProductTable(
              products: displayed,
              isLoading: state is ProductLoading,
              error: state is ProductError ? state.message : null,
              onEdit: _showForm,
              onDelete: _confirmDelete,
            );
          },
        ),
      ),
    );
  }
}

class _ProductTable extends StatelessWidget {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? error;
  final void Function({ProductEntity? product}) onEdit;
  final void Function(ProductEntity) onDelete;

  const _ProductTable({
    required this.products,
    required this.onEdit,
    required this.onDelete,
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
      return Center(child: Text(error!, style: TextStyle(color: c.error)));
    }
    if (products.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.inbox_outlined, size: 48, color: c.textHint),
          const SizedBox(height: 12),
          Text(l10n.noData,
              style:
                  TextStyle(color: c.textSecondary, fontSize: AppFonts.base)),
        ]),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.base),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          side: BorderSide(color: c.border),
        ),
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: c.tableHeader,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusMd)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                      width: _colIdWidth,
                      child: Text(l10n.colId, style: _headerStyle(c))),
                  SizedBox(
                      width: _colNameWidth,
                      child: Text(l10n.colName, style: _headerStyle(c))),
                  Expanded(child: Text(l10n.colModels, style: _headerStyle(c))),
                  SizedBox(
                      width: _colActionsWidth,
                      child: Text(l10n.colActions,
                          style: _headerStyle(c), textAlign: TextAlign.center)),
                ],
              ),
            ),
            Divider(height: 1, color: c.border),
            // Rows
            ...products.asMap().entries.map((e) {
              final p = e.value;
              final isLast = e.key == products.length - 1;
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: _colIdWidth,
                          child: Text('${p.id}',
                              style: TextStyle(
                                  fontSize: AppFonts.sm,
                                  color: c.textSecondary)),
                        ),
                        SizedBox(
                          width: _colNameWidth,
                          child: Text(p.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(child: _ModelChips(models: p.models)),
                        SizedBox(
                          width: _colActionsWidth,
                          child: actionCell(context,
                              onEdit: () => onEdit(product: p),
                              onDelete: () => onDelete(p)),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast) Divider(height: 1, color: c.border),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  TextStyle _headerStyle(AppThemeColors c) => TextStyle(
        fontSize: AppFonts.sm,
        fontWeight: FontWeight.w600,
        color: c.textSecondary,
      );
}

class _ModelChips extends StatelessWidget {
  final List<ModelEntity> models;
  const _ModelChips({required this.models});

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    if (models.isEmpty) return Text('—', style: TextStyle(color: c.textHint));
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...models.take(3).map((m) => CompactTag(m.name)),
        if (models.length > 3) CompactTag('+${models.length - 3}', muted: true),
      ],
    );
  }
}
