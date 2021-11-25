//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/data/model/response/category_model.dart';
// import 'package:flutter_restaurant/data/model/response/product_model.dart';
// import 'package:flutter_restaurant/data/model/response/restaurant_model.dart';
// import 'package:flutter_restaurant/helper/responsive_helper.dart';
// import 'package:flutter_restaurant/provider/category_provider.dart';
// import 'package:flutter_restaurant/provider/restaurant_provider.dart';
// import 'package:flutter_restaurant/provider/splash_provider.dart';
// import 'package:flutter_restaurant/provider/wishlist_provider.dart';
// import 'package:flutter_restaurant/utill/color_resources.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/utill/images.dart';
// import 'package:flutter_restaurant/utill/routes.dart';
// import 'package:flutter_restaurant/utill/styles.dart';
// import 'package:flutter_restaurant/view/base/main_app_bar.dart';
// import 'package:flutter_restaurant/view/base/no_data_screen.dart';
// import 'package:flutter_restaurant/view/base/product_shimmer.dart';
// import 'package:flutter_restaurant/view/base/product_widget.dart';
// import 'package:flutter_restaurant/view/screens/dashboard/widget/cart_widget.dart';
// import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
// import 'package:flutter_restaurant/view/screens/restaurant/demo/home_demo.dart';
// import 'package:provider/provider.dart';
//
//
// class RestaurantDetailsScreen extends StatefulWidget {
//   final RestaurantModel restaurantModel;
//   RestaurantDetailsScreen({@required this.restaurantModel});
//   @override
//   _RestaurantDetailsScreenState createState() => _RestaurantDetailsScreenState();
// }
//
// class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> with TickerProviderStateMixin {
//
//   int _tabIndex = 0;
//   ScrollController scrollController;
//   @override
//   void initState() {
//     // _tabController = TabController(length: 10, vsync: this);
//     // Provider.of<RestaurantProvider>(context, listen: false).init(this);
//     // getInit(this);
//     scrollController = ScrollController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     scrollController.dispose();
//     super.dispose();
//   }
//
//
//
//   // void getInit(TickerProvider ticker){
//   //   tabController = TabController(length: _categoryProducts.length, vsync: ticker);
//   //   print('VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV');
//   //   for(int i = 0; i < _categoryProducts.length; i++){
//   //     final category = _categoryProducts[i];
//   //     print('TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT${_categoryProducts.length}');
//   //     print('WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW$category');
//   //     tab.add(TabCategory(categoryModel: category, selected: (i == 0)));
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     // Provider.of<RestaurantProvider>(context, listen: false).init(this);
//     Provider.of<CategoryProvider>(context, listen: false).getCategoryList(context, true);
//     Provider.of<RestaurantProvider>(context, listen: false).getRestaurantProductList(context,widget.restaurantModel.id.toString());
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(preferredSize: Size.fromHeight(80), child: MainAppBar()) : null,
//         backgroundColor: ColorResources.getBackgroundColor(context),
//         body: Consumer<RestaurantProvider>(builder: (context, res, child) {
//           return Consumer<CategoryProvider>(builder: (context, category, child){
//
//             List<CategoryProduct> _categoryProducts = [];
//             List<CategoryItem> _items= [];
//             if(category.categoryList != null && res.restaurantProductList != null) {
//               _categoryProducts.add(CategoryProduct(CategoryModel(name: 'All'), res.restaurantProductList));
//               List<int> _categorySelectedIds = [];
//               List<int> _categoryIds = [];
//               category.categoryList.forEach((category) {
//                 _categoryIds.add(category.id);
//               });
//               _categorySelectedIds.add(0);
//               res.restaurantProductList.forEach((restProd) {
//                 if(!_categorySelectedIds.contains(int.parse(restProd.categoryIds[0].id))) {
//                   _categorySelectedIds.add(int.parse(restProd.categoryIds[0].id));
//                   _categoryProducts.add(CategoryProduct(
//                     category.categoryList[_categoryIds.indexOf(int.parse(restProd.categoryIds[0].id))],
//                     [restProd],
//                   ));
//                 }else {
//                   int _index = _categorySelectedIds.indexOf(int.parse(restProd.categoryIds[0].id));
//                   _categoryProducts[_index].products.add(restProd);
//                 }
//               });
//             }
//
//             double offset = 0.0;
//             for(int i = 0; i< _categoryProducts.length; i++) {
//               final categoryItem = _categoryProducts[i];
//
//               if(i > 0){
//                 offset = _categoryProducts[i -1].products.length * 100.0;
//               }
//               _tabs(_categoryProducts);
//               _items.add(CategoryItem(category: categoryItem.category));
//               for( int j = 0; j< categoryItem.products.length; j++){
//                 final product = categoryItem.products[j];
//                 _items.add(CategoryItem(products: product));
//               }
//             }
//             // // tab.add(TabCategory( category: _categoryProducts[0], select: (i == 0)));
//             //  _categoryProducts.forEach((element) {
//             //    print('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF${tab.length}');
//             //    return tab.add(TabCategory(category: element, select: true));
//             //  });
//
//             // for(int i = 0; i <  _categoryProducts.length; i++){
//             //   final category =  _categoryProducts[i];
//             //   print('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF${tab.length}');
//             //   tab.add(TabCategory( category: category, select: (i == 0)));
//             // }
//
//
//             return res.restaurantProductList != null ? Center(
//               child: SizedBox(
//                 width: Dimensions.WEB_MAX_WIDTH,
//                 child: CustomScrollView(
//                   physics: ClampingScrollPhysics(),
//                   slivers: [
//
//                     ResponsiveHelper.isDesktop(context) ? SliverToBoxAdapter(
//                       child: Container(
//                         color: ColorResources.getBottomSheetColor(context),
//                         padding: EdgeInsets.symmetric(horizontal: 10, vertical: Dimensions.FONT_SIZE_DEFAULT),
//                         alignment: Alignment.center,
//                         child: FadeInImage.assetNetwork(
//                           fit: BoxFit.fitWidth, placeholder: Images.placeholder_image, height: 300, width: 1170,
//                           image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}-cover/${widget.restaurantModel.coverImage}',
//                           imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 230, width: 1170, fit: BoxFit.scaleDown),
//                         ),
//                       ),
//                     )
//                         : SliverAppBar(
//                       expandedHeight: 230, toolbarHeight: 50,
//                       pinned: true, floating: false,
//                       backgroundColor: Theme.of(context).primaryColor,
//                       leading: IconButton(
//                         icon: Container(
//                           height: 50, width: 50,
//                           decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
//                           alignment: Alignment.center,
//                           child: Icon(Icons.chevron_left, color: ColorResources.COLOR_WHITE),
//                         ),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                       flexibleSpace: FlexibleSpaceBar(
//                         background: FadeInImage.assetNetwork(
//                           fit: BoxFit.cover, placeholder: Images.logo,width: 500,
//                           image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}-cover/${widget.restaurantModel.coverImage}',
//                           imageErrorBuilder: (c, o, s) => Image.asset(Images.logo, height: 230, fit: BoxFit.scaleDown, color: ColorResources.COLOR_WHITE,),
//                         ),
//                       ),
//                       actions: [IconButton(
//                         onPressed: () =>  Navigator.pushNamed(context, Routes.getCartRoute()),
//                         icon: Container(
//                           height: 50, width: 50,
//                           decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
//                           alignment: Alignment.center,
//                           child: CartWidget(color: ColorResources.COLOR_WHITE, size: 18, fromRestaurant: true),
//                         ),
//                       )],
//                     ),
//
//
//                     SliverToBoxAdapter(child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 12.0),
//                       child: Column( crossAxisAlignment: CrossAxisAlignment.start ,children: [
//                         Row(children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                             child: FadeInImage.assetNetwork(
//                               placeholder: Images.placeholder_image, height: 80, width: 80, fit: BoxFit.cover,
//                               image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
//                                   ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}/${widget.restaurantModel.logo}':'',
//                               imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image,  height: 80, width: 80, fit: BoxFit.cover),
//                             ),
//                           ),
//                           SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
//                           Text(
//                             widget.restaurantModel.name, style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
//                             maxLines: 1, overflow: TextOverflow.ellipsis,
//                           ),
//                         ]),
//                       ]),
//                     )),
//
//
//
//
//                     SliverPersistentHeader(
//                         pinned: true,
//                         delegate: SliverDelegate(child: Center(child: Container(
//                           width: Dimensions.WEB_MAX_WIDTH, color: ColorResources.getBackgroundColor(context),
//                           padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                           child: TabBar(
//                             indicatorWeight: 0.1,
//                             isScrollable: true,
//                             unselectedLabelColor: ColorResources.getGreyColor(context),
//                             indicatorSize: TabBarIndicatorSize.label,
//                             indicatorColor: Theme.of(context).primaryColor,
//                             labelColor: Theme.of(context).textTheme.bodyText1.color,
//                             controller: TabController(initialIndex: _tabIndex ,length: _categoryProducts.length, vsync: this),
//                             tabs: _tabs(_categoryProducts),
//                             onTap: (int index){
//                               _tabIndex = index;
//                               final selected  = _tabs(_categoryProducts)[index];
//                               for(int i = 0; i < _tabs(_categoryProducts).length; i++){
//                                 final condition = selected.text == _tabs(_categoryProducts)[i].text;
//                                 print('VVVVVVVVVVVVVVVVVVVVVVVVVVVVV$condition');
//                                 print('TTTTTTTTTTTTTTTTTTTTTTTTTTTTT${selected.text == _tabs(_categoryProducts)[i].text}');
//                                 _tabs(_categoryProducts)[i] = _tabs(_categoryProducts)[i];
//                               }
//                               scrollController.animateTo(offset, duration: Duration(milliseconds: 400), curve: Curves.ease);
//                             },
//
//                             // tab.map((e) {
//                             //   print('#####################################${_categoryProducts.length}');
//                             //   return TabWidget(e);
//                             // }).toList(),
//                           ),
//                         ),),
//                         )),
//
//
//                     // (category.categoryList.length != 0 && res.restaurantProductList != null) ? SliverPersistentHeader(
//                     //   pinned: true,
//                     //   delegate: SliverDelegate(child: Center(child: Container(
//                     //     width: Dimensions.WEB_MAX_WIDTH, color: ColorResources.getBackgroundColor(context),
//                     //     padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                     //     child: ListView.builder(
//                     //       scrollDirection: Axis.horizontal,
//                     //       itemCount: _categoryProducts.length,
//                     //       padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
//                     //       physics: BouncingScrollPhysics(),
//                     //       itemBuilder: (context, index) {
//                     //         return InkWell(
//                     //           onTap: () => res.setCategoryIndex(index),
//                     //           child: Container(
//                     //             alignment: Alignment.center,
//                     //             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
//                     //             decoration: BoxDecoration(
//                     //                 borderRadius: BorderRadius.circular(10),
//                     //                 color:  index == res.categoryIndex ? Theme.of(context).primaryColor : ColorResources.getBackgroundColor(context)
//                     //             ),
//                     //             child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//                     //               SizedBox(height: ResponsiveHelper.isDesktop(context) ? 0 : 3),
//                     //               Text(_categoryProducts[index].category.name, style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color:  index == res.categoryIndex ? ColorResources.COLOR_WHITE :  ColorResources.getTextColor(context)),),
//                     //               index == res.categoryIndex ? Container(
//                     //                 decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
//                     //               ) : SizedBox(),
//                     //             ]),
//                     //           ),
//                     //         );
//                     //       },
//                     //     ),
//                     //   ))),
//                     // ) : SliverToBoxAdapter(child: SizedBox()),
//                     //
//
//
//                     SliverToBoxAdapter(
//                       child: res.restaurantProductList  != null ? res.restaurantProductList .length > 0 ? GridView.builder(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisSpacing: 5,
//                           mainAxisSpacing: 5,
//                           childAspectRatio: 4,
//                           crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
//                         ),
//                         physics:  NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         controller: scrollController,
//                         itemCount: _items.length,
//                         padding: EdgeInsets.all(12),
//                         itemBuilder: (context, index) {
//                           final item = _items[index];
//                           if(item.isCategory){
//                             return Align(
//                               alignment: Alignment.bottomLeft,
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                                 child: Text(item.category.name, style: rubikBold.copyWith(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
//                               ),
//                             );
//                           }
//                           return ProductWidget( product: item.products);
//                         },
//                       ) : NoDataScreen() :
//                       GridView.builder(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
//                           mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0.01,
//                           childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : 4,
//                           crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
//                         ),
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: 20,
//                         padding: EdgeInsets.all(12),
//                         itemBuilder: (context, index) {
//                           return ProductShimmer(isEnabled: res.restaurantProductList  == null);
//                         },
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//             ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
//
//
//           });
//
//
//
//
//         },
//         ),
//       ),
//     );
//   }
//
//   List<Tab> _tabs(List<CategoryProduct> category) {
//     List<Tab> tabList = [];
//     category.forEach((subCategory) => tabList.add(Tab(text: subCategory.category.name)));
//     return tabList;
//   }
//
//
//
//
//
// }
//
// class CategoryProduct {
//   CategoryModel category;
//   List<Products> products;
//   CategoryProduct(this.category, this.products);
//   bool get isCategory => category != null;
// }
//
//
//
// class CategoryItem {
//   const CategoryItem({
//     this.category,
//     this.products,
//   });
//   final CategoryModel category;
//   final Products products;
//   bool get isCategory => category != null;
// }