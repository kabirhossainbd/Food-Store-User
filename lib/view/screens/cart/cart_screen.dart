import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/animated_dialog.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_dialog.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/delivery_option_button.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
 final bool isHome;
 CartScreen({@required this.isHome});

 final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
 final TextEditingController _couponController = TextEditingController();

 @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false).setOrderType('delivery', notify: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(context: context, title: getTranslated('my_cart', context), isBackButtonExist: isHome ? false : true),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          double deliveryCharge = 0;
          Provider.of<OrderProvider>(context).orderType == 'delivery'
               ? deliveryCharge = double.parse(Provider.of<SplashProvider>(context).configModel.deliveryCharge) : deliveryCharge = 0;
          List<List<AddOns>> _addOnsList = [];
          List<bool> _availableList = [];
          double _itemPrice = 0;
          double _discount = 0;
          double _tax = 0;
          double _addOns = 0;
          cart.cartList.forEach((cartModel) {

            List<AddOns> _addOnList = [];
            cartModel.addOnIds.forEach((addOnId) {
              for(AddOns addOns in cartModel.product.addOns) {
                if(addOns.id == addOnId.id) {
                  _addOnList.add(addOns);
                  break;
                }
              }
            });
            _addOnsList.add(_addOnList);

            _availableList.add(DateConverter.isAvailable(cartModel.product.availableTimeStarts, cartModel.product.availableTimeEnds, context));

            for(int index=0; index<_addOnList.length; index++) {
              _addOns = _addOns + (_addOnList[index].price * cartModel.addOnIds[index].quantity);
            }
            _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
            _discount = _discount + (cartModel.discountAmount * cartModel.quantity);
            _tax = _tax + (cartModel.taxAmount * cartModel.quantity);
          });
          double _subTotal = _itemPrice + _tax + _addOns;
          double _total = _subTotal - _discount - Provider.of<CouponProvider>(context, listen: false).discount + deliveryCharge;

          double _orderAmount = _itemPrice + _addOns;

          return cart.cartList.length > 0 ? Column(
            children: [

              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL), physics: BouncingScrollPhysics(),
                    child: Center(
                      child: SizedBox(
                        width: 1170,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          // Product
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cart.cartList.length,
                            itemBuilder: (context, index) {
                              return CartProductWidget(cart: cart.cartList[index], cartIndex: index, addOns: _addOnsList[index], isAvailable: _availableList[index]);
                            },
                          ),

                          // Coupon
                          Consumer<CouponProvider>(
                            builder: (context, coupon, child) {
                              return Row(children: [
                                Expanded(
                                  child: TextField(
                                    controller: _couponController,
                                    style: rubikRegular,
                                    decoration: InputDecoration(
                                        hintText: getTranslated('enter_promo_code', context),
                                        hintStyle: rubikRegular.copyWith(color: ColorResources.getHintColor(context)),
                                        isDense: true,
                                        filled: true,
                                        enabled: coupon.discount == 0,
                                        fillColor: ColorResources.getBackgroundColor(context),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 10 : 0),
                                            right: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 0 : 10),
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {

                                    if(!_isLoggedIn){
                                      showDialog(context: context, builder: (context) => NotLoggedInScreen(isFav: true,));
                                    }else{
                                      if(_couponController.text.isNotEmpty && !coupon.isLoading) {
                                        if(coupon.discount < 1) {
                                          coupon.applyCoupon(_couponController.text, _total).then((discount) {
                                            if (discount > 0) {
                                              showCupertinoDialog( context: context, builder: (context)=> AnimateDialog(
                                                icon: Icons.check,
                                                title: 'You got ${PriceConverter.convertPrice(context, discount)} discount',
                                                isFailed: false,
                                                isDescription: false,
                                                btnText: 'Back'),
                                                barrierDismissible: false,
                                              );

                                            } else {
                                              showCupertinoDialog( context: context, builder: (context)=> AnimateDialog(
                                                icon: CupertinoIcons.xmark_octagon_fill,
                                                title: 'Failed',
                                                description: getTranslated('invalid_code_or', context),
                                                isFailed: false,
                                                isDescription: true,
                                                btnText: 'Back'),
                                              );
                                            }
                                          });
                                        } else {
                                          coupon.removeCouponData(true);
                                        }
                                      } else if(_couponController.text.isEmpty) {
                                        showCustomSnackBar(getTranslated('enter_a_Coupon_code', context), context);
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 50, width: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 0 : 10),
                                        right: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 10 : 0),
                                      ),
                                    ),
                                    child: coupon.discount <= 0 ? !coupon.isLoading ? Text(
                                      getTranslated('apply', context),
                                      style: rubikMedium.copyWith(color: Colors.white),
                                    ) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)) : Icon(Icons.clear, color: Colors.white),
                                  ),
                                ),
                              ]);
                            },
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // Order type
                          Text(getTranslated('delivery_option', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          DeliveryOptionButton(value: 'delivery', title: getTranslated('delivery', context)),
                          DeliveryOptionButton(value: 'take_away', title: getTranslated('take_away', context)),

                          // Total
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('items_price', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                            Text(PriceConverter.convertPrice(context, _itemPrice), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ]),
                          SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('tax', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                            Text('(+) ${PriceConverter.convertPrice(context, _tax)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ]),
                          SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('addons', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                            Text('(+) ${PriceConverter.convertPrice(context, _addOns)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ]),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: CustomDivider(),
                          ),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('subtotal', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                            Text(PriceConverter.convertPrice(context, _subTotal), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ]),
                          SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('discount', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                            Text('(-) ${PriceConverter.convertPrice(context, _discount)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ]),
                          SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('coupon_discount', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                            Text(
                              '(-) ${PriceConverter.convertPrice(context, Provider.of<CouponProvider>(context).discount)}',
                              style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                            ),
                          ]),
                          SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('delivery_fee', context), style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                            Text('(+) ${PriceConverter.convertPrice(context, deliveryCharge)}', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ]),

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: CustomDivider(),
                          ),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('total_amount', context), style: rubikMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor,
                            )),
                            Text(
                              PriceConverter.convertPrice(context, _total),
                              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
                            ),
                          ]),

                        ]),
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                width: 1170,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                child: CustomButton(btnTxt: getTranslated('place_order', context), onTap: () {
                  if(_orderAmount < Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                      'Minimum order amount is ${PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel
                          .minimumOrderValue)}, you have ${PriceConverter.convertPrice(context, _orderAmount)} in your cart, please add more item.',
                    ), backgroundColor: Theme.of(context).primaryColor));
                  } else {
                    Navigator.pushNamed(context, Routes.getCheckoutRoute(
                      _total, 'cart', Provider.of<OrderProvider>(context, listen: false).orderType,
                      Provider.of<CouponProvider>(context, listen: false).code,
                    ));
                  }
                }),
              ),

            ],
          ) : NoDataScreen(isCart: true);
        },
      ),
    );
  }
}
