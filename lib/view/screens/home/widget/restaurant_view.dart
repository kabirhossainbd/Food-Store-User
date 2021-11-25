
import 'package:flutter/cupertino.dart';
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
import 'package:flutter_restaurant/view/screens/home/widget/restaurant_pop_up.dart';
import 'package:flutter_restaurant/view/screens/restaurant/all_restaurant_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class RestaurantView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Consumer<RestaurantProvider>(
      builder: (context, restaurant, child) {
        return Column(
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
              child: TitleWidget(title: getTranslated('restaurants', context)),
            ),
            restaurant.restaurantList != null ? restaurant.restaurantList.length > 0 ?
            ResponsiveHelper.isMobile(context) ? GridView.builder(
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
                        color : ColorResources.getBackgroundColor(context),
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
            ) : Row(
              children: [
                Expanded(
                  child:  SizedBox(
                    height: 170,
                    child: restaurant.restaurantList != null ? restaurant.restaurantList.length > 0 ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                      itemCount: restaurant.restaurantList.length,
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
                              width: 150,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5,top: 5),
                              decoration: BoxDecoration(
                                color : ColorResources.getBackgroundColor(context),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [

                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder_image, height: 120, fit: BoxFit.cover,
                                    image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                                        ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}/${ restaurant.restaurantList[index].logo}':'',
                                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image,  height: 150, width: 200, fit: BoxFit.cover),
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    restaurant.restaurantList[index].name,
                                    style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                    maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                                  ),
                                ),
                              ]),
                            )
                        );
                      },
                    ) : Center(child: Text(getTranslated('no_combo_offer_available', context))) : Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),),
                  ),
                ),
                ResponsiveHelper.isMobile(context)? SizedBox(): restaurant.restaurantList != null ? Column(
                  children: [
                    InkWell(
                      onTap: (){
                        showDialog(context: context, builder: (con) => Dialog(
                            child: Container(height: 550, width: 600, child: RestaurantPopUp())
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(getTranslated('view_all', context), style: TextStyle(fontSize: 14,color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,)
                  ],
                ):  CategoryAllShimmer()
              ],
            ) : Center(child: Text(getTranslated('no_restaurant_found', context))) : ResponsiveHelper.isMobile(context) ? MobileRestaurantShimmer() : RestaurantShimmer(),


          ],
        );
      },
    );
  }
}


class CategoryAllShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: Provider.of<CategoryProvider>(context).categoryList == null,
          child: Column(children: [
            Container(
              height: 65, width: 65,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}



class RestaurantShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        itemCount: 10,
        itemBuilder: (context, index){
          return Container(
            height: 200,
            width: 150,
            margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 10, spreadRadius: 1)]
            ),
            child: Shimmer(
              duration: Duration(seconds: 1),
              interval: Duration(seconds: 1),
              enabled: Provider.of<RestaurantProvider>(context).restaurantList == null,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Container(
                  height: 110, width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      color: Colors.grey[300]
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Container(height: 15, width: 130, color: Colors.grey[300]),
                ),

              ]),
            ),
          );
        },
      ),
    );
  }
}

class MobileRestaurantShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: (1/1.1),
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
      ),
      itemCount: 9,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {

        return Shimmer(
          duration: Duration(seconds: 1),
          interval: Duration(seconds: 1),
          enabled: Provider.of<RestaurantProvider>(context).restaurantList == null,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Container(margin: EdgeInsets.symmetric(horizontal: 10),decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle))),
            Container(height: 10, color: Colors.grey[300], margin: EdgeInsets.only(left: 15, right: 15)),
          ]),
        );

      },
    );
  }
}