import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/data/repository/profile_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo profileRepo;

  ProfileProvider({@required this.profileRepo});

  Data _userInfoModel;
  PickedFile _pickedFile;


  Data get userInfoModel => _userInfoModel;
  PickedFile get pickedFile => _pickedFile;

  Future<ResponseModel> getUserInfo(BuildContext context) async {
    _pickedFile = null;
    ResponseModel _responseModel;
    ApiResponse apiResponse = await profileRepo.getUserInfo();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response.data).data;
      _responseModel = ResponseModel(true, 'successful');
    } else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      _responseModel = ResponseModel(false, _errorMessage);
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _responseModel;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> updateUserInfo(Data data, String password, String token) async {
    _isLoading = true;
    notifyListeners();
    ResponseModel _responseModel;
    http.StreamedResponse response = await profileRepo.updateProfile(data, password, _pickedFile, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _userInfoModel = data;
      _responseModel = ResponseModel(true, message);
      _pickedFile = null;
      print(message);
    } else {
      _responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    notifyListeners();
    return _responseModel;
  }

  void pickImage() async {
    _pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    notifyListeners();
  }

}
