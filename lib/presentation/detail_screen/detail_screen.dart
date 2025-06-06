import 'package:flutter/material.dart';
import 'package:untitled/core/app_export.dart';
import 'package:untitled/model/product.dart';
import 'package:untitled/services/Database/cart_service.dart';
import 'package:untitled/services/Database/product_service.dart';
import 'package:untitled/widgets/custom_elevated_button.dart';
import 'package:untitled/widgets/custom_rating_bar.dart';
import 'package:untitled/widgets/product_card.dart';
import '../../model/reviews.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;


  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isExpandedDetails = false;
  bool isExpandedReviews = false;

  late Future<List<Product>> futureRelatedProducts;
  // late Future<List<Product>> jsonProduct;
  late Future<List<Product>> firestoreProductList;
  late CartService cartService;
  var userId = '';


  @override
  void initState() {
    super.initState();


    // jsonProduct = ProductService().loadProductsFromJson();
    firestoreProductList = ProductService().fetchAllProducts();
    userId = AuthService().getCurrentUser()!.uid;
    // userId = 'NOlPPPEdwEhXEfi8IBGLHFOgl9k1';
    cartService = CartService();
    print(widget.product.reviews.length);
    print(widget.product.product_id);

    for (var review in widget.product.reviews) {
      print('Reviewer: ${review.user_name}');
      print('Comment: ${review.review_title}');
      print('Rating: ${review.review_content}');
    }


  }

  Future<List<Product>> fetchRelatedProducts() async {
    final products = await firestoreProductList;
    return products.take(20).toList();
  }

  int quantity = 1;

  void increment() {
    setState(() {
      quantity++;
    });
  }

  void decrement() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightCodeColors().lightBlue,
        elevation: 1,
        leading: IconButton(

          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.homeScreen)
        ),

        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, AppRoutes.cartScreen);

          }, icon: const Icon(Icons.shopping_cart, color: Colors.orange))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
                aspectRatio: 1,
                child: CustomImageView(
                  imagePath: widget.product.img_link,
                )),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA), // Nền nhẹ thay vì màu xanh đậm
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  // Giá đã giảm
                  Text(
                    '\$${widget.product.discounted_price}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF7043), // xanh lá đậm
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Giá gốc
                  Text(
                    '\$${widget.product.actual_price}',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const Spacer(),

                  // % giảm giá
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7043), // Cam đậm
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '-${widget.product.discount_percentage}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Product Title and Rating
                  Text('${widget.product.product_name}]',
                      style: CustomTextStyles.titleProductBlack),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${widget.product.rating}',
                        style:
                            TextStyle(fontSize: 16, color: appTheme.orangeA200),
                      ),
                      CustomRatingBar(
                        ignoreGestures: true,
                        initialRating: widget.product.rating,
                        color: appTheme.orangeA200,
                      ),
                      const SizedBox(width: 6),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'In Stock',
                        style: CustomTextStyles.bodyMediumLightBlue
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 44.h,
                        decoration: BoxDecoration(
                            color: LightCodeColors().gray200,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Quantity',
                            style: CustomTextStyles.bodySmallBlack900.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Spacer(),
                          Center(
                            child: Container(
                              height: 28.h,
                              decoration: BoxDecoration(
                                  color: LightCodeColors().gray5001,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,

                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: decrement,
                                      icon: const Icon(Icons.remove)),
                                  Text('$quantity'),
                                  IconButton(
                                      onPressed: increment,
                                      icon: const Icon(Icons.add))
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          )
                        ]),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          print(userId);
                          cartService.addToCart(widget.product, userId, quantity);

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA726),
                          minimumSize: Size(3.h, 60.h),
                        ),
                        child: const Text(
                          'Add to cart',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Expanded(
                          child: CustomElevatedButton(
                            onPressed: () {},
                            text: 'Buy now',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Product Details
                  InkWell(
                    onTap: () {
                      setState(() {
                        isExpandedDetails = !isExpandedDetails;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey, width: 1),
                          bottom: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Product Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                isExpandedDetails
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.product.about_product,
                            maxLines: isExpandedDetails ? null : 3,
                            overflow: isExpandedDetails ? null : TextOverflow.ellipsis,
                          ),
                          if (!isExpandedDetails)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isExpandedDetails = true;
                                });
                              },
                              child: Text(
                                'More',
                                style: CustomTextStyles.titleSmallPrimary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),


                  // Customer Reviews
                  Container(
                      padding: const EdgeInsets.all(2), child: Customer_review()),

                  // Related Products
                  const Text(
                    'Related Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRelatedProductItem(widget.product)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column Customer_review() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Customer Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isExpandedReviews = !isExpandedReviews;
                });
              },
              child: Text(
                isExpandedReviews ? 'Show Less' : 'See All',
                style: const TextStyle(color: Color(0xFFFA993A)),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '${widget.product.rating}',
              style: TextStyle(fontSize: 16, color: appTheme.orangeA200),
            ),
            const SizedBox(width: 4),
            CustomRatingBar(
              ignoreGestures: true,
              initialRating: widget.product.rating,
              color: appTheme.orangeA200,
            ),
            Text(
              '${widget.product.rating_count}',
              style: TextStyle(fontSize: 16, color: appTheme.orangeA200),
            ),
          ],
        ),
        Column(
          children: List.generate(

            isExpandedReviews ? (widget.product.reviews.length ) : (widget.product.reviews.isNotEmpty ? 1 : 0 ) ,
            (index) {
              final review = widget.product.reviews[index];
              return _buildReviewItem(review);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(Review review) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange.shade300,
                child: Text(
                  review.user_name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                review.user_name,
                style: CustomTextStyles.titleProductBlack.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.review_title,
            style: CustomTextStyles.titleProductBlack.copyWith(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            review.review_content,
            style: CustomTextStyles.bodyMediumGray200.copyWith(
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildRelatedProductItem(Product product) {
    return FutureBuilder<List<Product>>(
      future: fetchRelatedProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No related products found.'));
        } else {
          final relatedProducts = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) {
              final product = relatedProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ),
                  );
                },
                child: ProductCard(product),
              );
            },
          );
        }
      },
    );
  }
}
