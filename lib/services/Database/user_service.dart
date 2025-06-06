import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/address_model.dart';
import '../../model/user.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //create
  Future<void> createUserProfile(CustomUser user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      print('User profile created successfully!');
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }
  // read
  Future<CustomUser> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        print('User profile not found.');
        return CustomUser();
      }

      final data = doc.data()!;
      AddressModel? address;

      if (data['addressId'] != null) {
        final addressDoc = await _firestore
            .collection('addaddress')
            .doc(data['addressId'])
            .get();
        if (addressDoc.exists) {
          final addressData = addressDoc.data()!;
          final addressId = addressDoc.id;
          address = AddressModel.fromMap(addressId, addressData);
          print(address.province);
        }
      }

      return CustomUser.fromMap({
        ...data,
        'address': address?.toMap(),
      });
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }


  Future<void> updateAddressId(String uid, String addressId) async {
    try {
      await _firestore.collection('users').doc(uid).update({'addressId': addressId});
    } catch (e) {
      throw Exception('Failed to update addressId: $e');
    }
  }

  // update
  Future<void> updateUserProfile(String uid, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('users').doc(uid).update(updatedData);
      print('User profile updated successfully!');
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }

  }
  Future<void> updateUserName(String uid, String name) async {
    await updateUserProfile(uid, {'name': name});
  }

  Future<void> updateUserPhone(String uid, String phone) async {
    await updateUserProfile(uid, {'phone': phone});
  }


}
