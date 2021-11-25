class BannerModel {
  int id;
  String title;
  String image;
  int productId;
  int status;
  String createdAt;
  String updatedAt;
  int categoryId;
  int restaurantId;

  BannerModel(
      {this.id,
        this.title,
        this.image,
        this.productId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.categoryId,
        this.restaurantId});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    productId = json['product_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryId = json['category_id'];
    restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['product_id'] = this.productId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['category_id'] = this.categoryId;
    data['restaurant_id'] = this.restaurantId;
    return data;
  }
}
