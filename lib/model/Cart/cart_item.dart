class CartItem {
  final String productId;
  final String productName;
  final String imageUrl;
  final double price;
  int quantity;
  bool isSelect;

  CartItem({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.isSelect = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItem &&
          runtimeType == other.runtimeType &&
          productId == other.productId);

  @override
  int get hashCode => productId.hashCode;

  double get totalItemPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_image': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
  // Map<String, dynamic> toJson() {
  //   return {
  //     'productId': productId,
  //     'productName': productName,
  //     'price': price,
  //     'quantity': quantity,
  //     'imageUrl': imageUrl,
  //   };
  // }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    // print(' day la map $map') ;
    return CartItem(
      productId: map['product_id'],
      productName: map['product_name'],
      imageUrl: map['product_image'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }

}
