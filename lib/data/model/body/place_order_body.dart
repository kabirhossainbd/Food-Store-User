import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';

class PlaceOrderBody {
  List<Cart> _cart;
  double _couponDiscountAmount;
  String _couponDiscountTitle;
  double _orderAmount;
  String _orderType;
  int _deliveryAddressId;
  String _paymentMethod;
  String _orderNote;
  String _couponCode;
  String _deliveryTime;
  String _deliveryDate;
  int _branchId;
  int _companyId;
  int _restaurantId;

  PlaceOrderBody(
      {@required List<Cart> cart,
        @required double couponDiscountAmount,
        @required String couponDiscountTitle,
        @required String couponCode,
        @required double orderAmount,
        @required int deliveryAddressId,
        @required String orderType,
        @required String paymentMethod,
        @required int branchId,
        @required String deliveryTime,
        @required String deliveryDate,
        @required String orderNote,
        @required int companyId,
        @required int restaurantId,}) {
    this._cart = cart;
    this._couponDiscountAmount = couponDiscountAmount;
    this._couponDiscountTitle = couponDiscountTitle;
    this._orderAmount = orderAmount;
    this._orderType = orderType;
    this._deliveryAddressId = deliveryAddressId;
    this._paymentMethod = paymentMethod;
    this._orderNote = orderNote;
    this._couponCode = couponCode;
    this._deliveryTime = deliveryTime;
    this._deliveryDate = deliveryDate;
    this._branchId = branchId;
    this._companyId = companyId;
    this._restaurantId = restaurantId;
  }

  List<Cart> get cart => _cart;
  double get couponDiscountAmount => _couponDiscountAmount;
  String get couponDiscountTitle => _couponDiscountTitle;
  double get orderAmount => _orderAmount;
  String get orderType => _orderType;
  int get deliveryAddressId => _deliveryAddressId;
  String get paymentMethod => _paymentMethod;
  String get orderNote => _orderNote;
  String get couponCode => _couponCode;
  String get deliveryTime => _deliveryTime;
  String get deliveryDate => _deliveryDate;
  int get branchId => _branchId;
  int get companyId => _companyId;
  int get restaurantId => _restaurantId;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart.add(new Cart.fromJson(v));
      });
    }
    _couponDiscountAmount = json['coupon_discount_amount'];
    _couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = json['order_amount'];
    _orderType = json['order_type'];
    _deliveryAddressId = json['delivery_address_id'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _deliveryTime = json['delivery_time'];
    _deliveryDate = json['delivery_date'];
    _branchId = json['branch_id'];
    _companyId = json['company_id'];
    _restaurantId = json['restaurant_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._cart != null) {
      data['cart'] = this._cart.map((v) => v.toJson()).toList();
    }
    data['coupon_discount_amount'] = this._couponDiscountAmount;
    data['coupon_discount_title'] = this._couponDiscountTitle;
    data['order_amount'] = this._orderAmount;
    data['order_type'] = this._orderType;
    data['delivery_address_id'] = this._deliveryAddressId;
    data['payment_method'] = this._paymentMethod;
    data['order_note'] = this._orderNote;
    data['coupon_code'] = this._couponCode;
    data['delivery_time'] = this._deliveryTime;
    data['delivery_date'] = this._deliveryDate;
    data['branch_id'] = this._branchId;
    data['company_id'] = this._companyId;
    data['restaurant_id'] = this._restaurantId;
    return data;
  }
}

class Cart {
  int _productId;
  int _companyId;
  int _restaurantId;
  String _price;
  String _variant;
  List<Variations> _variation;
  double _discountAmount;
  int _quantity;
  double _taxAmount;
  List<int> _addOnIds;
  List<int> _addOnQtys;

  Cart(
      int productId,
      int companyId,
      int restaurantId,
      String price,
      String variant,
      List<Variations> variation,
      double discountAmount,
      int quantity,
      double taxAmount,
      List<int> addOnIds,
      List<int> addOnQtys) {
    this._productId = productId;
    this._companyId = companyId;
    this._restaurantId = restaurantId;
    this._price = price;
    this._variant = variant;
    this._variation = variation;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._addOnIds = addOnIds;
    this._addOnQtys = addOnQtys;
  }

  int get productId => _productId;
  int get companyId => _companyId;
  int get restaurantId => _restaurantId;
  String get price => _price;
  String get variant => _variant;
  List<Variations> get variation => _variation;
  double get discountAmount => _discountAmount;
  int get quantity => _quantity;
  double get taxAmount => _taxAmount;
  List<int> get addOnIds => _addOnIds;
  List<int> get addOnQtys => _addOnQtys;

  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _companyId = json['company_id'];
    _restaurantId = json['restaurant_id'];
    _price = json['price'];
    _variant = json['variant'];
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variations.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'];
    _addOnIds = json['add_on_ids'].cast<int>();
    _addOnQtys = json['add_on_qtys'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this._productId;
    data['company_id'] = this._companyId;
    data['restaurant_id'] = this._restaurantId;
    data['price'] = this._price;
    data['variant'] = this._variant;
    if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['add_on_ids'] = this._addOnIds;
    data['add_on_qtys'] = this._addOnQtys;
    return data;
  }
}
