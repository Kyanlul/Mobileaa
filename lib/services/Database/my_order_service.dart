import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/model/order/orders_model.dart';
import 'package:untitled/services/Database/order_service.dart';

class MyOrderService{
  final CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orders');
  Future<List<OrdersModel>> getOrdersByUserId(String userId) async {
    const userID = 'WFgeSNvFH5O5Ok9OgEgL4tWde3P2';
    final ordersRef = FirebaseFirestore.instance.collection('orders');

    final query = ordersRef
        .where('userID', isEqualTo: userID)
        .orderBy('createdAt', descending: true); // 👉 Sắp xếp giảm dần

    try {
      final querySnapshot = await query.get();
      for (var doc in querySnapshot.docs) {
        print('abc\n ${doc.id} => ${doc.data()}');
      }
    } catch (e) {
      print('Error getting documents: $e');
    }

    return OrdersService().getOrdersByUserId(userId);
  }



}