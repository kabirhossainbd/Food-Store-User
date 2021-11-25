import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/restaurant_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:flutter_restaurant/view/screens/restaurant/all_restaurant_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: TitleWidget(title: getTranslated('super_deals', context)),
        ),

        SizedBox(
          height: 160,
          child: Consumer<BannerProvider>(
            builder: (context, banner, child) {
              return banner.bannerList != null ? banner.bannerList.length > 0 ? ListView.builder(
                itemCount: banner.bannerList.length,
                padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if(banner.bannerList[index].productId != null) {
                        Products product;
                        for(Products prod in banner.productList) {
                          if(prod.id == banner.bannerList[index].productId) {
                            product = prod;
                            break;
                          }
                        }
                       ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (con) => CartBottomSheet(
                            product: product,
                            callback: (CartModel cartModel) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(getTranslated('added_to_cart', context)),
                                backgroundColor: Colors.green,
                              ));
                            },
                          ),
                        ): showDialog(context: context, builder: (con) => Dialog(
                         child: CartBottomSheet(
                           product: product,
                           callback: (CartModel cartModel) {
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                               content: Text(getTranslated('added_to_cart', context)),
                               backgroundColor: Colors.green,
                             ));
                           },
                         ),
                       )

                       );

                      }else if(banner.bannerList[index].restaurantId != null) {
                        RestaurantModel restaurant;
                        for(RestaurantModel restaurantModel in Provider.of<RestaurantProvider>(context, listen: false).restaurantList) {
                          if(restaurantModel.id == banner.bannerList[index].restaurantId) {
                            restaurant = restaurantModel;
                            break;
                          }
                        }
                        if(restaurant != null) {
                          Navigator.pushNamed(
                            context, Routes.getRestaurantDetailsRoute(restaurant.id),
                            arguments: RestaurantDetailsScreen(restaurantModel: restaurant),
                          );
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(
                            color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                            spreadRadius: 1, blurRadius: 5),
                        ],
                        color: ColorResources.COLOR_WHITE,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.logo, width: 280, height: double.infinity, fit: BoxFit.cover,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl}/${banner.bannerList[index].image}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.logo, width: 250, height: 85, fit: BoxFit.cover),
                        ),
                      ),
                    )
                  );
                },
              ) : Center(child: Text(getTranslated('no_banner_available', context))) : BannerShimmer();
            },
          ),
        ),
      ],
    );
  }
}

class BannerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Shimmer(
          duration: Duration(seconds: 2),
          enabled: Provider.of<BannerProvider>(context).bannerList == null,
          child: Container(
            width: 280, height: 160,
            margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey[200], spreadRadius: 1, blurRadius: 5)],
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}

