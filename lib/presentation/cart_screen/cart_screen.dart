import 'package:flutter/material.dart';
import 'package:untitled/core/app_export.dart';
import 'package:untitled/presentation/orders_screen/order_screen.dart';
import 'package:untitled/services/Database/cart_service.dart';
import 'package:intl/intl.dart';


import '../../model/Cart/cart_item.dart';
import '../../model/product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  // const CartScreen({super.key, required this.product});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final currencyFormatter =
  NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
  late Product product;
  late CartService cartService;
  late AuthService authService;

  var userId = AuthService().getCurrentUser()!.uid;

  // var userId = 'hcVXheLM9Jc0uSuHszIl27v3ugj1';
  late Future<List<CartItem>> _listCartItems;
  late List<CartItem> listSelectItem;

  @override
  void initState() {
    super.initState();
    cartService = CartService();
    authService = AuthService();
    _listCartItems = cartService.getCartItems(userId);
    listSelectItem = cartService.getListSelectItem();
    listSelectItem.clear();
    // userId = authService.getCurrentUser()!.uid;
    // _getCartItems();
  }

  List<CartItem> getListSelect() {
    return listSelectItem;
  }

  Future<List<CartItem>> _getCartItems() async {
    try {
      // return cartService.getCartItems(AuthService().getCurrentUser()!.uid);

      return cartService.getCartItems(userId);
    } on Exception {
      rethrow;
    }
  }

  // Tính tổng số tiền của giỏ hàng
  Future<double> _calculateTotalPrice(
      Future<List<CartItem>> futureCartItems) async {
    final cartItems = await futureCartItems;
    double total = 0.0;
    for (var item in cartItems) {
      if (item.isSelect == true) {
        if (!listSelectItem.contains(item)) {
          cartService.addItem(listSelectItem, item);
        }
        total += item.price * item.quantity;
      } else if (item.isSelect == false) {
        if (listSelectItem.contains(item)) {
          cartService.removeItem(listSelectItem, item);
        }
      }
    }
    print('list${listSelectItem.length}');
    return total;
  }

  void _deleteItem() async {
    await cartService.deleteProduct(userId);

    setState(() {
      _listCartItems = cartService.getCartItems(userId);
      listSelectItem.clear();
    });
  }

  void _updateQuantity(CartItem item, int newQuantity) async {
    if (newQuantity < 1) return; // Ngăn không cho số lượng nhỏ hơn 1
    setState(() {
      item.quantity = newQuantity;
    });

    // Cập nhật số lượng lên Firestore
    await cartService.updateCartItemQuantity(
        userId, item.productId, newQuantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {});
            Navigator.pop(context);
          },
        ),
        title: FutureBuilder<List<CartItem>>(
          future: _listCartItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('CART (Loading...)');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('CART (Empty)');
            }
            return Text('CART (${snapshot.data!.length})');
          },
        ),
        backgroundColor: LightCodeColors().lightBlue,
      ),
      body: FutureBuilder<List<CartItem>>(
        future: _listCartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading cart items.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          final items = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Checkbox
                            Checkbox(
                              value: item.isSelect,
                              onChanged: (val) {
                                setState(() {
                                  item.isSelect = val ?? false;
                                });
                              },
                            ),

                            Image.network(
                              item.imageUrl,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: CustomTextStyles.titleProductBlack
                                        .copyWith(fontSize: 14.h),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        currencyFormatter.format(item.price * 1000),
                                        style:
                                            CustomTextStyles.titleSmallPrimary,
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: item.quantity > 1
                                            ? () {
                                                _updateQuantity(
                                                    item, item.quantity - 1);
                                              }
                                            : null,
                                        iconSize: 15,
                                      ),
                                      Text('${item.quantity}'),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          _updateQuantity(
                                              item, item.quantity + 1);
                                        },
                                        iconSize: 15,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Tổng tiền
              FutureBuilder<double>(
                future: _calculateTotalPrice(_listCartItems),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Center(child: Text('Error calculating total price.')),
                    );
                  }

                  final totalPrice = snapshot.data!;
                  return SizedBox(
                    height: 120.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total: ' +  currencyFormatter.format(totalPrice * 1000),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            cartService.setListSelectItem(listSelectItem);
                            print(cartService.getListSelectItem().length);
                            print(listSelectItem.length);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderScreen(
                                          items: listSelectItem,
                                        )));
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 60)),
                          child: Text(
                            'Buy',
                            style: CustomTextStyles.titleProductBlack
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        if (listSelectItem.isNotEmpty)
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.only(top: 10, right: 10),
                              decoration: const BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white),
                                onPressed: _deleteItem,
                              ),
                            ),
                          ),

                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
