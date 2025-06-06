import 'package:flutter/cupertino.dart';
import 'package:untitled/core/app_export.dart';
import '../models/banner_list_item_model.dart';

class BannerListItemWidget extends StatelessWidget {
  BannerListItemWidget(this.bannerListItemObj, {super.key});

  BannerListItemModel bannerListItemObj;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280.h,
      child: CustomImageView(
        imagePath: bannerListItemObj.image,
        width: 280.h,
        radius: BorderRadius.circular(6.h),
      ),
    );
  }
}