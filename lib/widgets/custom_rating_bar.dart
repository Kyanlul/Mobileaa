import 'package:flutter/material.dart';
import 'package:untitled/core/app_export.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRatingBar extends StatelessWidget {
  CustomRatingBar({
    super.key,
    this.alignment,
    this.ignoreGestures,
    this.initialRating,
    this.itemSize,
    this.itemCount,
    this.color,
    this.unselectedColor,
    this.onRatingUpdate,
  });

  final Alignment? alignment;

  final bool? ignoreGestures;

  final double? initialRating;

  final double? itemSize;

  final int? itemCount;

  final Color? color;

  final Color? unselectedColor;

  Function(double)? onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: ratingBarWidget,)
        : ratingBarWidget;
  }

  Widget get ratingBarWidget => RatingBar.builder(
    ignoreGestures: ignoreGestures ?? false,
    initialRating: initialRating ?? 0,
    minRating: 0,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemSize: itemSize ?? 12.h,
    unratedColor: unselectedColor ?? appTheme.blueGray100,
    itemCount: itemCount ?? 5,
    updateOnDrag: true,
    itemBuilder: (context, _) {
      return Icon(
        Icons.star,
        color: color,
      );
    },
    onRatingUpdate: (rating) {
      onRatingUpdate!.call(rating);
    },
  );
}