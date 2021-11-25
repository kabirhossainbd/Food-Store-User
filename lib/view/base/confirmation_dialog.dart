

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

import 'custom_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final Function onYesPressed;
  ConfirmationDialog({@required this.icon, this.title, @required this.description, @required this.onYesPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PointerInterceptor(
        child: SizedBox(width: 500, child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Image.asset(icon, width: 50, height: 50),
            ),

            title != null ? Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
              child: Text(
                title, textAlign: TextAlign.center,
                style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
              ),
            ) : SizedBox(),

            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              child: Text(description, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE), textAlign: TextAlign.center),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            Consumer<OrderProvider>(builder: (context, orderController, child) {
              return !orderController.isLoading ? Row(children: [
                Expanded(child: CustomButton(
                  btnTxt:  getTranslated('no', context),
                  onTap: () => Navigator.pop(context),
                  backgroundColor: Theme.of(context).disabledColor.withOpacity(0.4),
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

                Expanded(child: CustomButton(
                  btnTxt:  getTranslated('yes', context),
                  onTap: () => onYesPressed(),
                )),
              ]) : Center(child: CircularProgressIndicator());
            }),

          ]),
        )),
      ),
    );
  }
}
