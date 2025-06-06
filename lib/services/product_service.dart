//load product from local data
// import 'dart:convert';
// import 'package:flutter/services.dart';
//
// import '../model/product.dart';
//
// class ProductService {
//   Future<List<Product>> loadProductsFromJson() async {
//     try {
//       final String response = await rootBundle.loadString('lib/assets/data .json');
//       final List<dynamic> data = jsonDecode(response);
//
//       return data.map((json) => Product.fromJson(json)).toList();
//     } catch (e) {
//       throw Exception('Failed to load products: $e');
//     }
//   }
// }
