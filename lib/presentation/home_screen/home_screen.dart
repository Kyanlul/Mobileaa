import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/presentation/detail_screen/detail_screen.dart';
import 'package:untitled/presentation/home_screen/models/home_screen_model.dart';
import '../../core/app_export.dart';
import '../../model/product.dart';
import '../../widgets/custom_text_form_field.dart';
import 'package:untitled/widgets/product_card.dart';
import 'provider/home_screen_provider.dart';
import '../../widgets/custom_button_bar.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeScreenProvider(),
      child: const HomeScreen(),
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
  final currencyFormatter =
  NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
  late Future<List<Product>> _recommendedProducts;
  @override
  void initState() {
    super.initState();
    _recommendedProducts = HomeScreenModel().recommendedProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 110.0,
          flexibleSpace: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.h),
              bottomRight: Radius.circular(16.h),
            ),
            child: Container(
              color: appTheme.lightBlue,
            ),
          ),
          title: _buildSearchSection(context),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: 0,
        onChanged: (BottomBarEnum type) {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100.h), // đẩy body xuống dưới AppBar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 Trending + Flash Sale
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h),
                decoration: BoxDecoration(
                  color: appTheme.lightBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.h),
                    bottomRight: Radius.circular(24.h),
                    topLeft: Radius.circular(24.h),
                    topRight: Radius.circular(24.h),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTrendingSection(context),
                    SizedBox(height: 24.h),
                    _buildSaleSection(context),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // 📦 Category Slider
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                // child: _buildCategorySliderSection(context),
              ),

              SizedBox(height: 0.h),

              // 💡 Recommend Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Text(
                  "Recommend For You".toUpperCase(),
                  style: CustomTextStyles.labelLargePrimary.copyWith(
                    fontSize: 14.h,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              //  Recommended Grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16.h),
                  ),
                  padding: EdgeInsets.only(top: 0.h, left: 8.h, right: 8.h, bottom: 8.h),
                  child: _buildRecommendedProductGrid(context),
                ),
              ),


              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }




  Widget _buildSearchSection(BuildContext context) {
    return Expanded(
      child: Selector<HomeScreenProvider, TextEditingController?>(
        selector: (context, provider) => provider.searchController,
        builder: (context, searchController, child) {
          return Column(
            children: [
              CustomTextFormField(
                hintText: "Search",
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
                controller: searchController,
                onTap: () {
                  // Clear search query
                  searchController?.clear();
                },

              ),
              Consumer<HomeScreenProvider>(
                builder: (context, provider, child) {
                  if (provider.filteredSuggestions.isEmpty) {
                    return const SizedBox(); // No suggestions
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.h),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.filteredSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = provider.filteredSuggestions[index];
                        return ListTile(
                          title: Text(suggestion.product_name), // Product name
                          onTap: () {
                            // Navigate to product detail or perform search
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(product: suggestion),
                              ),
                            );
                          },
                        );
                      },
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


  Widget _buildTrendingSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white),
              SizedBox(width: 8.h),
              Text(
                "Trending".toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 240.h,
            child: FutureBuilder<List<Product>>(
              future: HomeScreenModel().getTrendingProductList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products available', style: TextStyle(color: Colors.white)));
                }

                final items = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final product = items[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: Container(
                        width: 220.h,
                        margin: EdgeInsets.only(right: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.h),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.h),
                                topRight: Radius.circular(12.h),
                              ),
                              child: Image.network(
                                product.img_link,
                                height: 100.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.product_name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Text(
                                        currencyFormatter.format(product.discounted_price * 1000),
                                        style: CustomTextStyles.labelLargePrimary
                                            .copyWith(fontSize: 18),
                                      ),

                                      SizedBox(width: 12.h),
                                      Text(
                                        currencyFormatter.format(product.actual_price * 1000),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                          fontSize: 12.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${product.discount_percentage}% OFF',
                                    style: TextStyle(color: Colors.green, fontSize: 12.h),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 14.h, color: Colors.amber),
                                      SizedBox(width: 4.h),
                                      Text('${product.rating} (${product.rating_count})',
                                          style: TextStyle(fontSize: 12.h)),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaleSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white),
              SizedBox(width: 8.h),
              Text(
                "Flash Sale".toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 240.h,
            child: FutureBuilder<List<Product>>(
              future: HomeScreenModel().getSaleProductList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products available', style: TextStyle(color: Colors.white)));
                }

                final items = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final product = items[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: Container(
                        width: 230.h,
                        margin: EdgeInsets.only(right: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.h),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.h),
                                topRight: Radius.circular(12.h),
                              ),
                              child: Image.network(
                                product.img_link,
                                height: 100.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.product_name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Text(
                                        currencyFormatter.format(product.discounted_price * 1000),
                                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 6.h),
                                      Text(
                                        currencyFormatter.format(product.actual_price * 1000),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                          fontSize: 12.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${product.discount_percentage}% OFF',
                                    style: TextStyle(color: Colors.green, fontSize: 12.h),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 14.h, color: Colors.amber),
                                      SizedBox(width: 4.h),
                                      Text('${product.rating} (${product.rating_count})',
                                          style: TextStyle(fontSize: 12.h)),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildCategorySliderSection(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 4.h),
  //     child: Consumer<HomeScreenProvider>(
  //       builder: (context, provider, _) {
  //         final categoryList = provider.homeScreenModel.categoryList;
  //         return CarouselSlider.builder(
  //           options: CarouselOptions(
  //             height: 110.h,
  //             // Responsive height
  //             initialPage: 0,
  //             autoPlay: true,
  //             viewportFraction: 0.2,
  //             scrollDirection: Axis.horizontal,
  //             onPageChanged: (index, _) => provider.changeSliderIndex(index),
  //           ),
  //           itemCount: categoryList.length,
  //           itemBuilder: (context, index, _) {
  //             return CategoryListItemWidget(
  //               categoryListItemObj: categoryList[index],
  //               onTap: () {},
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildRecommendedProductGrid(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0), // giảm padding top xuống 8
      child: FutureBuilder<List<Product>>(
        future: _recommendedProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi khi tải sản phẩm: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Không có sản phẩm liên quan.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            final relatedProducts = snapshot.data!;
            final displayCount = relatedProducts.length >= 6 ? 6 : relatedProducts.length;

            return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: displayCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68, // tăng chút tỉ lệ cho đẹp
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final product = relatedProducts[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Material(
                    color: Colors.grey.shade50,
                    elevation: 4,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      splashColor: Colors.blue.withOpacity(0.15),
                      highlightColor: Colors.blue.withOpacity(0.08),
                      child: ProductCard(product),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );


  }
}
