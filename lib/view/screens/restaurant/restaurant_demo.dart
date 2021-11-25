//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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
// import 'package:flutter_restaurant/view/screens/restaurant/demo/data.dart';
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
//   TabController tabController;
//   ScrollController scrollController;
//
//   @override
//   void initState() {
//     scrollController = ScrollController();
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // Provider.of<RestaurantProvider>(context, listen: false).init(this);
//     Provider.of<CategoryProvider>(context, listen: false).getCategoryList(context, true);
//     Provider.of<RestaurantProvider>(context, listen: false).getRestaurantProductList(context,widget.restaurantModel.id.toString());
//
//     return SafeArea(
//       child: AnimatedBuilder(
//         animation: Provider.of<RestaurantProvider>(context, listen: false),
//         builder: (_, __) => Scaffold(
//           appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(preferredSize: Size.fromHeight(80), child: MainAppBar()) : null,
//           backgroundColor: ColorResources.getBackgroundColor(context),
//           body: Consumer<RestaurantProvider>(builder: (context, res, child) {
//             return Consumer<CategoryProvider>(builder: (context, category, child){
//
//               List<CategoryProduct> _categoryProductsList = [];
//               List<CategoryItem> _items= [];
//               List<TabCategory> tabs = [];
//               bool _listen = true;
//               double offsetForm = 0.0;
//               double offsetTo = 0.0;
//
//               if(category.categoryList != null && res.restaurantProductList != null) {
//                 _categoryProductsList.add(CategoryProduct(category: CategoryModel(name: 'All'), products: res.restaurantProductList));
//                 List<int> _categorySelectedIds = [];
//                 List<int> _categoryIds = [];
//                 category.categoryList.forEach((category) {
//                   _categoryIds.add(category.id);
//                 });
//                 _categorySelectedIds.add(0);
//                 res.restaurantProductList.forEach((restProd) {
//                   if(!_categorySelectedIds.contains(int.parse(restProd.categoryIds[0].id))) {
//                     _categorySelectedIds.add(int.parse(restProd.categoryIds[0].id));
//                     _categoryProductsList.add(CategoryProduct(category:
//                     category.categoryList[_categoryIds.indexOf(int.parse(restProd.categoryIds[0].id))],
//                       products: [restProd],
//                     ));
//                   }else {
//                     int _index = _categorySelectedIds.indexOf(int.parse(restProd.categoryIds[0].id));
//                     _categoryProductsList[_index].products.add(restProd);
//                   }
//                 });
//               }
//
//               onCategorySelected(int index, {bool animationRequired = true}) async{
//                 final selected  = tabs[index];
//                 for(int i = 0; i <  tabs.length; i++){
//                   final condition = selected.category.id == tabs[i].category.id;
//                   tabs[i] = tabs[i].copyWith(condition);
//                 }
//                 if(animationRequired){
//                   await scrollController.animateTo(selected.offsetForm,
//                       duration: const Duration(milliseconds: 500),
//                       curve: Curves.linear);
//                 }
//               }
//
//               for(int i = 0; i <  _categoryProductsList.length; i++){
//                 final category =  _categoryProductsList[i];
//
//                 if(i > 0){
//                   offsetForm += _categoryProductsList[i - 1].products.length * productHeight;
//                 }
//                 if(i < _categoryProductsList.length -1){
//                   offsetTo = offsetForm + _categoryProductsList[i + 1].products.length * productHeight;
//                 }else{
//                   offsetTo = double.infinity;
//                 }
//                 tabs.add(TabCategory(
//                     category: category.category,
//                     selected: (i == 0),
//                     offsetForm: categoryHeight * i + offsetForm,
//                     offsetTo: offsetTo));
//                 _items.add(CategoryItem(category: category.category));
//                 for( int j = 0; j< category.products.length; j++){
//                   final product = category.products[j];
//                   _items.add(CategoryItem(products: product));
//                 }
//               }
//
//
//               return Center(
//                 child: SizedBox(
//                   width: Dimensions.WEB_MAX_WIDTH,
//                   child: AnimatedBuilder(
//                     animation: Provider.of<RestaurantProvider>(context),
//                     builder: (_, __)=> Column(
//                         children: [
//
//                           ResponsiveHelper.isDesktop(context) ? Container(
//                             color: ColorResources.getBottomSheetColor(context),
//                             padding: EdgeInsets.symmetric(horizontal: 10, vertical: Dimensions.FONT_SIZE_DEFAULT),
//                             alignment: Alignment.center,
//                             child: FadeInImage.assetNetwork(
//                               fit: BoxFit.fitWidth, placeholder: Images.placeholder_image, height: 230, width: 1170,
//                               image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}-cover/${widget.restaurantModel.coverImage}',
//                               imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 230, width: 1170, fit: BoxFit.scaleDown),
//                             ),
//                           ) : Container(
//                             height: 130,
//                             width: double.infinity,
//                             padding: EdgeInsets.symmetric(horizontal: 10),
//                             child: Stack(
//                               children: [
//                                 FadeInImage.assetNetwork(
//                                   fit: BoxFit.cover, placeholder: Images.logo,width: double.infinity,
//                                   image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}-cover/${widget.restaurantModel.coverImage}',
//                                   imageErrorBuilder: (c, o, s) => Image.asset(Images.logo, height: 230, fit: BoxFit.scaleDown, color: ColorResources.COLOR_WHITE,),
//                                 ),
//                                 Positioned(
//                                   left: 0,
//                                   right: 0,
//                                   top: 0,
//                                   child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
//                                     IconButton(
//                                       icon: Container(
//                                         height: 50, width: 50,
//                                         decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
//                                         alignment: Alignment.center,
//                                         child: Icon(Icons.chevron_left, color: ColorResources.COLOR_WHITE),
//                                       ),
//                                       onPressed: () => Navigator.pop(context),
//                                     ),
//                                     SizedBox(width: 3,),
//                                     IconButton(
//                                       onPressed: () =>  Navigator.pushNamed(context, Routes.getCartRoute()),
//                                       icon: Container(
//                                         height: 50, width: 50,
//                                         decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
//                                         alignment: Alignment.center,
//                                         child: CartWidget(color: ColorResources.COLOR_WHITE, size: 18, fromRestaurant: true),
//                                       ),
//                                     )
//                                   ]),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 12.0),
//                             child: Column( crossAxisAlignment: CrossAxisAlignment.start ,children: [
//                               Row(children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                                   child: FadeInImage.assetNetwork(
//                                     placeholder: Images.placeholder_image, height: 80, width: 80, fit: BoxFit.cover,
//                                     image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
//                                         ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.restaurantImageUrl}/${widget.restaurantModel.logo}':'',
//                                     imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image,  height: 80, width: 80, fit: BoxFit.cover),
//                                   ),
//                                 ),
//                                 SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
//                                 Text(
//                                   widget.restaurantModel.name, style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
//                                   maxLines: 1, overflow: TextOverflow.ellipsis,
//                                 ),
//                               ]),
//                             ]),
//                           ),
//
//                           Container(
//                             height: 80,
//                             alignment: Alignment.centerLeft,
//                             child: TabBar(
//                               onTap: (int index){
//                                 onCategorySelected(index);
//                               },
//                               indicatorWeight: 0.1,
//                               isScrollable: true,
//                               controller: TabController(length: _categoryProductsList.length, vsync: this),
//                               tabs: tabs.map((e) => TabWidget(e)).toList(),
//                             ),
//                           ),
//
//
//                           res.restaurantProductList  != null ? res.restaurantProductList .length > 0 ?
//                           Expanded(
//                             child: ListView.builder(
//                                 controller: scrollController,
//                                 padding: EdgeInsets.symmetric(horizontal: 20),
//                                 itemCount: _items.length,
//                                 itemBuilder: (context, index) {
//                                   final item = _items[index];
//                                   if(item.isCategory){
//                                     return CategoryWidget(category: item.category);
//                                   }
//                                   return Container(
//                                       height: productHeight,
//                                       child: ProductWidget(product: item.products));
//                                 }),
//                           ) :
//                           NoDataScreen() :
//                           Expanded(
//                             child: GridView.builder(
//                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
//                                 mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0.01,
//                                 childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 : 4,
//                                 crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1,
//                               ),
//                               physics: NeverScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                               itemCount: 20,
//                               padding: EdgeInsets.all(12),
//                               itemBuilder: (context, index) {
//                                 return ProductShimmer(isEnabled: res.restaurantProductList  == null);
//                               },
//                             ),
//                           ),
//                         ]),
//                   ),
//                 ),
//               );
//             });
//
//           },
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//
// }
//
// class CategoryProduct {
//   final CategoryModel category;
//   final List<Products> products;
//   CategoryProduct({ this.category, this.products});
// }
//
//
// class CategoryItem {
//   final CategoryModel category;
//   final Products products;
//   CategoryItem({ this.category, this.products});
//   bool get isCategory => category != null;
// }
//
//
// class CategoryWidget extends StatelessWidget {
//   final CategoryModel category;
//   CategoryWidget({@required this.category});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: categoryHeight,
//       alignment: Alignment.centerLeft,
//       color: ColorResources.getBottomSheetColor(context),
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Text(category.name, style: rubikMedium.copyWith(color: Theme.of(context).primaryColor.withOpacity(0.7)),),
//     );
//   }
// }
//
// class TabCategory{
//   final CategoryModel category;
//   final bool selected;
//   final double offsetForm;
//   final double offsetTo;
//   TabCategory({@required this.category,@required this.selected, @required this.offsetForm, @required this.offsetTo });
//   TabCategory copyWith(bool selected) => TabCategory(category: category, selected: selected, offsetForm: offsetForm, offsetTo:offsetTo);
//
// }
//
//
// class TabWidget extends StatelessWidget {
//   const TabWidget(this.category);
//   final TabCategory category;
//   @override
//   Widget build(BuildContext context) {
//     final selected = category.selected;
//     return Opacity(
//       opacity: selected ? 1 : 0.5,
//       child: Container(
//         height: 30,
//         padding: EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: selected ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context)
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(category.category.name, style: rubikRegular.copyWith(color: selected ? ColorResources.COLOR_WHITE : ColorResources.COLOR_BLACK),),
//         ),
//       ),
//     );
//   }
// }