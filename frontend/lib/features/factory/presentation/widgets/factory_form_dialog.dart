import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:factory_management/app/di/injection.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_sizes.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/features/factory_category/domain/entities/category_entity.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_bloc.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_event.dart';
import 'package:factory_management/features/factory_category/presentation/bloc/category_state.dart';
import 'package:factory_management/l10n/app_localizations.dart';
import 'package:factory_management/shared/widgets/app_button.dart';
import 'package:factory_management/shared/widgets/app_dialog.dart';
import 'package:factory_management/shared/widgets/app_text_field.dart';
import 'package:factory_management/shared/widgets/image_picker_field.dart';

class FactoryFormDialog extends StatefulWidget {
  final FactoryEntity? factory;
  final void Function(Map<String, dynamic>) onSubmit;

  const FactoryFormDialog({super.key, this.factory, required this.onSubmit});

  @override
  State<FactoryFormDialog> createState() => _FactoryFormDialogState();
}

class _FactoryFormDialogState extends State<FactoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(text: widget.factory?.name);
  late final TextEditingController _phone = TextEditingController(text: widget.factory?.phone);
  late final TextEditingController _wechat = TextEditingController(text: widget.factory?.wechatId);
  late final TextEditingController _address = TextEditingController(text: widget.factory?.address);
  int? _categoryId;
  final List<_ProductRow> _products = [];

  @override
  void initState() {
    super.initState();
    _categoryId = widget.factory?.factoryCategoryId;
    if (widget.factory != null) {
      for (final p in widget.factory!.products) {
        final row = _ProductRow(name: p.name);
        for (final m in p.models) {
          row.models.add(_ModelRow(
          name: m.name, price: m.price.toString(), info: m.info,
          imageUrls: (m.images ?? '').split(',').where((s) => s.isNotEmpty).toList(),
        ));
        }
        _products.add(row);
      }
    }
  }

  @override
  void dispose() {
    _name.dispose(); _phone.dispose(); _wechat.dispose(); _address.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final data = <String, dynamic>{
      'name': _name.text.trim(),
      if (_phone.text.trim().isNotEmpty) 'phone': _phone.text.trim(),
      if (_wechat.text.trim().isNotEmpty) 'wechat_id': _wechat.text.trim(),
      if (_address.text.trim().isNotEmpty) 'address': _address.text.trim(),
      'factory_category_id': _categoryId,
      'products': _products.map((p) => {
        'name': p.nameCtrl.text.trim(),
        'models': p.models.map((m) => {
          'name': m.nameCtrl.text.trim(),
          'price': m.priceCtrl.text.trim(),
          'info': m.infoCtrl.text.trim(),
          if (m.imageUrls.isNotEmpty) 'images': m.imageUrls.join(','),
        }).toList(),
      }).toList(),
    };
    widget.onSubmit(data);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.factory != null;
    return BlocProvider(
      create: (_) => sl<CategoryBloc>()..add(const LoadCategories()),
      child: AppDialog(
        title: isEdit ? l10n.editFactory : l10n.addFactory,
        confirmLabel: isEdit ? l10n.actionUpdate : l10n.actionCreate,
        onConfirm: _submit,
        maxWidth: AppSizes.dialogMaxWidthLg,
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: l10n.fieldFactoryName,
                      controller: _name,
                      validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null,
                    ),
                  ),
                  const SizedBox(width: AppSizes.base),
                  Expanded(
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (ctx, state) {
                        final cats = state is CategoryLoaded ? state.categories : <CategoryEntity>[];
                        return AppDropdownField<int>(
                          label: l10n.fieldCategory,
                          hint: l10n.fieldSelectCategory,
                          value: _categoryId,
                          items: cats.map((c) => DropdownMenuItem(value: c.id, child: Text(c.categoryName))).toList(),
                          onChanged: (v) => setState(() => _categoryId = v),
                          validator: (v) => v == null ? l10n.fieldRequired : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.base),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: AppTextField(label: '${l10n.fieldPhone} ${l10n.optional}', hint: l10n.phonePlaceholder, controller: _phone)),
                  const SizedBox(width: AppSizes.base),
                  Expanded(child: AppTextField(label: '${l10n.fieldWechatId} ${l10n.optional}', hint: l10n.wechatPlaceholder, controller: _wechat)),
                ],
              ),
              const SizedBox(height: AppSizes.base),
              AppTextField(label: '${l10n.fieldAddress} ${l10n.optional}', controller: _address),
              const SizedBox(height: AppSizes.xl),
              Row(
                children: [
                  Text(l10n.navProducts, style: const TextStyle(fontSize: AppFonts.lg, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  AppButton(
                    label: l10n.addProduct,
                    icon: Icons.add,
                    small: true,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => setState(() => _products.add(_ProductRow())),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              if (_products.isEmpty)
                Builder(builder: (ctx) {
                  final c = AppThemeColors.of(ctx);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.base),
                    child: Text(l10n.noProductsAdded, style: TextStyle(color: c.textSecondary, fontSize: AppFonts.sm)),
                  );
                }),
              ..._products.asMap().entries.map((entry) => _buildProductRow(entry.key, entry.value, l10n)),
              const SizedBox(height: AppSizes.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductRow(int pi, _ProductRow product, AppLocalizations l10n) {
    return Builder(builder: (context) {
      final c = AppThemeColors.of(context);
      return Container(
        margin: const EdgeInsets.only(bottom: AppSizes.base),
        decoration: BoxDecoration(
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
              decoration: BoxDecoration(
                color: c.tableHeader,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusMd)),
              ),
              child: Row(
                children: [
                  Text(l10n.productN(pi + 1), style: const TextStyle(fontSize: AppFonts.sm, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  AppButton(
                    label: l10n.addModel,
                    icon: Icons.add,
                    small: true,
                    variant: AppButtonVariant.ghost,
                    onPressed: () => setState(() => product.models.add(_ModelRow())),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.close, size: AppSizes.iconSizeSm, color: c.error),
                    onPressed: () => setState(() => _products.removeAt(pi)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: AppTextField(
                label: l10n.fieldProductName,
                controller: product.nameCtrl,
                validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null,
              ),
            ),
            if (product.models.isNotEmpty) ...[
              Divider(height: 1, color: c.border),
              ...product.models.asMap().entries.map((me) => _buildModelRow(pi, me.key, me.value, l10n)),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildModelRow(int pi, int mi, _ModelRow model, AppLocalizations l10n) {
    return Builder(builder: (context) {
      final c = AppThemeColors.of(context);
      return Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: c.border))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l10n.modelN(mi + 1), style: TextStyle(fontSize: AppFonts.xs, fontWeight: FontWeight.w600, color: c.textSecondary)),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, size: AppSizes.iconSizeSm, color: c.error),
                  onPressed: () => setState(() => _products[pi].models.removeAt(mi)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: AppTextField(label: l10n.fieldModelName, controller: model.nameCtrl, validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null)),
                const SizedBox(width: AppSizes.sm),
                Expanded(child: AppTextField(label: l10n.fieldPrice, controller: model.priceCtrl, keyboardType: TextInputType.number, validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null)),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            AppTextField(label: l10n.fieldInfo, controller: model.infoCtrl, maxLines: 2, validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null),
            const SizedBox(height: AppSizes.sm),
            ImagePickerField(
              initialUrls: model.imageUrls,
              onChanged: (urls) => setState(() => model.imageUrls = urls),
            ),
          ],
        ),
      );
    });
  }
}

class _ProductRow {
  final TextEditingController nameCtrl;
  final List<_ModelRow> models;
  _ProductRow({String name = ''})
      : nameCtrl = TextEditingController(text: name),
        models = [];
}

class _ModelRow {
  final TextEditingController nameCtrl;
  final TextEditingController priceCtrl;
  final TextEditingController infoCtrl;
  List<String> imageUrls;
  _ModelRow({String name = '', String price = '', String info = '', List<String>? imageUrls})
      : nameCtrl = TextEditingController(text: name),
        priceCtrl = TextEditingController(text: price),
        infoCtrl = TextEditingController(text: info),
        imageUrls = imageUrls ?? [];
}
