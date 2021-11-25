import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/main_app_bar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:provider/provider.dart';

class InviteFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
     // Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)): CustomAppBar(context: context, title: getTranslated('invite friends', context)),
      body: _isLoggedIn ? Consumer<ProfileProvider>(
        builder: (context, refer, child) {
          return refer.userInfoModel != null ? refer.userInfoModel.data.referId != null ? Scrollbar(
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                    width: 1170,
                    child: Column( mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10,),
                        Image.asset(Images.refer_image, height: 250, width: 600,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
                          child: Text('Invite your friends and share the love of Food',textAlign: TextAlign.center,style: rubikBold.copyWith(color: ColorResources.getTextColor(context), fontSize: 18),),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                        Container(
                          width: 200,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color:ColorResources.getGreyColor(context), width: 1 ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row( crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(refer.userInfoModel.data.referId, style: rubikRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_DEFAULT),),

                              SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
                              Container(width: 1, height: 25, color: ColorResources.getGrayColor(context)),
                              SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: refer.userInfoModel.data.referId));
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Refer Code Copied'), backgroundColor: Colors.green));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: ColorResources.getBottomSheetColor(context),
                                        ),
                                        child:  Icon(Icons.copy, color: Theme.of(context).primaryColor,)),
                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    Text('Copy', style: rubikRegular.copyWith(color: Theme.of(context).primaryColor))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50,),
                      ],
                    )
                ),
              ),
            ),
          ) : NoDataScreen() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : NotLoggedInScreen(isFav: false,),
    );
  }
}
