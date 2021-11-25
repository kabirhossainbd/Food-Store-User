import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/banner_model.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/restaurant_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:flutter_restaurant/view/screens/restaurant/all_restaurant_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WebBannerView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController();
    return Consumer<BannerProvider>(
      builder: (context, banner, child) => Container(
        color: ColorResources.getBottomSheetColor(context),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        alignment: Alignment.center,
        child: SizedBox(width: 1210, height: 220, child: banner.bannerList != null ? Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [

            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
              child: PageView.builder(
                controller: _pageController,
                itemCount: (banner.bannerList.length/2).ceil(),
                itemBuilder: (context, index) {
                  int index1 = index * 2;
                  int index2 = (index * 2) + 1;
                  bool _hasSecond = index2 < banner.bannerList.length;
                  String _baseUrl1 =  Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl;
                  String _baseUrl2 = _hasSecond ? banner.bannerList[index2] is BannerModel ? Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl : Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl : '';
                  return Row(children: [

                    Expanded(child: InkWell(
                      onTap: () {
                        _onTap(index1, context);
                        },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: FadeInImage.assetNetwork(
                          image: '$_baseUrl1/${banner.bannerList[index1].image}', fit: BoxFit.cover, height: 220,
                          placeholder: Images.logo,
                        ),
                      ),
                    )),

                    SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

                    Expanded(child: _hasSecond ? InkWell(
                      onTap: () => _onTap(index2, context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: FadeInImage.assetNetwork(
                          image: '$_baseUrl2/${banner.bannerList[index2].image}', fit: BoxFit.cover, height: 220,
                          placeholder: Images.logo,
                        ),
                      ),
                    ) : SizedBox()),

                  ]);
                },
                onPageChanged: (int index) => banner.setCurrentIndex(index, true),
              ),
            ),

            banner.currentIndex != 0 ? Positioned(
              top: 0, bottom: 0, left: 0,
              child: InkWell(
                onTap: () => _pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOut),
                child: Container(
                  height: 40, width: 40, alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Theme.of(context).cardColor,
                  ),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ) : SizedBox(),

            banner.currentIndex != ((banner.bannerList.length/2).ceil()-1) ? Positioned(
              top: 0, bottom: 0, right: 0,
              child: InkWell(
                onTap: () => _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut),
                child: Container(
                  height: 40, width: 40, alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Theme.of(context).cardColor,
                  ),
                  child: Icon(Icons.arrow_forward),
                ),
              ),
            ) : SizedBox(),

          ],
        ) : WebBannerShimmer()),
      ),
    );
  }

  void _onTap(int index, BuildContext context) {
    if(Provider.of<BannerProvider>(context, listen: false).bannerList[index].productId != null) {
      Products product;
      for(Products prod in Provider.of<BannerProvider>(context, listen: false).productList) {
        if(prod.id == Provider.of<BannerProvider>(context, listen: false).bannerList[index].productId) {
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

    }else if(Provider.of<BannerProvider>(context, listen: false).bannerList[index].restaurantId != null) {
      RestaurantModel restaurant;
      for(RestaurantModel restaurantModel in Provider.of<RestaurantProvider>(context, listen: false).restaurantList) {
        if(restaurantModel.id == Provider.of<BannerProvider>(context, listen: false).bannerList[index].restaurantId) {
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
  }
}

class WebBannerShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: Duration(seconds: 2),
      enabled: Provider.of<BannerProvider>(context, listen: false).bannerList == null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
        child: Row(children: [

          Expanded(child: Container(
            height: 220,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL), color: Colors.grey[300]),
          )),

          SizedBox(width: Dimensions.PADDING_SIZE_LARGE),

          Expanded(child: Container(
            height: 220,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL), color: Colors.grey[300]),
          )),

        ]),
      ),
    );
  }
}

