import 'package:flutter/material.dart';

import '../../core/design_tokens.dart';

/// Styled text input field matching the form design from Screen D.
/// 8px radius, 1px outline border, 2px primary border on focus.
class NASInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const NASInputField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: NASSpacing.xs),
          child: Text(
            label,
            style: NASTypography.labelMd.copyWith(
              color: NASColors.onSurfaceVariant,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          style: NASTypography.bodyMd.copyWith(color: NASColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

/// Styled dropdown select field matching the form design from Screen D.
class NASSelectField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final String? hint;

  const NASSelectField({
    super.key,
    required this.label,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: NASSpacing.xs),
          child: Text(
            label,
            style: NASTypography.labelMd.copyWith(
              color: NASColors.onSurfaceVariant,
            ),
          ),
        ),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
          ),
          style: NASTypography.bodyMd.copyWith(color: NASColors.onSurface),
          dropdownColor: NASColors.surfaceContainerLowest,
          borderRadius: NASRadius.defaultBorderRadius,
        ),
      ],
    );
  }
}

/// Upload dropzone with dashed border — matches the file upload area from Screen D.
class NASUploadZone extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData icon;
  final String? fileName;

  const NASUploadZone({
    super.key,
    this.label = 'Upload File (PDF, PNG)',
    this.onTap,
    this.icon = Icons.cloud_upload_outlined,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(NASSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(
            color: NASColors.outlineVariant,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          borderRadius: NASRadius.lgBorderRadius,
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: NASColors.onSurfaceVariant),
            const SizedBox(height: NASSpacing.xs),
            Text(
              fileName ?? label,
              style: NASTypography.labelMd.copyWith(
                color: NASColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
