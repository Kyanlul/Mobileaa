
class BannerListItemModel {
  BannerListItemModel({this.image, this.id}) {
    image = image ?? "";
    id = id ?? "";
  }

  String? image;
  String? id;
}