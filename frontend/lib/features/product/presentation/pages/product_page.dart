import 'dart:math';

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
import 'package:factory_management/shared/widgets/page_layout.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ProductBloc>()..add(const LoadProducts())),
        BlocProvider(create: (_) => sl<FactoryBloc>()..add(const LoadFactories())),
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
                  DropdownMenuItem<int?>(value: null, child: Text(l10n.allFactories)),
                  ...factories.map((f) => DropdownMenuItem<int?>(value: f.id, child: Text(f.name))),
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
                : (state is ProductActionSuccess ? state.products : <ProductEntity>[]);
            final displayed = all.where((p) {
              final matchesName = _nameFilter.isEmpty || p.name.toLowerCase().contains(_nameFilter);
              final matchesFactory = _factoryFilter == null || p.factoryId == _factoryFilter;
              return matchesName && matchesFactory;
            }).toList();
            return _ExpandableProductTable(
              products: displayed,
              isLoading: state is ProductLoading,
              error: state is ProductError ? state.message : null,
              onEdit: (p) => _showForm(product: p),
              onDelete: _confirmDelete,
            );
          },
        ),
      ),
    );
  }
}

class _ExpandableProductTable extends StatefulWidget {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? error;
  final void Function(ProductEntity) onEdit;
  final void Function(ProductEntity) onDelete;

  const _ExpandableProductTable({
    required this.products,
    required this.isLoading,
    required this.error,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ExpandableProductTable> createState() => _ExpandableProductTableState();
}

class _ExpandableProductTableState extends State<_ExpandableProductTable> {
  final Set<int> _expanded = {};

  void _toggle(int id) => setState(() {
        if (_expanded.contains(id)) {
          _expanded.remove(id);
        } else {
          _expanded.add(id);
        }
      });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = AppThemeColors.of(context);

    if (widget.isLoading) {
      return Center(child: CircularProgressIndicator(color: c.primary));
    }
    if (widget.error != null) {
      final isNetwork = widget.error == 'Unable to reach server';
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(isNetwork ? Icons.cloud_off_outlined : Icons.error_outline,
              size: 48, color: isNetwork ? c.textHint : c.error),
          const SizedBox(height: 12),
          Text(isNetwork ? l10n.unableToReachServer : widget.error!,
              style: TextStyle(color: c.textPrimary, fontSize: 15, fontWeight: FontWeight.w500)),
          if (isNetwork) ...[
            const SizedBox(height: 4),
            Text(l10n.checkBackendRunning, style: TextStyle(color: c.textSecondary, fontSize: 13)),
          ],
        ]),
      );
    }
    if (widget.products.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.inbox_outlined, size: 48, color: c.textHint),
          const SizedBox(height: 12),
          Text(l10n.noData, style: TextStyle(color: c.textSecondary, fontSize: AppFonts.base)),
        ]),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final width = max(AppSizes.tableMinWidth, constraints.maxWidth - 2 * AppSizes.base);
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
              constraints: BoxConstraints(minWidth: width),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header — matches DataTable heading style exactly
                  Container(
                    height: AppSizes.tableHeaderHeight,
                    decoration: BoxDecoration(
                      color: c.tableHeader,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(AppSizes.radiusMd)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      Expanded(child: Text(l10n.colId, style: _hStyle(c))),
                      const SizedBox(width: 20),
                      Expanded(child: Text(l10n.colName, style: _hStyle(c))),
                      const SizedBox(width: 20),
                      Expanded(child: Text(l10n.colModels, style: _hStyle(c))),
                      const SizedBox(width: 20),
                      Expanded(child: Text(l10n.colActions, style: _hStyle(c))),
                      const SizedBox(width: 32), // chevron placeholder
                    ]),
                  ),
                  Divider(height: 1, color: c.border),
                  ...widget.products.map((p) => _ProductExpandableRow(
                        product: p,
                        expanded: _expanded.contains(p.id),
                        onToggle: () => _toggle(p.id),
                        onEdit: () => widget.onEdit(p),
                        onDelete: () => widget.onDelete(p),
                      )),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  TextStyle _hStyle(AppThemeColors c) => TextStyle(
      fontSize: AppFonts.sm, fontWeight: FontWeight.w600, color: c.textSecondary);
}

class _ProductExpandableRow extends StatelessWidget {
  final ProductEntity product;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductExpandableRow({
    required this.product,
    required this.expanded,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Row — same height / padding / font as DataTable data rows
        SizedBox(
          height: AppSizes.tableRowHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              // ID
              Expanded(
                child: Text('${product.id}',
                    style: TextStyle(fontSize: AppFonts.sm, color: c.textSecondary)),
              ),
              const SizedBox(width: 20),
              // Name
              Expanded(
                child: Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 20),
              // Models — same chips as before
              Expanded(child: _ModelChips(models: product.models)),
              const SizedBox(width: 20),
              // Actions + chevron in same column space
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    actionCell(context, onEdit: onEdit, onDelete: onDelete),
                    const SizedBox(width: 8),
                    // Chevron — the only affordance that triggers expand
                    SizedBox(
                      width: 28,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: AnimatedRotation(
                          turns: expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 22,
                            color: expanded ? c.primary : c.textSecondary,
                          ),
                        ),
                        onPressed: onToggle,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
        // Expanded models panel
        if (expanded) _ModelsPanel(models: product.models, l10n: l10n, colors: c),
        Divider(height: 1, color: c.border),
      ],
    );
  }
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
      children: models.take(3).map((m) => Chip(
            label: Text(m.name,
                style: TextStyle(fontSize: AppFonts.xs, color: c.chipText)),
            backgroundColor: c.chipBg,
            side: BorderSide.none,
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )).toList(),
    );
  }
}

class _ModelsPanel extends StatelessWidget {
  final List<ModelEntity> models;
  final AppLocalizations l10n;
  final AppThemeColors colors;

  const _ModelsPanel({required this.models, required this.l10n, required this.colors});

  @override
  Widget build(BuildContext context) {
    final c = colors;
    return Container(
      color: c.tableHeader,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: models.isEmpty
          ? Text(l10n.noModelsAdded,
              style: TextStyle(color: c.textHint, fontSize: AppFonts.sm))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: models.map((m) => _ModelCard(model: m, colors: c)).toList(),
            ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final ModelEntity model;
  final AppThemeColors colors;

  const _ModelCard({required this.model, required this.colors});

  @override
  Widget build(BuildContext context) {
    final c = colors;
    final imageUrls = (model.images ?? '')
        .split(',')
        .where((s) => s.isNotEmpty)
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + price row
          Row(children: [
            Text(model.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppFonts.base)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: c.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('\$${model.price.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: AppFonts.xs, color: c.primary, fontWeight: FontWeight.w600)),
            ),
          ]),
          if (model.info.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(model.info,
                style: TextStyle(fontSize: AppFonts.sm, color: c.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
          if (imageUrls.isNotEmpty) ...[
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: imageUrls.map((url) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    child: Image.network(
                      url,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 72,
                        height: 72,
                        color: c.border,
                        child: Icon(Icons.broken_image_outlined,
                            size: 28, color: c.textHint),
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
