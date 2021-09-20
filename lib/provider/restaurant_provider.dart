
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
import 'package:flutter_restaurant/data/repository/resturant_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:universal_html/js.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantRepo restaurantRepo;

  RestaurantProvider({@required this.restaurantRepo});


  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _categoryIndex = 0;
  int get categoryIndex => _categoryIndex;
  List<Product> _restaurantProductList;
  List<Product> get restaurantProductList => _restaurantProductList;
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
    notifyListeners();
    ApiResponse apiResponse = await restaurantRepo.getResProductList(restaurantID);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _restaurantProductList = [];
      apiResponse.response.data.forEach((restaurant) => _restaurantProductList.add(Product.fromJson(restaurant)));
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }

  void setCategoryIndex(int index) {
    _categoryIndex = index;
    notifyListeners();
  }

}
