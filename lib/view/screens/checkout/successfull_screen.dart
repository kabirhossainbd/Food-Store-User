import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  final String orderID;
  final int status;
  OrderSuccessfulScreen({@required this.orderID, @required this.status});

  @override
  State<OrderSuccessfulScreen> createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {

    @override
  void initState() {
    Timer(Duration(seconds: 5), () async {
      Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, user, child){
      return Scaffold(
        backgroundColor: ColorResources.COLOR_PRIMARY,
        bottomSheet: Container(
          color: ColorResources.COLOR_PRIMARY,
          child: Container(
            alignment: Alignment.center,
            height: 240,
            width: double.infinity,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              color: ColorResources.getBottomSheetColor(context),
              borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child:  Column( crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Preparing Your Order.',  style: rubikRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_LARGE)),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                Text('Your order will be prepared and will come soon...',  style: rubikRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                SizedBox(height: 75),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            ResponsiveHelper.isMobile(context) ? SizedBox(height: 75) : SizedBox(),
            ResponsiveHelper.isMobilePhone() ? Stack(
              clipBehavior: Clip.none,
              children: [
                Lottie.asset(
                  Images.successful,
                ),
                Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Column(
                  children: [


                    Text('${user.userInfoModel.fName.toUpperCase()} ${user.userInfoModel.lName.toUpperCase()}, ${'Your order has been Successfully Done!'}',
                      style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.COLOR_WHITE), textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('${'Your Order Id'} :', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.COLOR_WHITE)),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text('orderID', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.COLOR_WHITE)),
                    ]),
                  ],
                ))
              ],
            ) :
            ResponsiveHelper.isMobile(context) ? Column(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  child: Lottie.asset(
                    Images.successful,
                  ),
                ),

                Text('${user.userInfoModel.fName.toUpperCase()} ${user.userInfoModel.lName.toUpperCase()}, ${'Your order has been Successfully Done!'}',
                  style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.COLOR_WHITE), textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${'Your Order Id'} :', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.COLOR_WHITE)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text('orderID', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.COLOR_WHITE)),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
              ],
            ) : Column(
              children: [
                Container(
                  height: 220,
                  width: 220,
                  child: Lottie.asset(
                    Images.successful,
                  ),
                ),

                Text('${user.userInfoModel.fName.toUpperCase()} ${user.userInfoModel.lName.toUpperCase()}, ${'Your order has been Successfully Done!'}',
                  style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.COLOR_WHITE), textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${'Your Order Id'} :', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.COLOR_WHITE)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text('orderID', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.COLOR_WHITE)),
                ])
              ],
            ),

          ]),
        ),
      );
    });
  }
}
