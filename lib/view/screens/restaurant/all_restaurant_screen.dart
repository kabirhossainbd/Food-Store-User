
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/restaurant_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:provider/provider.dart';


class RestaurantDetailsScreen extends StatelessWidget {
  final RestaurantModel restaurantModel;
  RestaurantDetailsScreen({@required this.restaurantModel});

  @override
  Widget build(BuildContext context) {
    Provider.of<CategoryProvider>(context, listen: false).getCategoryList(context, true);
    Provider.of<RestaurantProvider>(context, listen: false).getRestaurantProductList(context,restaurantModel.id.toString());

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorResources.getBackgroundColor(context),
        body: Consumer<RestaurantProvider>(builder: (context, res, child) {
          return Consumer<CategoryProvider>(builder: (context, category, child){

            List<CategoryProduct> _categoryProducts = [];
            if(category.categoryList != null && res.restaurantProductList != null) {
              _categoryProducts.add(CategoryProduct(CategoryModel(name: 'All'), res.restaurantProductList));
              List<int> _categorySelectedIds = [];
              List<int> _categoryIds = [];
              category.categoryList.forEach((category) {
                _categoryIds.add(category.id);
              });
              _categorySelectedIds.add(0);
              res.restaurantProductList.forEach((restProd) {
                if(!_categorySelectedIds.contains(int.parse(restProd.categoryIds[0].id))) {
                  _categorySelectedIds.add(int.parse(restProd.categoryIds[0].id));
                  _categoryProducts.add(CategoryProduct(
                    category.categoryList[_categoryIds.indexOf(int.parse(restProd.categoryIds[0].id))],
                    [restProd],
                  ));
                }else {
                  int _index = _categorySelectedIds.indexOf(int.parse(restProd.categoryIds[0].id));
                  _categoryProducts[_index].products.add(restProd);
                }
              });
            }

            return res.restaurantProductList != null ? CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: [


                SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Stack(clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: ColorResources.getBackgroundColor(context),
                              child: SizedBox(height: 300,),
                            ),
                            FadeInImage.assetNetwork(
                              fit: BoxFit.fitWidth, placeholder: Images.placeholder_rectangle, height: 220, width: double.infinity,
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}-cover/${restaurantModel.coverImage}',
                            ),
                            Positioned(
                              top: 30,
                              left: 25,
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: ColorResources.getGreyColor(context),
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Consumer<WishListProvider>(
                                      builder: (context, wishList, child) {
                                        return InkWell(
                                          onTap: () => Navigator.pop(context),
                                          child: Icon(
                                              Icons.chevron_left, color: ColorResources.COLOR_WHITE
                                          ),
                                        );
                                      }
                                  )),
                            ),
                            Positioned(
                              top: 30,
                              right: 25,
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: ColorResources.getGreyColor(context),
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context, Routes.getCartRoute(),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Icon(
                                          Icons.shopping_bag,
                                          color: ColorResources.COLOR_WHITE,
                                        ),
                                        Positioned(
                                          top: 0, right: 2,
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                            child: Text(
                                              Provider.of<CartProvider>(context).cartList.length.toString(),
                                              style: rubikMedium.copyWith(color: ColorResources.COLOR_WHITE, fontSize: 8),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),

                            // for restaurant details
                            Positioned(
                              top: 150,
                              left: 30,
                              right: 30,
                              child: Card(
                                color:  ColorResources.getBottomSheetColor(context),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  width: 80,
                                  height: MediaQuery.of(context).size.height/5,
                                  decoration: BoxDecoration(
                                    color: ColorResources.getBottomSheetColor(context),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                                  ),
                                  child: Row(children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholder_image, height: 80, width: 80, fit: BoxFit.cover,
                                          image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                                              ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}/${restaurantModel.logo}':'',
                                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image,  height: 80, width: 80, fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column( crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center ,children: [
                                        SelectableText(restaurantModel.name, maxLines: 1, style: rubikBold.copyWith( fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                                        SelectableText(restaurantModel.address, maxLines: 1, style: rubikBold.copyWith(color: ColorResources.getGreyColor(context), fontSize: Dimensions.FONT_SIZE_SMALL)),

                                      ],),
                                    )
                                  ],),),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      ],
                    )
                ),

                (category.categoryList.length != 0 && res.restaurantProductList != null) ? SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(child: Center(child: Container(
                    height: 50, width: double.infinity, color: ColorResources.getBackgroundColor(context),
                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categoryProducts.length,
                      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => res.setCategoryIndex(index),
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL,),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:  index == res.categoryIndex ? Theme.of(context).primaryColor : ColorResources.getBackgroundColor(context)
                            ),
                            child: Text( _categoryProducts[index].category.name, style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color:  index == res.categoryIndex ? ColorResources.COLOR_WHITE :  ColorResources.getTextColor(context)),),
                          )
                        );
                      },
                    ),
                  ))),
                ) : SliverToBoxAdapter(child: SizedBox()),

                SliverToBoxAdapter(
                  child: res.restaurantProductList  != null ? res.restaurantProductList .length > 0 ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                      mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0.01,
                      childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : 4,
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                    ),
                    physics:  NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _categoryProducts[res.categoryIndex].products.length,
                    padding: EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      return ProductWidget( product: _categoryProducts.length > 0 ? _categoryProducts[res.categoryIndex].products[index] : null,);
                    },
                  ) : NoDataScreen() : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                      mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0.01,
                      childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : 4,
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 20,
                    padding: EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      return ProductShimmer(isEnabled: res.restaurantProductList  == null);
                    },
                  ),
                ),

              ],
            ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));


          });




        },
        ),
      ),
    );
  }

}

class CategoryProduct {
  CategoryModel category;
  List<Product> products;
  CategoryProduct(this.category, this.products);
}