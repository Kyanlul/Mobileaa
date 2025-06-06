import 'package:flutter/cupertino.dart';
import 'package:untitled/model/product.dart';
import 'package:untitled/services/Database/product_service.dart';
import '../models/home_screen_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();

  HomeScreenModel homeScreenModel = HomeScreenModel();

  Future<List<Product>> getAllProductFirestore() async {
    final productList = await ProductService().fetchAllProducts();
    print(productList);
    return productList;
  }



  List<Product> filteredSuggestions = [];

  void filterSuggestions(String query) async{
    if (query.isEmpty) {
      filteredSuggestions = [];
      print('empty');
    } else {
      List<Product> allProducts = await getAllProductFirestore();
      print(allProducts);
      filteredSuggestions = allProducts
          .where((product) =>
              product.product_name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  int sliderIndex = 0;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void changeSliderIndex(int value) {
    sliderIndex = value;
    notifyListeners();
  }
}
