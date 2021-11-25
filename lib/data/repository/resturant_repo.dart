import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';

class RestaurantRepo {
  final DioClient dioClient;
  RestaurantRepo({@required this.dioClient});


  Future<ApiResponse> getRestaurant() async {
    try {
      final response = await dioClient.get(AppConstants.RESTAURANT_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getResProductList(String restaurantID) async {
    try {
      final response = await dioClient.get('${AppConstants.RES_PRODUCT_URI}$restaurantID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}