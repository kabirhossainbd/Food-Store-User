import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/restaurant_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/restaurant/all_restaurant_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class RestaurantPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        height: 500,
        child: Consumer<RestaurantProvider>(
          builder: (context, restaurant, child) {
            return Column(
              children: [

                Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                  child:
                      TitleWidget(title: getTranslated('restaurants', context)),
                ),
                Expanded(
                  child: restaurant.restaurantList != null
                      ?  restaurant.restaurantList.length > 0
                          ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1/1.5,
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : 3,
                      // crossAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      // mainAxisSpacing: Dimensions.PADDING_SIZE_EXTRA_LARGE
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                    itemCount: restaurant.restaurantList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.getRestaurantDetailsRoute(restaurant.restaurantList[index].id),
                              arguments: RestaurantDetailsScreen(restaurantModel: restaurant.restaurantList[index]),
                            );
                          },

                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5,top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [

                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder_image, height: 110, fit: BoxFit.cover,
                                  image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                                      ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}/${ restaurant.restaurantList[index].logo}':'',
                                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image,  height: 110, width: 200, fit: BoxFit.cover),
                                ),
                              ),
                              Expanded(child: Text( restaurant.restaurantList[index].name, maxLines: 2, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center, style: rubikBold.copyWith(color: ColorResources.getTextColor(context), fontSize: 14)))
                            ]),
                          )
                      );
                    },
                  ) : Center(child: Text(getTranslated('no_category_available', context))) : CategoryShimmer(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer(
              duration: Duration(seconds: 2),
              enabled: Provider.of<CategoryProvider>(context).categoryList == null,
              child: Column(children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                    height: 10, width: 50, color: Colors.grey[300]),
              ]),
            ),
          );
        },
      ),
    );
  }
}
