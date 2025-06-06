import 'package:flutter/material.dart';
import 'package:untitled/core/app_export.dart';
import '../data/models/selection_popup_model.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    this.alignment,
    this.width,
    this.boxDecoration,
    this.focusNode,
    this.icon,
    this.iconSize,
    this.autofocus = false,
    this.textStyle,
    this.hintText,
    this.hintStyle,
    this.items,
    this.prefix,
    this.prefixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
  });

  final Alignment? alignment;
  final double? width;
  final BoxDecoration? boxDecoration;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextStyle? textStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool filled;
  final FormFieldValidator<SelectionPopupModel>? validator;
  final Container? icon;
  final double? iconSize;
  final List<SelectionPopupModel>? items;
  final Function(SelectionPopupModel)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(alignment: alignment ?? Alignment.center, child: dropDownWidget)
        : dropDownWidget;
  }

  Widget get dropDownWidget => Container(
    width: width ?? double.maxFinite,
    decoration: boxDecoration,
    child: DropdownButtonFormField<SelectionPopupModel>(
      focusNode: focusNode,
      icon: icon,
      iconSize: iconSize ?? 24,
      autofocus: autofocus,
      isExpanded: true,
      style: textStyle ?? CustomTextStyles.bodyMediumPrimary_1,
      hint: Text(
        hintText ?? "",
        style: hintStyle ?? CustomTextStyles.bodyMediumPrimary_1,
        overflow: TextOverflow.ellipsis,
      ),
      items: items?.map((SelectionPopupModel item) {
        return DropdownMenuItem<SelectionPopupModel>(
          value: item,
          child: Text(
            item.title,
            overflow: TextOverflow.ellipsis,
            style: hintStyle ?? CustomTextStyles.bodyMediumPrimary_1,
          ),
        );
      }).toList(),
      decoration: decoration,
      validator: validator,
      onChanged: (value) {
        onChanged!(value!);
      },
      ),
    );

  InputDecoration get decoration =>
      InputDecoration(
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        isDense: true,
        contentPadding: contentPadding ?? EdgeInsets.all(10.h),
        fillColor: fillColor ?? theme.colorScheme.onPrimaryContainer,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.h),
              borderSide: BorderSide(
                color: appTheme.gray200,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.h),
              borderSide: BorderSide(
                color: appTheme.gray200,
              ),
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.h)).copyWith(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1,
              ),
            ),
      );
}