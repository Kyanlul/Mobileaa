class SellerModel {
  final String seller_id;
  String? store_name;
  String? store_description;
  String? logo_img_link;

  SellerModel(
      {required this.seller_id,
      this.store_name,
      this.store_description,
      this.logo_img_link});
}
