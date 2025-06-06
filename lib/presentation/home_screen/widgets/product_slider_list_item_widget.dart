import 'package:flutter/material.dart';
import 'package:untitled/core/app_export.dart';
import 'package:untitled/model/product.dart';

class ProductSliderListItemWidget extends StatelessWidget {
  ProductSliderListItemWidget(this.product, {super.key});

  Product product;

  @override
  Widget build(BuildContext context) {
    print(product.img_link);
    return Container(
        color: Colors.white,
        width: 110.h,
        height: 140.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomImageView(
              imagePath: product.img_link,
              fit: BoxFit.contain,
              height: 90.h,
            ),
            SizedBox(height: 32.h),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  'SALE ${product.discount_percentage}',
                  style: CustomTextStyles.labelLargePrimary,
                ),
              ),
            )
          ],
        ));
  }
}
