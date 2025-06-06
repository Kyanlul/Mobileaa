import 'dart:async';

import 'package:untitled/model/product.dart';
import '../../../services/Database/product_service.dart';
import 'banner_list_item_model.dart';
import 'category_list_item_model.dart';

class HomeScreenModel {
  final ProductService productService = ProductService();

  Future<List<Product>> getAllProductFirestore() async {
    final productList = await productService.fetchAllProducts();
    return productList;
  }

  List<BannerListItemModel> bannerList = [
    BannerListItemModel(image: "lib/assets/images/banner1.png"),
    BannerListItemModel(image: "lib/assets/images/banner2.png"),
  ];

  Future<List<Product>> getTrendingProductList() async {
    return productService.getTrendingProducts();
  }

  Future<List<Product>> getSaleProductList() async {
    return productService.getSaleProductList();
  }

  Future<List<Product>> recommendedProductList() async {
    return productService.getRecommendProducts();
  }

  List<CategoryListItemModel> categoryList = [
    CategoryListItemModel(
        name: "Computer & Accessories",
        imageUrl: "lib/assets/icons/computer_and_accessories.svg"),
    CategoryListItemModel(
        name: "Home & Kitchen",
        imageUrl: "lib/assets/icons/home_and_kitchen.svg"),
    CategoryListItemModel(
        name: "Fashion & Apparel",
        imageUrl: "lib/assets/icons/fashion_and_apparel.svg"),
    CategoryListItemModel(
        name: "Groceries", imageUrl: "lib/assets/icons/groceries.svg"),
    CategoryListItemModel(name: "Toys", imageUrl: "lib/assets/icons/toys.svg"),
    CategoryListItemModel(
        name: "Books & Media",
        imageUrl: "lib/assets/icons/books_and_media.svg"),
  ];
}
