import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/base/error_response.dart';
import 'package:flutter_restaurant/data/model/response/delivery_man_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/data/model/response/timeslote_model.dart';
import 'package:flutter_restaurant/data/repository/order_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo orderRepo;
  OrderProvider({@required this.orderRepo});

  List<OrderModel> _runningOrderList;
  List<OrderModel> _historyOrderList;
  List<OrderDetailsModel> _orderDetails;
  int _paymentMethodIndex = 0;
  OrderModel _trackModel;
  ResponseModel _responseModel;
  int _addressIndex = 0;
  bool _isLoading = false;
  bool _showCancelled = false;
  DeliveryManModel _deliveryManModel;
  String _orderType = 'delivery';
  int _branchIndex = 0;
  List<TimeSlotModel> _timeSlots;
  List<TimeSlotModel> _allTimeSlots;
  int _selectDateSlot = 0;
  int _selectTimeSlot = 0;

  List<OrderModel> get runningOrderList => _runningOrderList;
  List<OrderModel> get historyOrderList => _historyOrderList;
  List<OrderDetailsModel> get orderDetails => _orderDetails;
  int get paymentMethodIndex => _paymentMethodIndex;
  OrderModel get trackModel => _trackModel;
  ResponseModel get responseModel => _responseModel;
  int get addressIndex => _addressIndex;
  bool get isLoading => _isLoading;
  bool get showCancelled => _showCancelled;
  DeliveryManModel get deliveryManModel => _deliveryManModel;
  String get orderType => _orderType;
  int get branchIndex => _branchIndex;
  List<TimeSlotModel> get timeSlots => _timeSlots;
  List<TimeSlotModel> get allTimeSlots => _allTimeSlots;
  int get selectDateSlot => _selectDateSlot;
  int get selectTimeSlot => _selectTimeSlot;

  Future<void> getOrderList(BuildContext context) async {
    ApiResponse apiResponse = await orderRepo.getOrderList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _runningOrderList = [];
      _historyOrderList = [];
      apiResponse.response.data.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        if(orderModel.orderStatus == 'pending' || orderModel.orderStatus == 'processing'
            || orderModel.orderStatus == 'out_for_delivery' || orderModel.orderStatus == 'confirmed') {
          _runningOrderList.add(orderModel);
        }else if(orderModel.orderStatus == 'delivered') {
          _historyOrderList.add(orderModel);
        }
      });
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<List<OrderDetailsModel>> getOrderDetails(String orderID, BuildContext context) async {
    _orderDetails = null;
    _isLoading = true;
    _showCancelled = false;

    ApiResponse apiResponse = await orderRepo.getOrderDetails(orderID);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response.data.forEach((orderDetail) => _orderDetails.add(OrderDetailsModel.fromJson(orderDetail)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _orderDetails;
  }

  Future<void> getDeliveryManData(String orderID, BuildContext context) async {
    ApiResponse apiResponse = await orderRepo.getDeliveryManData(orderID);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _deliveryManModel = DeliveryManModel.fromJson(apiResponse.response.data);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }

  Future<ResponseModel> trackOrder(String orderID, OrderModel orderModel, BuildContext context, bool fromTracking) async {
    _trackModel = null;
    _responseModel = null;
    if(!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if(orderModel == null) {
      _isLoading = true;
      ApiResponse apiResponse = await orderRepo.trackOrder(orderID);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _trackModel = OrderModel.fromJson(apiResponse.response.data);
        _responseModel = ResponseModel(true, apiResponse.response.data.toString());
      } else {
        _responseModel = ResponseModel(false, apiResponse.error.errors[0].message);
        ApiChecker.checkApi(context, apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    }else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }
    return _responseModel;
  }

  Future<void> placeOrder(PlaceOrderBody placeOrderBody, Function callback) async {
    _isLoading = true;
    notifyListeners();
    print(placeOrderBody.toJson());
    ApiResponse apiResponse = await orderRepo.placeOrder(placeOrderBody);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      String message = apiResponse.response.data['message'];
      String orderID = apiResponse.response.data['order_id'].toString();
      callback(true, message, orderID, placeOrderBody.deliveryAddressId);
      print('-------- Order placed successfully $orderID ----------');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage, '-1', -1);
    }
    notifyListeners();
  }

  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    notifyListeners();
  }

  void clearPrevData() {
    _addressIndex = 0;
    _branchIndex = 0;
    _paymentMethodIndex = 0;
  }

  void cancelOrder(String orderID, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo.cancelOrder(orderID);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      OrderModel orderModel;
      _runningOrderList.forEach((order) {
        if(order.id.toString() == orderID) {
          orderModel = order;
        }
      });
      _runningOrderList.remove(orderModel);
      _showCancelled = true;
      callback(apiResponse.response.data['message'], true, orderID);
    } else {
      print(apiResponse.error.errors[0].message);
      callback(apiResponse.error.errors[0].message, false, '-1');
    }
    notifyListeners();
  }

  Future<bool> updateCOD(String orderID, BuildContext context, bool isDetailsScreen) async {
    _isLoading = true;
   notifyListeners();
    ApiResponse apiResponse = await orderRepo.updatePaymentMethod(orderID);
    bool _isSuccess;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      if(isDetailsScreen){
        Navigator.pop(context);
      }else{
        Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
      }
      showCustomSnackBar(apiResponse.response.data['message'], context, isError: false);
      _isSuccess = true;
      int orderIndex;
      for(int index = 0; index < _runningOrderList.length; index++) {
        if(_runningOrderList[index].id.toString() == orderID) {
          orderIndex = index;
          break;
        }
      }
      if(orderIndex != null) {
        _runningOrderList[orderIndex].paymentMethod = 'cash_on_delivery';
      }
      _trackModel.paymentMethod = 'cash_on_delivery';
    } else {
      ApiChecker.checkApi(context, apiResponse);
      _isSuccess = false;
    }
    _isLoading = false;
    notifyListeners();
    return _isSuccess;
  }

  void setOrderType(String type, {bool notify = true}) {
    _orderType = type;
    if(notify) {
      notifyListeners();
    }
  }

  void setBranchIndex(int index) {
    _branchIndex = index;
    _addressIndex = -1;
    notifyListeners();
  }

  Future<void> initializeTimeSlot(DateTime restaurantOpeningTime, DateTime restaurantClosingTime) async {
    _timeSlots = [];
    _allTimeSlots = [];
    _selectDateSlot = 0;
    _selectDateSlot = 0;
    int _minutes = 0;
    if(restaurantClosingTime.difference(restaurantOpeningTime).isNegative) {
      _minutes = restaurantOpeningTime.difference(restaurantClosingTime).inMinutes;
    }else {
      _minutes = restaurantClosingTime.difference(restaurantOpeningTime).inMinutes;
    }
    if(_minutes > 30) {
      DateTime _time = restaurantOpeningTime;
      for(;;) {
        if(_time.isBefore(restaurantClosingTime)) {
          DateTime _start = _time;
          DateTime _end = _start.add(Duration(minutes: 30));
          if(_end.isAfter(restaurantClosingTime)) {
            _end = restaurantClosingTime;
          }
          _timeSlots.add(TimeSlotModel(startTime: _time, endTime: _time.add(Duration(minutes: 30))));
          _allTimeSlots.add(TimeSlotModel(startTime: _time, endTime: _time.add(Duration(minutes: 30))));
          _time = _time.add(Duration(minutes: 30));
        }else {
          break;
        }
      }
    }
    validateSlot(_allTimeSlots, 0, notify: false);
  }

  void updateTimeSlot(int index) {
    _selectTimeSlot = index;
    notifyListeners();
  }

  void updateDateSlot(int index) {
    _selectDateSlot = index;
    if(_allTimeSlots != null) {
      validateSlot(_allTimeSlots, index);
    }
    notifyListeners();
  }

  void validateSlot(List<TimeSlotModel> slots, int dateIndex, {bool notify = true}) {
    _timeSlots = [];
    if(dateIndex == 0) {
      DateTime _date = DateTime.now();
      slots.forEach((slot) {
        DateTime _time = slot.endTime;
        DateTime _dateTime = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute, _time.second);
        if (_dateTime.isAfter(DateTime.now())) {
          _timeSlots.add(slot);
        }
      });
    }else {
      _timeSlots.addAll(_allTimeSlots);
    }
    if(notify) {
      notifyListeners();
    }
  }

}