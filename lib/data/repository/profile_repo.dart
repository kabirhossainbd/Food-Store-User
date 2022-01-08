import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo{
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  ProfileRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getAddressTypeList() async {
    try {
      List<String> addressTypeList = [
        'Select Address type',
        'Home',
        'Office',
        'Other',
      ];
      Response response = Response(requestOptions: RequestOptions(path: ''), data: addressTypeList, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUserInfo() async {
    try {
      final response = await dioClient.get(AppConstants.CUSTOMER_INFO_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> updateProfile(Data proData, String password, PickedFile data, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.UPDATE_PROFILE_URI}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(ResponsiveHelper.isMobilePhone() && data != null) {
      File _file = File(data.path);
      request.files.add(http.MultipartFile('image', _file.readAsBytes().asStream(), _file.lengthSync(), filename: _file.path.split('/').last));
    }else if(ResponsiveHelper.isWeb() && data != null) {
      Uint8List _list = await data.readAsBytes();
      var part = http.MultipartFile('image', data.readAsBytes().asStream(), _list.length, filename: basename(data.path),
          contentType: MediaType('image', 'jpg'));
      request.files.add(part);
    }
    Map<String, String> _fields = Map();

    if(password.isEmpty) {
      _fields.addAll(<String, String>{
        '_method': 'put', 'f_name': proData.fName, 'l_name': proData.lName, 'phone': proData.phone
      });
    }else {
      _fields.addAll(<String, String>{
        '_method': 'put', 'f_name': proData.fName, 'l_name': proData.lName, 'phone': proData.phone, 'password': password
      });
    }
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }


}