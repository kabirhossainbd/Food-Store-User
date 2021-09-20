

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final RestaurantModel restaurant;
  final bool isRestaurant;
  final int index;
  final int length;
  final bool inRestaurant;
  final bool isCampaign;
  ProductWidget({@required this.product, @required this.isRestaurant, @required this.restaurant, @required this.index,
    @required this.length, this.inRestaurant = false, this.isCampaign = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Provider.of<SplashProvider>(context, listen: false).configModel.baseUrls;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    double _discount;
    String _discountType;
    bool _isAvailable;

    return InkWell(
      onTap: () {
        // if(isRestaurant) {
        //   Get.toNamed(RouteHelper.getRestaurantRoute(restaurant.id), arguments: RestaurantScreen(restaurant: restaurant));
        // }else {
        //   ResponsiveHelper.isMobile(context) ? Get.bottomSheet(
        //     ProductBottomSheet(product: product, inRestaurantPage: inRestaurant, isCampaign: isCampaign),
        //     backgroundColor: Colors.transparent, isScrollControlled: true,
        //   ) : Get.dialog(
        //     Dialog(child: ProductBottomSheet(product: product, inRestaurantPage: inRestaurant, isCampaign: isCampaign)),
        //   );
        // }
      },
      child: Container(
        padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.FONT_SIZE_SMALL),
          color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
          boxShadow: ResponsiveHelper.isDesktop(context) ? [BoxShadow(
            color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300], spreadRadius: 1, blurRadius: 5,
          )] : null,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          Expanded(child: Padding(
            padding: EdgeInsets.symmetric(vertical: _desktop ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Row(children: [

              Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.FONT_SIZE_SMALL),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder_image,
                    image: '${ isRestaurant ? _baseUrls.restaurantImageUrl
                        : _baseUrls.productImageUrl}'
                        '/${isRestaurant ? restaurant.logo : product.image}',
                    height: _desktop ? 120 : 65, width: _desktop ? 120 : 80, fit: BoxFit.cover,
                  ),
                ),

              ]),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                  Text(
                    isRestaurant ? restaurant.name : product.name,
                    style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    maxLines: _desktop ? 2 : 1, overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  Text(
                    isRestaurant ? restaurant.address : '',
                    style: rubikRegular.copyWith(
                      fontSize: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      color: Theme.of(context).disabledColor,
                    ),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: (_desktop || isRestaurant) ? 5 : 0),

                  !isRestaurant ? RatingBar(
                    rating: isRestaurant ? '': product.rating, size: _desktop ? 15 : 12,
                  ) : SizedBox(),
                  SizedBox(height: (!isRestaurant && _desktop) ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),

                  isRestaurant ? RatingBar(
                    rating: isRestaurant ? '' : product.rating, size: _desktop ? 15 : 12,
                  ) : Row(children: [

                    Text('666',
                      style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                    ),
                    SizedBox(width: _discount > 0 ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),


                  ]),

                ]),
              ),

              Column(mainAxisAlignment: isRestaurant ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [

                !isRestaurant ? Padding(
                  padding: EdgeInsets.symmetric(vertical: _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
                  child: Icon(Icons.add, size: _desktop ? 30 : 25),
                ) : SizedBox(),


              ]),

            ]),
          )),

          _desktop ? SizedBox() : Padding(
            padding: EdgeInsets.only(left: _desktop ? 130 : 90),
            child: Divider(color: index == length-1 ? Colors.transparent : Theme.of(context).disabledColor),
          ),

        ]),
      ),
    );
  }
}
