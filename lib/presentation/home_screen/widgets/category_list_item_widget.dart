import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/core/app_export.dart';
import '../models/category_list_item_model.dart';

class CategoryListItemWidget extends StatelessWidget {
  final CategoryListItemModel categoryListItemObj;
  final VoidCallback? onTap;

  const CategoryListItemWidget({
    super.key,
    required this.categoryListItemObj,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              width: 44.h,
              height: 44.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: appTheme.orangeA200, // Màu của viền
                  width: 1.2,           // Độ dày của viền
                ),
                borderRadius: BorderRadius.circular(12.h), // Bo góc viền
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.h), // Bo góc ảnh phù hợp với viền
                child: Padding(
                  padding: EdgeInsets.all(8.h), // Khoảng cách để thu nhỏ ảnh bên trong
                  child: CustomImageView(
                    imagePath: categoryListItemObj.imageUrl,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              categoryListItemObj.name,
              style: TextStyle(
                fontSize: 10.h,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}