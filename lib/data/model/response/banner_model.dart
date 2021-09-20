class BannerModel {
  int _id;
  String _title;
  String _image;
  int _productId;
  String _createdAt;
  String _updatedAt;
  int _categoryId;
  int _restaurantId;

  BannerModel(
      {int id,
        String title,
        String image,
        int productId,
        int status,
        String createdAt,
        String updatedAt,
        int categoryId,
      int restaurantId}) {
    this._id = id;
    this._title = title;
    this._image = image;
    this._productId = productId;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._categoryId = categoryId;
    this._restaurantId = restaurantId;
  }

  int get id => _id;
  String get title => _title;
  String get image => _image;
  int get productId => _productId;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get categoryId => _categoryId;
  int get restaurantId => _restaurantId;

  BannerModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
    _productId = json['product_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _categoryId = json['category_id'];
    _restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['image'] = this._image;
    data['product_id'] = this._productId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['category_id'] = this._categoryId;
    data['restaurant_id'] = this._restaurantId;
    return data;
  }
}
