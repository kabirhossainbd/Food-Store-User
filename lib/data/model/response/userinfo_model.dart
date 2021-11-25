class UserInfoModel {
  Data data;

  UserInfoModel({this.data});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String fName;
  String lName;
  String email;
  String image;
  String phone;
  String cmFirebaseToken;
  int point;
  String referId;
  String referById;
  int useCoupon;

  Data(
      {this.id,
        this.fName,
        this.lName,
        this.email,
        this.image,
        this.phone,
        this.cmFirebaseToken,
        this.point,
        this.referId,
        this.referById,
        this.useCoupon});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    email = json['email'];
    image = json['image'];
    phone = json['phone'];
    cmFirebaseToken = json['cm_firebase_token'];
    point = json['point'];
    referId = json['refer_id'];
    referById = json['refer_by_id'];
    useCoupon = json['use_coupon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['email'] = this.email;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['cm_firebase_token'] = this.cmFirebaseToken;
    data['point'] = this.point;
    data['refer_id'] = this.referId;
    data['refer_by_id'] = this.referById;
    data['use_coupon'] = this.useCoupon;
    return data;
  }
}
