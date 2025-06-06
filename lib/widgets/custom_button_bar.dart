import 'package:flutter/material.dart';

import '../core/app_export.dart';

enum BottomBarEnum {Home, Cart, Account, Menu}

class CustomBottomBar extends StatefulWidget {
  final Function(BottomBarEnum)? onChanged;
  final int selectedIndex;  // Thêm biến này để nhận selectedIndex từ widget cha
  final Function(int)? onSelectedIndexChanged;  // Callback để thông báo khi index thay đổi

  const CustomBottomBar({super.key, this.onChanged, required this.selectedIndex, this.onSelectedIndexChanged});

  @override
  State<StatefulWidget> createState() => CustomBottomBarState();
}

class CustomBottomBarState extends State<CustomBottomBar> {
  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: "lib/assets/icons/nav_home.svg",
      activeIcon: "lib/assets/icons/nav_home.svg",
      title: "Home",
      type: BottomBarEnum.Home
    ),
    BottomMenuModel(
        icon: "lib/assets/icons/cart.svg",
        activeIcon: "lib/assets/icons/cart.svg",
        title: "Cart",
        type: BottomBarEnum.Cart
    ),
    BottomMenuModel(
        icon: "lib/assets/icons/nav_account.svg",
        activeIcon: "lib/assets/icons/nav_account.svg",
        title: "Account",
        type: BottomBarEnum.Account
    ),
    BottomMenuModel(
        icon: "lib/assets/icons/nav_menu.svg",
        activeIcon: "lib/assets/icons/nav_menu.svg",
        title: "Menu",
        type: BottomBarEnum.Menu
    )
  ];

  String _getRouteNameFromType(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.homeScreen;
      case BottomBarEnum.Cart:
        return AppRoutes.cartScreen;
      case BottomBarEnum.Account:
        return AppRoutes.profileScreen;
      case BottomBarEnum.Menu:
        return AppRoutes.menuScreen;
      default:
        return AppRoutes.homeScreen; // Mặc định nếu không có
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(13.h),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0X19000000),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(0, 10)
          )
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: widget.selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index){
          return BottomNavigationBarItem(
            icon: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  imagePath: bottomMenuList[index].icon,
                  height: 16.h,
                  width: 10.h,
                  color: const Color(0XFFD2D6DB),
                ),
                // SizedBox(height: 6.h),
                // Text(
                //   bottomMenuList[index].title ?? "",
                //   style: theme.textTheme.bodySmall!.copyWith(
                //     color: Color(0XFFD2D6DB),
                //   ),
                // )
              ],
            ),
            activeIcon: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                top: 8.h,
                bottom: 10.h
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: appTheme.lightBlue,
                    width: 2.h
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 4.h),
                  CustomImageView(
                    imagePath: bottomMenuList[index].activeIcon,
                    height: 16.h,
                    width: 10.h,
                    color: const Color(0xFF42A5F5),
                  ),
                  SizedBox(height: 6.h),
                Text(
                  bottomMenuList[index].title ?? "",
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: const Color(0xFF42A5F5),
                  ),
                ),
              ],
            ),
          ),
          label: '',
          );
        }),
        onTap: (index) {

          // Lấy tên route từ _getRouteNameFromType
          String routeName = _getRouteNameFromType(bottomMenuList[index].type);
          Navigator.pushReplacementNamed(context, routeName); // Điều hướng đến màn hình

          // Gọi callback nếu có
          widget.onChanged?.call(bottomMenuList[index].type);

          setState(() {});
        },
      ),
    );

  }
}

class BottomMenuModel {
  BottomMenuModel(
  {required this.icon,
  required this.activeIcon,
  this.title,
  required this.type});

  String icon;

  String activeIcon;

  String? title;

  BottomBarEnum type;
}