import 'package:flutter/material.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_sizes.dart';
import 'package:factory_management/core/theme/app_theme.dart';
import 'package:factory_management/features/factory/domain/entities/factory_entity.dart';
import 'package:factory_management/features/product/domain/entities/product_entity.dart';
import 'package:factory_management/l10n/app_localizations.dart';
import 'package:factory_management/shared/widgets/app_button.dart';
import 'package:factory_management/shared/widgets/app_dialog.dart';
import 'package:factory_management/shared/widgets/app_text_field.dart';
import 'package:factory_management/shared/widgets/image_picker_field.dart';

class ProductFormDialog extends StatefulWidget {
  final ProductEntity? product;
  final List<FactoryEntity> factories;
  final void Function(Map<String, dynamic>) onSubmit;

  const ProductFormDialog({
    super.key,
    this.product,
    required this.factories,
    required this.onSubmit,
  });

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name = TextEditingController(text: widget.product?.name);
  int? _factoryId;
  final List<_ModelRow> _models = [];

  @override
  void initState() {
    super.initState();
    _factoryId = widget.product?.factoryId;
    if (widget.product != null) {
      for (final m in widget.product!.models) {
        _models.add(_ModelRow(
          name: m.name,
          price: m.price.toString(),
          info: m.info,
          imageUrls: (m.images ?? '').split(',').where((s) => s.isNotEmpty).toList(),
        ));
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final data = <String, dynamic>{
      'name': _name.text.trim(),
      'factory_id': _factoryId,
      'models': _models.map((m) => {
            'name': m.nameCtrl.text.trim(),
            'price': m.priceCtrl.text.trim(),
            'info': m.infoCtrl.text.trim(),
            if (m.imageUrls.isNotEmpty) 'images': m.imageUrls.join(','),
          }).toList(),
    };
    widget.onSubmit(data);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.product != null;
    return AppDialog(
      title: isEdit ? l10n.editProduct : l10n.addProduct,
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
                  child: AppDropdownField<int>(
                    label: l10n.navFactories,
                    hint: l10n.selectFactory,
                    value: _factoryId,
                    items: widget.factories
                        .map((f) => DropdownMenuItem(value: f.id, child: Text(f.name)))
                        .toList(),
                    onChanged: (v) => setState(() => _factoryId = v),
                    validator: (v) => v == null ? l10n.fieldRequired : null,
                  ),
                ),
                const SizedBox(width: AppSizes.base),
                Expanded(
                  child: AppTextField(
                    label: l10n.fieldProductName,
                    controller: _name,
                    validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xl),
            Row(
              children: [
                Text(l10n.colModels, style: const TextStyle(fontSize: AppFonts.lg, fontWeight: FontWeight.w700)),
                const Spacer(),
                AppButton(
                  label: l10n.addModel,
                  icon: Icons.add,
                  small: true,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => setState(() => _models.add(_ModelRow())),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            if (_models.isEmpty)
              Builder(builder: (ctx) {
                final c = AppThemeColors.of(ctx);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.base),
                  child: Text(l10n.noModelsAdded, style: TextStyle(color: c.textSecondary, fontSize: AppFonts.sm)),
                );
              }),
            ..._models.asMap().entries.map((e) => _buildModelRow(e.key, e.value, l10n)),
            const SizedBox(height: AppSizes.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildModelRow(int mi, _ModelRow model, AppLocalizations l10n) {
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
                  Text(l10n.modelN(mi + 1), style: const TextStyle(fontSize: AppFonts.sm, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, size: AppSizes.iconSizeSm, color: c.error),
                    onPressed: () => setState(() => _models.removeAt(mi)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: l10n.fieldModelName,
                          controller: model.nameCtrl,
                          validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null,
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: AppTextField(
                          label: l10n.fieldPrice,
                          controller: model.priceCtrl,
                          keyboardType: TextInputType.number,
                          validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
                  AppTextField(
                    label: l10n.fieldInfo,
                    controller: model.infoCtrl,
                    maxLines: 2,
                    validator: (v) => v == null || v.isEmpty ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  ImagePickerField(
                    initialUrls: model.imageUrls,
                    onChanged: (urls) => setState(() => model.imageUrls = urls),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
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
