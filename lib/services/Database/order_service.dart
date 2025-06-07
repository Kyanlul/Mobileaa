import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/order/orders_model.dart';
import '../vnpay_flutter.dart';
import '../../core/vnpay_config.dart';

class OrdersService {
  final CollectionReference ordersCollection =
  FirebaseFirestore.instance.collection('orders');

  /// Tạo URL thanh toán VNPAY cho đơn hàng
  /// [orderId]: mã đơn hàng (phải unique)
  /// [amount]: tổng tiền (đơn vị VNĐ)
  /// [expireDate]: thời hạn thanh toán (DateTime)
  /// [ipAddress]: IP của người dùng (mặc định '0.0.0.0')

  String getNewOrderId() {
    final docRef = ordersCollection.doc();
    return docRef.id;
  }

  /// Ghi dữ liệu order đã hoàn chỉnh lên Firestore, dùng sẵn order.orderId
  Future<void> saveOrder(OrdersModel order) async {
    final docRef = ordersCollection.doc(order.orderId);
    await docRef.set(order.toJson());
  }

  String generateVnPayUrl({
    required String orderId,
    required double amount,
    required DateTime expireDate,
    String ipAddress = '192.168.10.10',
  }) {
    return VNPAYFlutter.instance.generatePaymentUrl(
      version: '2.0.1',
      tmnCode: VNPayConfig.tmnCode,
      txnRef: orderId,
      amount: amount,
      returnUrl: VNPayConfig.returnUrl,
      ipAdress: ipAddress,
      vnpayHashKey: VNPayConfig.hashSecret,
      vnpayExpireDate: expireDate,
    );
  }



  Future<void> createOrder(OrdersModel order) async {
    try {

      final docRef = ordersCollection.doc();
      final orderWithId = OrdersModel(
        orderId: docRef.id,
        userId: order.userId,
        productItems: order.productItems,
        totalPrice: order.totalPrice,
        status: order.status,
        createdAt: order.createdAt,
      );

      // Lưu vào Firestore
      await docRef.set(orderWithId.toJson());
      print("Order created with ID: ${docRef.id}");
    } catch (e) {
      print("Error creating order: $e");
      rethrow;
    }
  }


  Future<OrdersModel?> getOrderById(String orderId) async {
    try {
      final snapshot = await ordersCollection.doc(orderId).get();
      if (snapshot.exists) {
        return OrdersModel.fromJson(snapshot.id, snapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OrdersModel>> getOrdersByUserId(String userId) async {
    try {
      final snapshot = await ordersCollection.where('userId', isEqualTo: userId).get();
      return snapshot.docs.map((doc) {
        return OrdersModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<void> updateOrder(String orderId, Map<String, dynamic> updates) async {
    try {
      await ordersCollection.doc(orderId).update(updates);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await ordersCollection.doc(orderId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
