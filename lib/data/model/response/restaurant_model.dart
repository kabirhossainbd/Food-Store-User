class RestaurantModel {
  int id;
  String name;
  String companyId;
  String logo;
  String address;
  int status;
  String coverImage;
  String createdAt;
  String updatedAt;

  RestaurantModel(
      {this.id,
        this.name,
        this.companyId,
        this.logo,
        this.address,
        this.status,
        this.coverImage,
        this.createdAt,
        this.updatedAt});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyId = json['company_id'];
    logo = json['logo'];
    address = json['address'];
    status = json['status'];
    coverImage = json['cover_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['company_id'] = this.companyId;
    data['logo'] = this.logo;
    data['address'] = this.address;
    data['status'] = this.status;
    data['cover_image'] = this.coverImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
