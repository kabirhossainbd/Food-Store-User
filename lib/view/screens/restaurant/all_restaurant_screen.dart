
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/restaurant_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/main_app_bar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/dashboard/widget/cart_widget.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final RestaurantModel restaurantModel;
  RestaurantDetailsScreen({@required this.restaurantModel});
  @override
  _RestaurantDetailsScreenState createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> with TickerProviderStateMixin {

  ScrollController scrollController;

  @override
  void initState() {
    Provider.of<RestaurantProvider>(context, listen: false).setTabIndex(0);
    Provider.of<CategoryProvider>(context, listen: false).getCategoryList(context, true);
    Provider.of<RestaurantProvider>(context, listen: false).getRestaurantProductList(context,widget.restaurantModel.id.toString());
    scrollController = ScrollController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(preferredSize: Size.fromHeight(80), child: MainAppBar()) : null,
        backgroundColor: ColorResources.getBackgroundColor(context),
        body: Consumer<RestaurantProvider>(builder: (context, res, child) {
          return Consumer<CategoryProvider>(builder: (context, category, child){

            List<CategoryProduct> _categoryProductsList = [];
            List<CategoryItem> _items= [];
            List<TabCategory> tabs = [];
            double offsetForm = 0.0;

            if(category.categoryList != null && res.restaurantProductList != null) {
              _categoryProductsList.add(CategoryProduct(category: CategoryModel(name: 'All'), products: res.restaurantProductList));
              List<int> _categorySelectedIds = [];
              List<int> _categoryIds = [];
              category.categoryList.forEach((category) {
                _categoryIds.add(category.id);
              });
              _categorySelectedIds.add(0);
              res.restaurantProductList.forEach((restProd) {
                if(!_categorySelectedIds.contains(int.parse(restProd.categoryIds[0].id))) {
                  _categorySelectedIds.add(int.parse(restProd.categoryIds[0].id));
                  _categoryProductsList.add(CategoryProduct(category:
                  category.categoryList[_categoryIds.indexOf(int.parse(restProd.categoryIds[0].id))],
                    products: [restProd],
                  ));
                }else {
                  int _index = _categorySelectedIds.indexOf(int.parse(restProd.categoryIds[0].id));
                  _categoryProductsList[_index].products.add(restProd);
                }
              });
            }

            for(int i = 0; i <  _categoryProductsList.length; i++){
              final category =  _categoryProductsList[i];
              if(i > 0){
                offsetForm += _categoryProductsList[i - 1].products.length * productHeight;
              }

              tabs.add(TabCategory(
                category: category.category,
                index: i,
                offsetForm: ResponsiveHelper.isDesktop(context) ? categoryHeight * i + offsetForm + 410 : categoryHeight * i + offsetForm + 260,));
              _items.add(CategoryItem(category: category.category));
              for( int j = 0; j< category.products.length; j++){
                final product = category.products[j];
                _items.add(CategoryItem(products: product));
              }
            }

            onCategorySelected(int index) async{
              final selected = tabs[index];
              for(int i = 0; i <  tabs.length; i++){
                if(selected.category.id == tabs[i].category.id){
                // tabs[i] = tabs[i].copyWith(index);
                  res.setTabIndex(i);
                }
              }
              await scrollController.animateTo(tabs[index].offsetForm,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear);
              setState(() {
              });
            }

            return AnimatedBuilder(
              animation: res,
              builder: (_, __) => Center(
                child: SizedBox(
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: CustomScrollView(
                        controller: scrollController,
                        slivers: [

                          ResponsiveHelper.isDesktop(context) ? SliverToBoxAdapter(
                            child: Container(
                              color: ColorResources.getBottomSheetColor(context),
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: Dimensions.FONT_SIZE_DEFAULT),
                              alignment: Alignment.center,
                              child: FadeInImage.assetNetwork(
                                fit: BoxFit.fitWidth, placeholder: Images.placeholder_image, height: 300, width: 1170,
                                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}-cover/${widget.restaurantModel.coverImage}',
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 230, width: 1170, fit: BoxFit.scaleDown),
                              ),
                            ),
                          )
                              : SliverAppBar(
                            expandedHeight: 230, toolbarHeight: 50,
                            pinned: true, floating: false,
                            backgroundColor: Theme.of(context).primaryColor,
                            leading: IconButton(
                              icon: Container(
                                height: 50, width: 50,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                                alignment: Alignment.center,
                                child: Icon(Icons.chevron_left, color: ColorResources.COLOR_WHITE),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            flexibleSpace: FlexibleSpaceBar(
                              background: FadeInImage.assetNetwork(
                                fit: BoxFit.cover, placeholder: Images.logo,width: 500,
                                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}-cover/${widget.restaurantModel.coverImage}',
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.logo, height: 230, fit: BoxFit.scaleDown, color: ColorResources.COLOR_WHITE,),
                              ),
                            ),
                            actions: [IconButton(
                              onPressed: () =>  Navigator.pushNamed(context, Routes.getCartRoute()),
                              icon: Container(
                                height: 50, width: 50,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                                alignment: Alignment.center,
                                child: CartWidget(color: ColorResources.COLOR_WHITE, size: 18, fromRestaurant: true),
                              ),
                            )],
                          ),

                          SliverToBoxAdapter(child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column( crossAxisAlignment: CrossAxisAlignment.start ,children: [
                              Row(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder_image, height: 80, width: 80, fit: BoxFit.cover,
                                    image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                                        ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}/${widget.restaurantModel.logo}':'',
                                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image,  height: 80, width: 80, fit: BoxFit.cover),
                                  ),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                Text(
                                  widget.restaurantModel.name, style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                ),
                              ]),
                            ]),
                          )),


                          SliverPersistentHeader(
                            pinned: true,
                            delegate: SliverDelegate(
                              child: _categoryProductsList.length > 0 ? Container(
                                height: 80,
                                color: ColorResources.getBottomSheetColor(context),
                                alignment: Alignment.centerLeft,
                                child: TabBar(
                                  onTap: onCategorySelected,
                                  indicatorWeight: 0.1,
                                  isScrollable: true,
                                  controller: TabController(length: _categoryProductsList.length, vsync: this),
                                  tabs: tabs.map((e) => TabWidget(e)).toList(),
                                ),
                              ) : TabBarShimmer(isEnabled: _categoryProductsList.length == null,),
                            ),

                          ),

                          SliverToBoxAdapter(
                            child: res.restaurantProductList  != null ? res.restaurantProductList .length > 0 ?
                            ListView.builder(
                                controller: scrollController,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                shrinkWrap: true,
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  final item = _items[index];
                                  if(item.isCategory){
                                    return CategoryWidget(category: item.category);
                                  }
                                  return Container(
                                      height: productHeight,
                                      child: ProductWidget(product: item.products));
                                }): NoDataScreen() :
                            GridView.builder(
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

                        ])
                ),
              ),
            );
          });

        },
        ),
      )
    );
  }




}

class CategoryProduct {
  final CategoryModel category;
  final List<Products> products;
  CategoryProduct({ this.category, this.products});
}


class CategoryItem {
  final CategoryModel category;
  final Products products;
  CategoryItem({ this.category, this.products});
  bool get isCategory => category != null;
}


class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  CategoryWidget({@required this.category});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: categoryHeight,
      alignment: Alignment.centerLeft,
      color: ColorResources.getBottomSheetColor(context),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(category.name, style: rubikMedium.copyWith(color: Theme.of(context).primaryColor.withOpacity(0.7)),),
    );
  }
}

class TabCategory{
  final CategoryModel category;
  final int index;
  final double offsetForm;
  TabCategory({@required this.category,this.index, @required this.offsetForm});
  TabCategory copyWith(int index) => TabCategory(category: category, index: index, offsetForm: offsetForm);
}


class TabWidget extends StatelessWidget {
  const TabWidget(this.category);
  final TabCategory category;
  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, res, child) => Opacity(
        opacity: category.index == res.tabIndex ? 1 : 0.5,
        child: Container(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: category.index == res.tabIndex ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(category.category.name, style: rubikRegular.copyWith(color: category.index == res.tabIndex  ? ColorResources.COLOR_WHITE : ColorResources.COLOR_BLACK),),
          ),
        ),
      ),
    );
  }
}



class TabBarShimmer extends StatelessWidget {
  final bool isEnabled;
  TabBarShimmer({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: ColorResources.getBackgroundColor(context),
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        itemCount: 10,
        itemBuilder: (context, index){
          return Shimmer(
            duration: Duration(seconds: 1),
            interval: Duration(seconds: 1),
            enabled: Provider.of<RestaurantProvider>(context).restaurantList == null,
            child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 15, width: 110, ),
            ),
          );
        },
      ),
    );
  }
}
