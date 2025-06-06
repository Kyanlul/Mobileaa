import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled/core/app_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../model/Cart/cart_item.dart';
import '../../model/order/orders_model.dart';
import '../../services/Database/my_order_service.dart';

class MyOrderScreen extends StatelessWidget {
  MyOrderService myOrderService = MyOrderService();
  String userId = AuthService().getCurrentUser()!.uid;

  MyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightCodeColors().lightBlue,
        title: Text(
          "My Order",
          style: CustomTextStyles.titleProductBlack
              .copyWith(color: Colors.white, fontSize: 18.h),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.homeScreen)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Order List
          Expanded(
            child: buildOrderList(myOrderService.getOrdersByUserId(userId), context),
          ),
        ],
      ),
    );
  }

  Widget buildOrderList(Future<List<OrdersModel>> futureOrders, BuildContext context) {
    return FutureBuilder<List<OrdersModel>>(
      future: futureOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error  : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No orders found.'));
        } else {
          print('data khong rong');
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return _buildOrderCard(orders[index], context);
            },
          );
        }
      },
    );
  }

  Widget _buildTab(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.deepPurple : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrdersModel orderModel, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Brand + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.storefront, color: Color(0xFFFF6F00), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "eSHOP",
                      style: CustomTextStyles.titleProductBlack.copyWith(
                        fontSize: 16.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Delivered",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Shipping info
            Row(
              children: [
                const Icon(Icons.local_shipping_outlined, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shipped on: ${orderModel.createdAt.toString().substring(0, 10)}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        "Your package has been delivered successfully.",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Product List
            Column(
              children: [
                for (int i = 0; i < orderModel.productItems.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildProductItem(orderModel.productItems[i], context),
                  ),
              ],
            ),

            Divider(thickness: 1, color: Colors.grey.shade300),
            const SizedBox(height: 8),

            // Total + Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${orderModel.productItems.length} items • \$${orderModel.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),



              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildProductItem(CartItem cartItem, BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 60,
              width: 60,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(cartItem.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${cartItem.price}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      Text("x${cartItem.quantity}"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: () {
              showReviewDialog(context, cartItem.productId);
            },
            icon: const Icon(Icons.rate_review, size: 16, color: Color(0xFFFF6F00)),
            label: const Text("Review", style: TextStyle(color: Color(0xFFFF6F00))),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: Color(0xFFFF6F00)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }


  void showReviewDialog(BuildContext context, String productId) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Write a Review'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final userName = nameController.text.trim();
              final title = titleController.text.trim();
              final content = contentController.text.trim();

              if (userName.isEmpty || title.isEmpty || content.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              final review = {
                'review_id': generateReviewId(),
                'review_title': title,
                'review_content': content,
                'user_name': userName,
              };
              print(productId);
              try {
                // Tìm document có product_id tương ứng
                final query = await FirebaseFirestore.instance
                    .collection('products')
                    .where('product_id', isEqualTo: productId)
                    .get();

                if (query.docs.isNotEmpty) {
                  final docId = query.docs.first.id;

                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(docId)
                      .update({
                    'reviews': FieldValue.arrayUnion([review]),
                  });

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Review submitted!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product not found!')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, // màu chữ trắng
              backgroundColor: Colors.blue,  // màu nền nút (bạn muốn gì cũng được)
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }



  String generateReviewId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(14, (index) => chars[rand.nextInt(chars.length)]).join();
  }



}
