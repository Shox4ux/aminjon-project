import 'package:flutter/material.dart';
import 'package:factory_management/core/constants/app_fonts.dart';
import 'package:factory_management/core/constants/app_sizes.dart';
import 'package:factory_management/core/theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final bool readOnly;
  final Widget? suffix;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.readOnly = false,
    this.suffix,
    this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.sm,
            fontWeight: FontWeight.w500,
            color: c.textPrimary,
            fontFamily: AppFonts.inter,
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          focusNode: focusNode,
          onChanged: onChanged,
          style: TextStyle(
              fontSize: AppFonts.base,
              color: c.textPrimary,
              fontFamily: AppFonts.inter),
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            isDense: true,
          ),
        ),
      ],
    );
  }
}

class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final String? hint;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppThemeColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFonts.sm,
            fontWeight: FontWeight.w500,
            color: c.textPrimary,
            fontFamily: AppFonts.inter,
          ),
        ),
        const SizedBox(height: AppSizes.xs),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          hint: hint != null
              ? Text(hint!, style: TextStyle(color: c.textHint))
              : null,
          style: TextStyle(
              fontSize: AppFonts.base,
              color: c.textPrimary,
              fontFamily: AppFonts.inter),
          decoration: const InputDecoration(isDense: true),
          isExpanded: true,
          dropdownColor: c.surface,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: c.textSecondary),
        ),
      ],
    );
  }
}
