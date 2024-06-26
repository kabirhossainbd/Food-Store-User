import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/banner_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
import 'package:flutter_restaurant/data/repository/banner_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo bannerRepo;
  BannerProvider({@required this.bannerRepo});

  List<BannerModel> _bannerList;
  List<Products> _productList = [];

  List<BannerModel> get bannerList => _bannerList;
  List<Products> get productList => _productList;


  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Future<void> getBannerList(BuildContext context, bool reload) async {
    if(bannerList == null || reload) {
      ApiResponse apiResponse = await bannerRepo.getBannerList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _bannerList = [];
        apiResponse.response.data.forEach((category) {
          BannerModel bannerModel = BannerModel.fromJson(category);
          if(bannerModel.productId != null) {
            getProductDetails(context, bannerModel.productId.toString());
          }
          _bannerList.add(bannerModel);
        });
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
  }

  void getProductDetails(BuildContext context, String productID) async {
    ApiResponse apiResponse = await bannerRepo.getProductDetails(productID);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _productList.add(Products.fromJson(apiResponse.response.data));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      notifyListeners();
    }
  }
}