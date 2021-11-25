// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/data/model/response/category_model.dart';
// import 'package:flutter_restaurant/data/model/response/product_model.dart';
// import 'package:flutter_restaurant/provider/category_provider.dart';
// import 'package:flutter_restaurant/provider/restaurant_provider.dart';
// import 'package:flutter_restaurant/view/screens/restaurant/demo/data.dart';
// import 'package:flutter_restaurant/view/screens/restaurant/demo/demo_home.dart';
// import 'package:flutter_restaurant/view/screens/restaurant/demo/home_demo.dart';
// import 'package:provider/provider.dart';
//
// import '../all_restaurant_screen.dart';
//
//
// class RestaruntantProviderDemo with ChangeNotifier{
//
//   TabController tabController;
//   List<TabCategoryDemo> tabs = [];
//   List<DemoProductCategoryItem> items = [];
//   ScrollController scrollController = ScrollController();
//   bool _listen = true;
//   List<CategoryProduct> _categoryProductsList = [];
//   List<CategoryProduct> get categoryProductsList => _categoryProductsList;
//
//
//
//
//   void init(TickerProvider ticker, BuildContext context){
//
//
//     if(Provider.of<CategoryProvider>(context, listen: false).categoryList != null &&  Provider.of<RestaurantProvider>(context, listen: false).restaurantProductList != null) {
//       _categoryProductsList.add(CategoryProduct(category: CategoryModel(name: 'All'), products:  Provider.of<RestaurantProvider>(context, listen: false).restaurantProductList));
//       List<int> _categorySelectedIds = [];
//       List<int> _categoryIds = [];
//       Provider.of<CategoryProvider>(context, listen: false).categoryList.forEach((category) {
//         _categoryIds.add(category.id);
//       });
//       _categorySelectedIds.add(0);
//       Provider.of<RestaurantProvider>(context, listen: false).restaurantProductList.forEach((restProd) {
//         if(!_categorySelectedIds.contains(int.parse(restProd.categoryIds[0].id))) {
//           _categorySelectedIds.add(int.parse(restProd.categoryIds[0].id));
//           _categoryProductsList.add(CategoryProduct(category:
//           Provider.of<CategoryProvider>(context, listen: false).categoryList[_categoryIds.indexOf(int.parse(restProd.categoryIds[0].id))],
//             products: [restProd],
//           ));
//         }else {
//           int _index = _categorySelectedIds.indexOf(int.parse(restProd.categoryIds[0].id));
//           _categoryProductsList[_index].products.add(restProd);
//         }
//       });
//     }
//
//
//     tabController = TabController(length: _categoryProductsList.length, vsync: ticker);
//
//     print('TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT${_categoryProductsList.length}');
//     double offsetForm = 0.0;
//     double offsetTo = 0.0;
//     for(int i = 0; i <  _categoryProductsList.length; i++){
//       final category =  _categoryProductsList[i];
//
//       if(i > 0){
//         offsetForm += _categoryProductsList[i - 1].products.length * productHeight;
//       }
//       if(i < _categoryProductsList.length -1){
//         offsetTo = offsetForm + _categoryProductsList[i + 1].products.length * productHeight;
//       }else{
//         offsetTo = double.infinity;
//       }
//       tabs.add(TabCategoryDemo(
//           category: category.category,
//           selected: (i == 0),
//           offsetForm: categoryHeight * i + offsetForm,
//           offsetTo: offsetTo));
//       items.add(DemoProductCategoryItem(category: category.category));
//       for( int j = 0; j< category.products.length; j++){
//         final product = category.products[j];
//         items.add(DemoProductCategoryItem(products: product));
//       }
//     }
//     scrollController.addListener(_onScrollingListener);
//   }
//
//
//
//   void _onScrollingListener() {
//     if (_listen) {
//       for (int i = 0; i < tabs.length; i++) {
//         final tab = tabs[i];
//         if (scrollController.offset >= tab.offsetForm &&
//             scrollController.offset <= tab.offsetTo
//             && !tab.selected) {
//           onCategorySelected(i, animationRequired: false);
//           tabController.animateTo(i);
//           break;
//         }
//       }
//     }
//   }
//
//   void onCategorySelected(int index, {bool animationRequired = true}) async{
//     final selected  = tabs[index];
//     for(int i = 0; i <  tabs.length; i++){
//       final condition = selected.category.name == tabs[i].category.name;
//       tabs[i] = tabs[i].copyWith(condition);
//     }
//     notifyListeners();
//
//     if(animationRequired){
//       _listen = false;
//       await scrollController.animateTo(selected.offsetForm,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.linear);
//       _listen = true;
//     }
//   }
//
//
//   //home Scroll
//
//   @override
//   void dispose() {
//     tabController.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }
// }
//
//
//
//
// class TabCategoryDemo{
//   final CategoryModel category;
//   final bool selected;
//   final double offsetForm;
//   final double offsetTo;
//   TabCategoryDemo({@required this.category,@required this.selected, @required this.offsetForm, @required this.offsetTo });
//   TabCategoryDemo copyWith(bool selected) => TabCategoryDemo(category: category, selected: selected, offsetForm: offsetForm, offsetTo:offsetTo);
// }
//
// class DemoProductCategoryItem{
//   final CategoryModel category;
//   final Products products;
//   DemoProductCategoryItem({this.category, this.products});
//   bool get isCategory => category != null;
// }