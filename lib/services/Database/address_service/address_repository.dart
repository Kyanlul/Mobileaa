import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/model/address_model.dart';
import 'package:untitled/services/Database/user_service.dart';

class AddressRepository {
  final CollectionReference _addressCollection =
      FirebaseFirestore.instance.collection('addresses');

  /// Tạo địa chỉ mới (Firestore tự tạo ID)
  Future<String> createAddress(AddressModel address) async {
    try {
      final docRef = await _addressCollection.add(address.toMap());
      return docRef.id; // Trả về ID của tài liệu vừa được tạo
    } catch (e) {
      throw Exception('Failed to create address: $e');
    }
  }

  /// Lấy địa chỉ theo ID
  Future<AddressModel?> getAddressById(String id) async {
    try {
      final docSnapshot = await _addressCollection.doc(id).get();
      if (docSnapshot.exists) {
        return AddressModel.fromMap(
            docSnapshot.id, docSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch address: $e');
    }
  }
  Future<void> createAddressAndLinkToUser(AddressModel address, String userId) async {
    // Tạo địa chỉ mới và lấy ID của địa chỉ
    String addressId = await AddressRepository().createAddress(address);
    addressId;

    // Cập nhật addressId vào thông tin người dùng
    await ProfileService().updateAddressId(userId, addressId);
  }


  /// Cập nhật địa chỉ
  Future<void> updateAddress(String id, AddressModel updatedAddress) async {
    try {
      await _addressCollection.doc(id).update(updatedAddress.toMap());
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  /// Xóa địa chỉ
  Future<void> deleteAddress(String id) async {
    try {
      await _addressCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  /// Lấy tất cả địa chỉ
  Future<List<AddressModel>> getAllAddresses() async {
    try {
      final querySnapshot = await _addressCollection.get();
      return querySnapshot.docs
          .map((doc) =>
              AddressModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch addresses: $e');
    }
  }
}
