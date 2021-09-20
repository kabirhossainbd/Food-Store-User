import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/combo_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';

class ComboOfferProvider extends ChangeNotifier {
  final ComboRepo setMenuRepo;
  ComboOfferProvider({@required this.setMenuRepo});

  List<Product> _setMenuList;
  List<Product> get setMenuList => _setMenuList;

  Future<void> getSetMenuList(BuildContext context, bool reload) async {
    if(setMenuList == null || reload) {
      ApiResponse apiResponse = await setMenuRepo.getSetMenuList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _setMenuList = [];
        apiResponse.response.data.forEach((setMenu) => _setMenuList.add(Product.fromJson(setMenu)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }
}