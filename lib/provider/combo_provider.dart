import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/combo_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';

class ComboOfferProvider extends ChangeNotifier {
  final ComboRepo setMenuRepo;
  ComboOfferProvider({@required this.setMenuRepo});

  List<Products> _comboList;
  List<Products> get comboList => _comboList;

  Future<void> getSetMenuList(BuildContext context, bool reload) async {
    if(comboList == null || reload) {
      ApiResponse apiResponse = await setMenuRepo.getSetMenuList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _comboList = [];
        apiResponse.response.data.forEach((setMenu) => _comboList.add(Products.fromJson(setMenu)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }
}