
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
import 'package:flutter_restaurant/data/repository/resturant_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';


const categoryHeight = 45.0;
const productHeight = 90.0;

class RestaurantProvider extends ChangeNotifier {
  final RestaurantRepo restaurantRepo;
  RestaurantProvider({@required this.restaurantRepo});

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _categoryIndex = 0;
  int get categoryIndex => _categoryIndex;
  List<Products> _restaurantProductList;
  List<Products> get restaurantProductList => _restaurantProductList;
  List<RestaurantModel> _restaurantList;
  List<RestaurantModel> get restaurantList => _restaurantList;

  Future<void> getRestaurant(BuildContext context, bool reload) async {
    if(_restaurantList == null || reload) {
      ApiResponse apiResponse = await restaurantRepo.getRestaurant();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _restaurantList = [];
        apiResponse.response.data.forEach((restaurant) => _restaurantList.add(RestaurantModel.fromJson(restaurant)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }

  void getRestaurantProductList(BuildContext context, String restaurantID) async {
    _restaurantProductList = null;

    ApiResponse apiResponse = await restaurantRepo.getResProductList(restaurantID);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _restaurantProductList = [];
      apiResponse.response.data.forEach((restaurant) => _restaurantProductList.add(Products.fromJson(restaurant)));

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
    notifyListeners();
  }

  void setCategoryIndex(int index) {
    _categoryIndex = index;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _tabIndex = index;
  }

}
