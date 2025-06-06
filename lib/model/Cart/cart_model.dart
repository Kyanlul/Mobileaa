import 'cart_item.dart';

class CartModel {
  final String userId;
  final List<CartItem> items;

  CartModel({required this.userId, required this.items});

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.totalItemPrice);

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      userId: map['user_id'],
      items: List<CartItem>.from(
        map['items']?.map((item) => CartItem.fromMap(item)) ?? [],
      ),
    );
  }
}

