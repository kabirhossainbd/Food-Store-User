import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/slot_widget.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/custom_check_box.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  final double amount;
  final String orderType;
  final List<CartModel> cartList;
  final bool fromCart;
  final String couponCode;
  CheckoutScreen({ @required this.amount, @required this.orderType, @required this.fromCart,
    @required this.cartList, @required this.couponCode});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _noteController = TextEditingController();
  GoogleMapController _mapController;
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;
  List<Branches> _branches = [];
  bool _loading = true;
  Set<Marker> _markers = HashSet<Marker>();
  bool _isLoggedIn;
  List<CartModel> _cartList;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      ConfigModel _configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
      _branches = Provider.of<SplashProvider>(context, listen: false).configModel.branches;
      if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel == null) {
        Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      }
      Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
      DateTime _open = DateFormat('HH:mm').parse(_configModel.restaurantOpenTime);
      DateTime _close = DateFormat('HH:mm').parse(_configModel.restaurantCloseTime);
      if(_close.isBefore(_open)) {
        _close = _close.add(Duration(days: 1));
      }
      Provider.of<OrderProvider>(context, listen: false).initializeTimeSlot(_open, _close);
      Provider.of<OrderProvider>(context, listen: false).clearPrevData();
      _isCashOnDeliveryActive = Provider.of<SplashProvider>(context, listen: false).configModel.cashOnDelivery == 'true';
      _isDigitalPaymentActive = Provider.of<SplashProvider>(context, listen: false).configModel.digitalPayment == 'true';
      _cartList = [];
      widget.fromCart ? _cartList.addAll(Provider.of<CartProvider>(context, listen: false).cartList) : _cartList.addAll(widget.cartList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(context: context, title: getTranslated('checkout', context)),
      body: _isLoggedIn ? Consumer<OrderProvider>(
        builder: (context, order, child) {
          return Consumer<LocationProvider>(
            builder: (context, address, child) {
              return Column(
                children: [

                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Center(
                          child: SizedBox(
                            width: 1170,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              _branches.length > 1 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Text(getTranslated('select_branch', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                ),

                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    physics: BouncingScrollPhysics(),
                                    itemCount: _branches.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                        child: InkWell(
                                          onTap: () {
                                            order.setBranchIndex(index);
                                            _setMarkers(index);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: index == order.branchIndex ? Theme.of(context).primaryColor : ColorResources.getBackgroundColor(context),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Text(_branches[index].name, maxLines: 1, overflow: TextOverflow.ellipsis, style: rubikMedium.copyWith(
                                              color: index == order.branchIndex ? Colors.white : Theme.of(context).textTheme.bodyText1.color,
                                            )),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                Container(
                                  height: ResponsiveHelper.isMobile(context) ? 200 : 300,
                                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorResources.getBackgroundColor(context),
                                  ),
                                  child: Stack(children: [
                                    GoogleMap(
                                      mapType: MapType.normal,
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                          double.parse(_branches[0].latitude),
                                          double.parse(_branches[0].longitude),
                                        ), zoom: ResponsiveHelper.isMobile(context) ? 18 : 8,
                                      ),
                                      zoomControlsEnabled: true,
                                      markers: _markers,
                                      onMapCreated: (GoogleMapController controller) async {
                                        await Geolocator.requestPermission();
                                        _mapController = controller;
                                        _loading = false;
                                        _setMarkers(0);
                                      },
                                    ),
                                    _loading ? Center(child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                    )) : SizedBox(),
                                  ]),
                                ),
                              ]) : SizedBox(),

                              // Address
                              widget.orderType != 'take_away' ? Column(children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                  child: Row(children: [
                                    Text(getTranslated('delivery_address', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    Expanded(child: SizedBox()),
                                    TextButton.icon(
                                      style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL)),
                                      onPressed: () => Navigator.pushNamed(context, Routes.getAddAddressRoute('checkout', 'add', '', '', '0', '0', '', '', 0, 0)),
                                      icon: Icon(Icons.add, color: ColorResources.COLOR_WHITE),
                                      label: Text(getTranslated('add', context), style: rubikRegular.copyWith(color: ColorResources.COLOR_WHITE)),
                                    ),
                                  ]),
                                ),

                                SizedBox(
                                  height: 60,
                                  child: address.addressList != null ? address.addressList.length > 0 ? ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                    itemCount: address.addressList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                        child: InkWell(
                                          onTap: () {
                                            order.setAddressIndex(index);
                                          },
                                          child: Stack(children: [
                                            Container(
                                              height: 60,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                color: index == order.addressIndex ? ColorResources.getBackgroundColor(context) : ColorResources.getBackgroundColor(context),
                                                borderRadius: BorderRadius.circular(10),
                                                border: index == order.addressIndex ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null,
                                              ),
                                              child: Row(children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                  child: Icon(
                                                    address.addressList[index].addressType == 'Home' ? Icons.home_outlined
                                                        : address.addressList[index].addressType == 'Workplace' ? Icons.work_outline : Icons.list_alt_outlined,
                                                    color: index == order.addressIndex ? Theme.of(context).primaryColor
                                                        : Theme.of(context).textTheme.bodyText1.color,
                                                    size: 30,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                                    Text(address.addressList[index].addressType, style: rubikRegular.copyWith(
                                                      fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyBunkerColor(context),
                                                    )),
                                                    Text(address.addressList[index].address, style: rubikRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
                                                  ]),
                                                ),
                                                index == order.addressIndex ? Align(
                                                  alignment: Alignment.topRight,
                                                  child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                                                ) : SizedBox(),
                                              ]),
                                            ),
                                          ]),
                                        ),
                                      );
                                    },
                                  ) : Center(child: Text(getTranslated('no_address_available', context)))
                                      : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                ),
                                SizedBox(height: 20),
                              ]) : SizedBox(),

                              // Time Slot
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                child: Text(getTranslated('preference_time', context), style: rubikMedium),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              SizedBox(
                                height: 50,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                  itemCount: 2,
                                  itemBuilder: (context, index) {
                                    return SlotWidget(
                                      title: index == 0 ? getTranslated('today', context) : getTranslated('tomorrow', context),
                                      isSelected: order.selectDateSlot == index,
                                      onTap: () => order.updateDateSlot(index),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              SizedBox(
                                height: 50,
                                child: order.timeSlots != null ? order.timeSlots.length > 0 ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                  itemCount: order.timeSlots.length,
                                  itemBuilder: (context, index) {
                                    return SlotWidget(
                                      title: (index == 0 && order.selectDateSlot == 0) ? getTranslated('now', context)
                                          : '${DateConverter.dateToTimeOnly(order.timeSlots[index].startTime)} '
                                          '- ${DateConverter.dateToTimeOnly(order.timeSlots[index].endTime)}',
                                      isSelected: order.selectTimeSlot == index,
                                      onTap: () => order.updateTimeSlot(index),
                                    );
                                  },
                                ) : Center(child: Text(getTranslated('no_slot_available', context))) : Center(child: CircularProgressIndicator()),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                child: Text(getTranslated('payment_method', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ),
                              _isCashOnDeliveryActive ? CustomCheckBox(title: getTranslated('cash_on_delivery', context), index: 0) : SizedBox(),
                              _isDigitalPaymentActive ? CustomCheckBox(title: getTranslated('digital_payment', context), index: _isCashOnDeliveryActive ? 1 : 0)
                                  : SizedBox(),

                              Padding(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                child: CustomTextField(
                                  controller: _noteController,
                                  hintText: getTranslated('additional_note', context),
                                  maxLines: 5,
                                  inputType: TextInputType.multiline,
                                  inputAction: TextInputAction.newline,
                                  capitalization: TextCapitalization.sentences,
                                ),
                              ),

                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: 1170,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: !order.isLoading ? Builder(
                      builder: (context) => CustomButton(btnTxt: getTranslated('confirm_order', context), onTap: () {
                        bool _isAvailable = true;
                        DateTime _scheduleDate = DateTime.now();
                        if(order.timeSlots == null || order.timeSlots.length == 0) {
                          _isAvailable = false;
                        }else {
                          DateTime _date = order.selectDateSlot == 0 ? DateTime.now() : DateTime.now().add(Duration(days: 1));
                          DateTime _time = order.timeSlots[order.selectTimeSlot].startTime;
                          _scheduleDate = DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
                          for (CartModel cart in _cartList) {
                            if (!DateConverter.isAvailable(
                              cart.product.availableTimeStarts, cart.product.availableTimeEnds, context, time: _scheduleDate,
                            )) {
                              _isAvailable = false;
                              break;
                            }
                          }
                        }

                        if(widget.amount < Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                            'Minimum order amount is ${Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue}',
                          ), backgroundColor: Theme.of(context).primaryColor));
                        }else if(widget.orderType != 'take_away' && (address.addressList == null || address.addressList.length == 0 || order.addressIndex < 0)) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(getTranslated('select_an_address', context)),
                            backgroundColor: Theme.of(context).primaryColor,
                          ));
                        }else if (order.timeSlots == null || order.timeSlots.length == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('select_a_time', context)), backgroundColor: Theme.of(context).primaryColor));
                        }else if (!_isAvailable) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(getTranslated('one_or_more_products_are_not_available_for_this_selected_time', context)),
                            backgroundColor: Theme.of(context).primaryColor,
                          ));
                        }else {
                          List<Cart> carts = [];
                          for (int index = 0; index < _cartList.length; index++) {
                            CartModel cart = _cartList[index];
                            List<int> _addOnIdList = [];
                            List<int> _addOnQtyList = [];
                            cart.addOnIds.forEach((addOn) {
                              _addOnIdList.add(addOn.id);
                              _addOnQtyList.add(addOn.quantity);
                            });
                            carts.add(Cart(
                              cart.product.id, cart.product.companyId, cart.product.restaurantId,cart.discountedPrice.toString(), '', cart.variation,
                              cart.discountAmount, cart.quantity, cart.taxAmount, _addOnIdList, _addOnQtyList,
                            ));
                          }

                          order.placeOrder(
                            PlaceOrderBody(
                                cart: carts,
                                couponDiscountAmount: Provider.of<CouponProvider>(context, listen: false).discount,
                                couponDiscountTitle: widget.couponCode.isNotEmpty ? widget.couponCode : null,
                                deliveryAddressId: widget.orderType != 'take_away' ? Provider.of<LocationProvider>(context, listen: false)
                                    .addressList[order.addressIndex].id : 0,
                                orderAmount: widget.amount, orderNote: _noteController.text ?? '', orderType: widget.orderType,
                                paymentMethod: _isCashOnDeliveryActive ? order.paymentMethodIndex == 0 ? 'cash_on_delivery' : null : null,
                                couponCode: widget.couponCode.isNotEmpty ? widget.couponCode : null,
                                branchId: _branches[order.branchIndex].id, deliveryDate: DateFormat('yyyy-MM-dd').format(_scheduleDate),
                                deliveryTime: (order.selectTimeSlot == 0 && order.selectDateSlot == 0) ? 'now' : DateFormat('HH:mm').format(_scheduleDate),
                                companyId: carts[order.branchIndex].companyId,
                                restaurantId: carts[order.branchIndex].restaurantId
                            ), _callback,
                          );
                        }
                      }),
                    ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                  ),

                ],
              );
            },
          );
        },
      ) : NotLoggedInScreen(isFav: false),
    );
  }

  void _callback(bool isSuccess, String message, String orderID, int addressID) async {
    if(isSuccess) {
      if(widget.fromCart) {
        Provider.of<CartProvider>(context, listen: false).clearCartList();
      }
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
      if(_isCashOnDeliveryActive && Provider.of<OrderProvider>(context, listen: false).paymentMethodIndex == 0) {
        Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/$orderID/success');
      }else {
        if(ResponsiveHelper.isWeb()) {
          String hostname = html.window.location.hostname;
          String selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?order_id=$orderID&&customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id}'
              '&&callback=http://$hostname${Routes.ORDER_SUCCESS_SCREEN}/$orderID';
          html.window.open(selectedUrl,"_self");
        } else{
          Navigator.pushReplacementNamed(context, Routes.getPaymentRoute('checkout', orderID, Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id));
        }
      }
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Theme.of(context).primaryColor));
    }
  }

  void _setMarkers(int selectedIndex) async {
    Uint8List activeImageData = await convertAssetToUnit8List(Images.restaurant_marker, width: ResponsiveHelper.isMobilePhone() ? 70 : 20);
    Uint8List inactiveImageData = await convertAssetToUnit8List(Images.unselected_restaurant_marker, width: ResponsiveHelper.isMobilePhone() ? 70 : 20);

    // Marker
    _markers = HashSet<Marker>();
    for(int index=0; index<_branches.length; index++) {
      _markers.add(Marker(
        markerId: MarkerId('branch_$index'),
        position: LatLng(double.parse(_branches[index].latitude), double.parse(_branches[index].longitude)),
        infoWindow: InfoWindow(title: _branches[index].name, snippet: _branches[index].address),
        icon: BitmapDescriptor.fromBytes(selectedIndex == index ? activeImageData : inactiveImageData,),
      ));
    }

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
      double.parse(_branches[selectedIndex].latitude),
      double.parse(_branches[selectedIndex].longitude),
    ), zoom: ResponsiveHelper.isMobile(context) ? 18 : 8)));

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png)).buffer.asUint8List();
  }
}
