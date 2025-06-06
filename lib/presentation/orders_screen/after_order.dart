import 'package:flutter/material.dart';
import 'package:untitled/core/app_export.dart';
import 'package:untitled/presentation/orders_screen/my_order_screen.dart';
import 'package:untitled/services/Database/product_service.dart';
import 'package:untitled/widgets/custom_elevated_button.dart';

import '../../model/product.dart';
import '../../widgets/product_card.dart';
import '../detail_screen/detail_screen.dart';

class AfterOrder extends StatefulWidget {
  const AfterOrder({super.key});

  @override
  State<AfterOrder> createState() => _AfterOrderState();
}

class _AfterOrderState extends State<AfterOrder> {
  Future<List<Product>> fetchRelatedProducts() async {
    final products = await ProductService().fetchAllProducts();
    return products.take(20).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 100.h,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Order Placed!',
                    style: TextStyle(
                      fontSize: 24.h,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Thank you for your purchase.\nYou’ll receive order updates soon.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.h, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      text: 'View my orders',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyOrderScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),


          ],
        ),
      ),
    );
  }


  Widget _buildRelatedProductItem() {
    return FutureBuilder<List<Product>>(
      future: fetchRelatedProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No related products found.'));
        } else {
          final relatedProducts = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) {
              final product = relatedProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ),
                  );
                },
                child: ProductCard(product),
              );
            },
          );
        }
      },
    );
  }
}
