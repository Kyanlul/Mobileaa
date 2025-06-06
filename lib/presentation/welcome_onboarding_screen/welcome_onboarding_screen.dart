import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class WelcomeOnboardingScreen extends StatelessWidget {
  const WelcomeOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      // backgroundColor: appTheme.deepPurpleA200,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(
              'lib/assets/images/774-7748560_ecommerce-benefits-e-commerce-economics.png',
            ),
            fit: BoxFit.contain,
            alignment: Alignment(0, -0.9),
          ),
        ),

        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,  // Đảm bảo Container sẽ được đẩy xuống dưới
              child: Container(
                width: 600,
                height: 600,
                decoration: const BoxDecoration(
                  // color: appTheme.deepPurpleA200,
                  // borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 150), // Thêm khoảng cách từ đầu cho đẹp
                    SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "SnapShop".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 62, // Điều chỉnh kích thước font chữ theo nhu cầu
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.2, // Điều chỉnh chiều cao giữa các dòng
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20), // Thêm khoảng cách giữa SnapShop và Your Shopping
                    const SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Your Shopping, Your Way",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 32, // Điều chỉnh kích thước font chữ theo nhu cầu
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.2, // Điều chỉnh chiều cao giữa các dòng
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 190), // Thêm khoảng cách giữa các nút và đáy
                    Container(
                      width: 310,
                      margin: const EdgeInsets.only(),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              text: 'Login',
                              height: 44.h,
                              leftIcon: const Icon(
                                Icons.account_circle_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                              buttonStyle: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.signInScreen);
                              },
                            ),
                          ),
                          SizedBox(width: 12.h), // Khoảng cách giữa 2 nút
                          Expanded(
                            child: CustomElevatedButton(
                              text: 'Guest',
                              height: 44.h,
                              leftIcon: const Icon(
                                Icons.card_travel,
                                size: 20,
                                color: Colors.white,
                              ),
                              buttonStyle: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.homeScreen);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),




              ),
            ),
          ],
        ),


      ),
    );
  }

}




