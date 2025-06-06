import 'package:cloud_firestore/cloud_firestore.dart';

import '../Cart/cart_item.dart';

class OrdersModel {
  final String? orderId; // ID đơn hàng (lấy từ Firestore document ID)
  final String userId;
  final List<CartItem> productItems;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  OrdersModel({
    required this.orderId,
    required this.userId,
    required this.productItems,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });


  factory OrdersModel.fromJson(String id, Map<String, dynamic> json) {


    final List<dynamic> items = json['orderItems'] ?? [];
    print('id ${json['createdAt']}');


    return OrdersModel(
      orderId: id,

      userId: json['userId'] ?? 'Unknown',
      productItems: items.map((item) => CartItem.fromMap(item)).toList(),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Pending',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }




  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'orderItems': productItems.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt,
      'orderId' : orderId,
    };
  }
}
