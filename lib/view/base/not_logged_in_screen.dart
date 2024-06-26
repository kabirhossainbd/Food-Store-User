import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';


class NotLoggedInScreen extends StatelessWidget {
  final bool isFav;
  NotLoggedInScreen({@required this.isFav});
  @override
  Widget build(BuildContext context) {
    return  isFav ? Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 300,
        child:  Column(mainAxisSize: MainAxisSize.min, children: [

            SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.contact_support, size: 50),
            ),

          Text(
            getTranslated('guest_mode', context),
            style: rubikBold.copyWith(fontSize: MediaQuery.of(context).size.height*0.023),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.02),

          Text(
            getTranslated('now_you_are_in_guest_mode', context),
            style: rubikRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.03),


          SizedBox(
            width: 100,
            height: 40,
            child: CustomButton(btnTxt: getTranslated('login', context), onTap: () {
              Navigator.pushNamed(context, Routes.getLoginRoute());
            }),
          ),

          SizedBox(height: MediaQuery.of(context).size.height*0.03),

        ])
      ),
    ) :
    Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          Image.asset(
            Images.guest_login,
            width: MediaQuery.of(context).size.height*0.25,
            height: MediaQuery.of(context).size.height*0.25,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.03),

          Text(
            getTranslated('guest_mode', context),
            style: rubikBold.copyWith(fontSize: MediaQuery.of(context).size.height*0.023),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.02),

          Text(
            getTranslated('now_you_are_in_guest_mode', context),
            style: rubikRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.03),

          SizedBox(
            width: 100,
            height: 40,
            child: CustomButton(btnTxt: getTranslated('login', context), onTap: () {
              Navigator.pushNamed(context, Routes.getLoginRoute());
            }),
          ),

        ]),
      ),
    );
  }
}
