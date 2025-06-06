import 'package:flutter/material.dart';
import 'package:untitled/core/app_export.dart';
import 'package:untitled/model/address_model.dart';
import 'package:untitled/model/order/orders_model.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/presentation/orders_screen/after_order.dart';
import 'package:untitled/presentation/orders_screen/edit_info.dart';
import 'package:untitled/services/Database/address_service/address_repository.dart';
import 'package:untitled/services/Database/cart_service.dart';
import 'package:untitled/services/Database/order_service.dart';
import 'package:untitled/services/Database/user_service.dart';
import 'package:untitled/widgets/custom_elevated_button.dart';

import '../../model/Cart/cart_item.dart';
import '../../core/vnpay_config.dart';
import '../../services/vnpay_flutter.dart';

class OrderScreen extends StatefulWidget {
  final List<CartItem> items;

  const OrderScreen({super.key,
    required this.items,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<CustomUser> customUser;
  String userId = '';
  late List<CartItem> listSelect;
  late double sum;
  String? _selectedDeliveryOption;
  String? _paymentMethod;
  double _shipPrice = 0;
  TextEditingController? _discountCodeController;
  OrdersService ordersService = OrdersService();
  late AddressModel addressModel;
  late CartService cartService;
  String? province;
  String? district;
  String? ward;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();

    userId = AuthService().getCurrentUser()!.uid;

    customUser = ProfileService().getUserProfile(userId);
    listSelect = widget.items;
    sum = calculateTotal();
    cartService = CartService();
    _getAddress();
  }

  double calculateTotal() {
    return listSelect.fold(0, (previousValue, item) {
      return previousValue + (item.quantity * item.price);
    });
  }

  Future<void> _getAddress() async {
    CustomUser currentUser = await customUser;
    if (currentUser.addressId != null) {
      final address =
          await AddressRepository().getAddressById(currentUser.addressId!);
      province = address!.province;
      district = address.district;
      ward = address.ward;
      print(' address : $address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay'),
        backgroundColor: LightCodeColors().lightBlue,
      ),
      body: Container(
        color: const Color(0xFFD9D9D9),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Thông tin địa chỉ người dùng
              FutureBuilder<CustomUser>(
                future: customUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No data available'));
                  }
                  final user = snapshot.data!;
                  return Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    height: 100.h,
                    width: double.maxFinite,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.h, top: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: LightCodeColors().orangeA200,
                          ),
                          SizedBox(width: 2.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name!,
                                style: CustomTextStyles.titleProductBlack
                                    .copyWith(fontSize: 24.h),
                              ),
                              Text(user.phone!),
                              Row(
                                children: [
                                  Text(province ?? ''),
                                  SizedBox(width: 2.h),
                                  Text(district ?? ''),
                                  SizedBox(width: 2.h),
                                  Text(ward ?? ''),
                                ],
                              )
                            ],
                          ),
                          const Spacer(),
                          Center(
                            child: IconButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditInfo(
                                      user: user,
                                    ),
                                  ),
                                );
                                if (result == true) {
                                  final updatedUser =
                                  ProfileService().getUserProfile(userId);
                                  setState(() {
                                    customUser = updatedUser;
                                  });
                                  updatedUser.then((value) async {
                                    final address = await AddressRepository()
                                        .getAddressById(value.addressId!);
                                    if (address != null) {
                                      setState(() {
                                        province = address.province;
                                        district = address.district;
                                        ward = address.ward;
                                      });
                                    }
                                  });
                                }
                              },
                              icon: const Icon(Icons.chevron_right_sharp),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),

              // 2. Order summary
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: LightCodeColors().orangeA200,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Order summary',
                            style: CustomTextStyles.titleProductBlack,
                          )
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 100.h * listSelect.length,
                        child: ListView.builder(
                          itemCount: listSelect.length,
                          itemBuilder: (context, index) {
                            final item = listSelect[index];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                CustomImageView(imagePath: item.imageUrl),
                              ),
                              title: Text(
                                item.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyles.titleProductBlack,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quantity: ${item.quantity}',
                                    style: CustomTextStyles.bodyMediumBluegray100,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '\$${item.price}',
                                        style: CustomTextStyles.labelLargePrimary
                                            .copyWith(fontSize: 18),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Text('${listSelect.length} items: '),
                          Text(
                            '\$$sum',
                            style: CustomTextStyles.labelLargePrimary,
                          ),
                          const SizedBox(width: 14),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Delivery options
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.fire_truck,
                            color: LightCodeColors().orangeA200,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Delivery options',
                            style: CustomTextStyles.titleProductBlack,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildDeliveryOption(
                        'Priority',
                        5,
                        'Receive from ${now.day + 1}-${now.month}-${now.year}',
                        province,
                      ),
                      _buildDeliveryOption(
                        'Standard',
                        3,
                        'Receive from ${now.day + 2}-${now.month}-${now.year}',
                        province,
                      ),
                      _buildDeliveryOption(
                        'Saver',
                        2,
                        'Receive from ${now.day + 3}-${now.month}-${now.year}',
                        province,
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Voucher (giữ nguyên, chưa cho áp dụng thực)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.redeem,
                            color: LightCodeColors().orangeA200,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Voucher',
                            style: CustomTextStyles.titleProductBlack,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _discountCodeController,
                              decoration: InputDecoration(
                                hintText: 'Enter discount code',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomElevatedButton(
                              text: 'Apply',
                              onPressed: () {
                                print('voucher: $_discountCodeController');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 5. Payment Method (thêm 'VNPay' bên cạnh COD)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.payments_sharp,
                            color: LightCodeColors().orangeA200,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Payment method',
                            style: CustomTextStyles.titleProductBlack,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // COD
                      _buildPaymentMethod('COD (Thanh toán khi nhận hàng)'),
                      const SizedBox(height: 8),
                      // VNPay
                      _buildPaymentMethod('VNPay'),
                    ],
                  ),
                ),
              ),

              // 6. Payment details (giữ nguyên)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.payment_outlined,
                            color: LightCodeColors().orangeA200,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Payment details',
                            style: CustomTextStyles.titleProductBlack,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            'Total cost of goods:',
                            style: CustomTextStyles.bodyMediumBluegray100
                                .copyWith(color: Colors.grey),
                          ),
                          const Spacer(),
                          Text(
                            '\$${calculateTotal()}',
                            style: TextStyle(color: LightCodeColors().orangeA200),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            'Total shipping:',
                            style: CustomTextStyles.bodyMediumBluegray100
                                .copyWith(color: Colors.grey),
                          ),
                          const Spacer(),
                          Text(
                            '\$$_shipPrice',
                            style: TextStyle(color: LightCodeColors().orangeA200),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            'Total payment:',
                            style: CustomTextStyles.titleProductBlack
                                .copyWith(fontSize: 14),
                          ),
                          const Spacer(),
                          Text(
                            '\$${(calculateTotal() + _shipPrice).toStringAsFixed(2)}',
                            style: TextStyle(color: LightCodeColors().orangeA200),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 7. Nút "Buy now" xử lý tuỳ theo payment method
              SizedBox(height: 4.h),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.h),
                  child: Center(
                    child: CustomElevatedButton(
                      text: 'Buy now',
                      onPressed: () async {
                        final totalAmount = calculateTotal() + _shipPrice;

                        if (_paymentMethod == null) {
                          // Chưa chọn phương thức thanh toán
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng chọn phương thức thanh toán.'),
                            ),
                          );
                          return;
                        }

                        if (_paymentMethod == 'COD (Thanh toán khi nhận hàng)') {
                          // --- COD: Lưu đơn ngay lập tức ---
                          OrdersModel order = OrdersModel(
                            orderId: '',
                            userId: userId,
                            productItems: listSelect,
                            totalPrice: totalAmount,
                            status: 'Pending',
                            createdAt: DateTime.now(),
                          );

                          await ordersService.createOrder(order);
                          await cartService.deleteProduct(userId);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AfterOrder(),
                            ),
                          );
                        } else if (_paymentMethod == 'VNPay') {
                          // --- VNPay: Mở WebView, chờ callback ---
                          // 1. Sinh một orderId tạm để đưa vào vnp_TxnRef
                          final String orderId =
                          DateTime.now().millisecondsSinceEpoch.toString();
                          // 2. Tạo expires = now + 15 phút (tuỳ bạn)
                          final DateTime expireDate =
                          DateTime.now().add(const Duration(minutes: 15));

                          // 3. Sinh paymentUrl
                          final String paymentUrl =
                          ordersService.generateVnPayUrl(
                            orderId: orderId,
                            amount: totalAmount,
                            expireDate: expireDate,
                            ipAddress: '0.0.0.0',
                          );

                          // 4. Mở WebView / browser để thanh toán VNPAY
                          await VNPAYFlutter.instance.show(
                            context: context,
                            paymentUrl: paymentUrl,
                            appBarTitle: 'Thanh toán VNPAY',
                            onPaymentSuccess: (params) async {
                              // Khi responseCode == "00" (thành công)
                              // 5. Lưu đơn hàng vào Firestore (sau khi thanh toán)
                              OrdersModel order = OrdersModel(
                                orderId: '', // Service sẽ tự generate ID mới
                                userId: userId,
                                productItems: listSelect,
                                totalPrice: totalAmount,
                                status: 'Paid',
                                createdAt: DateTime.now(),
                              );
                              await ordersService.createOrder(order);
                              await cartService.deleteProduct(userId);

                              // 6. Điều hướng sang màn AfterOrder
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AfterOrder(),
                                ),
                              );
                            },
                            onPaymentError: (params) {
                              // Thanh toán thất bại hoặc user hủy
                              String code = params['vnp_ResponseCode'] ?? 'N/A';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Thanh toán VNPAY thất bại (code: $code)',
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          // Nếu bạn sau này thêm "Chuyển khoản" riêng, xử lý ở đây
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Widget để hiển thị một tùy chọn giao hàng
  Widget _buildDeliveryOption(
      String title, double price, String description, String? province) {
    price = province != 'Hà Nội' ? price + 5 : price;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedDeliveryOption = title;
          _shipPrice = price;
        });
      },
      child: Card(
        color: _selectedDeliveryOption == title
            ? Colors.orange.shade100
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(child: Text(title)),
              Text('${price.toString()} \$'),
              const SizedBox(width: 8.0),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget hiển thị 1 tùy chọn thanh toán
  Widget _buildPaymentMethod(String method) {
    return InkWell(
      onTap: () {
        setState(() {
          _paymentMethod = method;
        });
      },
      child: Card(
        color:
        _paymentMethod == method ? Colors.orange.shade100 : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(child: Text(method)),
              if (_paymentMethod == method)
                const Icon(Icons.check, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
