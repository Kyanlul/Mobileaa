import 'package:flutter/material.dart';
import 'package:untitled/core/app_export.dart';

class CustomTextFormField extends StatelessWidget {
  final Alignment? alignment;
  final double? width;
  final BoxDecoration? boxDecoration;
  final EdgeInsetsGeometry? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextStyle? textStyle;
  final bool obscureText;
  final bool readonly;
  final VoidCallback? onTap;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool filled;
  final String? Function(String?)? validator;


  const CustomTextFormField({
    super.key,

    this.alignment,
    this.width,
    this.boxDecoration,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.readonly = false,
    this.onTap,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
        alignment: alignment ?? Alignment.center,
        child: textFormFieldWidget(context))
        : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) =>
      Container(
        width: width ?? double.maxFinite,
        decoration: boxDecoration,
        child: TextFormField(
          scrollPadding:
          EdgeInsets.only(bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom),
          controller: controller,
          focusNode: focusNode,
          onTapOutside: (event) {
            if (focusNode != null) {
              focusNode?.unfocus();
            } else {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          autofocus: autofocus,
          style: textStyle ?? CustomTextStyles.bodyMediumPrimary_1,
          obscureText: obscureText,
          readOnly: readonly,
          onTap: () {
            onTap?.call();
          },
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
        ),
      );

  InputDecoration get decoration =>
      InputDecoration(
          hintText: hintText ?? "",
          hintStyle: hintStyle ?? CustomTextStyles.bodyMediumBluegray100,
          prefixIcon: prefix,
          prefixIconConstraints: prefixConstraints,
          suffixIcon: suffix,
          suffixIconConstraints: suffixConstraints,
          isDense: true,
          contentPadding: contentPadding ?? EdgeInsets.all(100.h),
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
          errorBorder: borderDecoration ??
              OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.h)).copyWith(
                borderSide: BorderSide(
                  color: appTheme.red600,
                  width: 1,
                ),
              ),
          focusedErrorBorder: borderDecoration ??
              OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.h)).copyWith(
                borderSide: BorderSide(
                  color: appTheme.red600,
                  width: 1,
                ),
              ),
          errorStyle: TextStyle(
            color: appTheme.red600,
            fontSize: 12.fSize,
          ),
      );
}