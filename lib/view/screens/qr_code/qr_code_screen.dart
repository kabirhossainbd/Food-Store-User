import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class QRCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _playStoreUrl='https://play.google.com/store/apps/details?id=com.thefoodstore';
    return Scaffold(
      appBar: null,
      bottomSheet: Container(
        height: 60,
       // padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Image.asset(Images.dark_logo, width: double.infinity, height: double.infinity,),
      ),
      body: SafeArea(
         child:  ResponsiveHelper.isMobile(context) ? Stack(
           clipBehavior: Clip.none,
           children: [
             Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 SizedBox(height: 70),
                 Text('Discover New \n THEFOODSTORE.APP' , style: rubikRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE), textAlign: TextAlign.center,),

                 SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                 Text('Get what you need, when you need it.' , style: rubikRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),),
                 SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                 Row( crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,children: [
                   InkWell(
                     onTap: () async {
                       // await canLaunch(_playStoreUrl)
                       //     ? await launch(_playStoreUrl)
                       //     : throw 'Could not launch $_playStoreUrl';

                       Container(
                         width: 100,
                         child:  ElegantNotification(
                           title:  "Coming Soon...",
                           description: "The work of giving A in the AppStore is going on",
                           icon:  Icon(Icons.access_alarm,color:  Colors.pink,),
                           progressIndicatorColor:  Colors.green,)
                             .show(context),
                       );
                     },
                     child: Container(
                         padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5),
                           color: ColorResources.getTextColor(context),
                         ),
                         child: Row(
                           children: [
                             Image.asset(Images.apple, height: 40, width: 40, color: ColorResources.getBackgroundColor(context),),
                             SizedBox(width: 3,),
                             Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Text('Download on the', style: rubikMedium.copyWith(color: ColorResources.getBackgroundColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),),
                                 Text('App Store', style: rubikMedium.copyWith(color: ColorResources.getBackgroundColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),),
                               ],
                             ),
                           ],
                         )),),

                   SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
                   InkWell(
                     onTap: () async {
                       await canLaunch(_playStoreUrl)
                           ? await launch(_playStoreUrl)
                           : throw 'Could not launch $_playStoreUrl';
                     },
                     child: Container(
                         padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5),
                           color: ColorResources.getTextColor(context),
                         ),
                         child: Row(
                           children: [
                             Image.asset(Images.playstore, height: 40, width: 40,),
                             SizedBox(width: 3,),
                             Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Text('Get It On', style: rubikMedium.copyWith(color: ColorResources.getBackgroundColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),),
                                 Text('Play Store', style: rubikMedium.copyWith(color: ColorResources.getBackgroundColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),),
                               ],
                             ),
                           ],
                         )),),
                 ],),
               ],
             ),
             Positioned(
               bottom: 60,
               right: 100,
               child: Image.asset(Images.qr_code, fit: BoxFit.cover, width: 300,),
             ),
           ],
         )
             : Row( crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [

           Expanded(
             child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 // SizedBox(height: 70),
                 Text('Discover New THEFOODSTORE.APP' , style: rubikRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE), textAlign: TextAlign.center,),

                 SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                 Text('Get what you need, when you need it.' , style: rubikRegular.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),),
                 SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
                 Row( crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,children: [
                   InkWell(
                     onTap: () async {
                       // await canLaunch(_playStoreUrl)
                       //     ? await launch(_playStoreUrl)
                       //     : throw 'Could not launch $_playStoreUrl';

                       Container(
                         width: 100,
                         child:  ElegantNotification(
                           title:  "Coming Soon...",
                           description: "The work of giving A in the AppStore is going on",
                           icon:  Icon(Icons.access_alarm,color:  Colors.pink,),
                           progressIndicatorColor:  Colors.green,)
                             .show(context),
                       );
                     },
                     child: Container(
                         padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5),
                           color: ColorResources.getTextColor(context),
                         ),
                         child: Row(
                           children: [
                             Image.asset(Images.apple, height: 40, width: 40, color: ColorResources.getBackgroundColor(context),),
                             SizedBox(width: 3,),
                             Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Text('Download on the', style: rubikMedium.copyWith(color: ColorResources.getBackgroundColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),),
                                 Text('App Store', style: rubikMedium.copyWith(color: ColorResources.getBackgroundColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),),
                               ],
                             ),
                           ],
                         )),),

                   SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
                   InkWell(
                     onTap: () async {
                       await canLaunch(_playStoreUrl)
                           ? await launch(_playStoreUrl)
                           : throw 'Could not launch $_playStoreUrl';
                     },
                     child: Container(
                         padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5),
                           color: ColorResources.getTextColor(context),
                         ),
                         child: Row(
                           children: [
                             Image.asset(Images.playstore, height: 40, width: 40,),
                             SizedBox(width: 3,),
                             Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Text('Get It On', style: rubikMedium.copyWith(color: ColorResources.getBackgroundColor(context), fontSize: Dimensions.FONT_SIZE_SMALL),),
                                 Text('Play Store', style: rubikMedium.copyWith(color: ColorResources.getBackgroundColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),),
                               ],
                             ),
                           ],
                         )),),
                 ],),
               ],
             ),
           ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 18.0),
             child: Image.asset(Images.qr_code, fit: BoxFit.cover, width: ResponsiveHelper.isDesktop(context) ? 400 : 300,),
           ),

           ResponsiveHelper.isDesktop(context) ? SizedBox(width: 60,) : SizedBox(width: 10,),
         ],),
      ),
    );
  }
}

