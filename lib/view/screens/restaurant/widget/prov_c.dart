// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/provider/restaurant_provider.dart';
// import 'package:flutter_restaurant/view/screens/restaurant/demo/data.dart';
// import 'package:flutter_restaurant/view/screens/restaurant/demo/home_demo.dart';
//
// import '../all_restaurant_screen.dart';
//
//
// class RestaruntantProvScroll with ChangeNotifier{
//
//   TabController tabController;
//   List<TabCategoryScroll> tabs = [];
//   List<ProductCategoryItem> items = [];
//   ScrollController scrollController = ScrollController();
//   bool _listen = true;
//
//
//   void init(TickerProvider ticker){
//     tabController = TabController(length: rappiCategories.length, vsync: ticker);
//
//     double offsetForm = 0.0;
//     double offsetTo = 0.0;
//     for(int i = 0; i <  rappiCategories.length; i++){
//       final category =  rappiCategories[i];
//
//       if(i > 0){
//         offsetForm += rappiCategories[i - 1].products.length * productHeight;
//       }
//       if(i < rappiCategories.length -1){
//         offsetTo = offsetForm + rappiCategories[i + 1].products.length * productHeight;
//       }else{
//         offsetTo = double.infinity;
//       }
//       tabs.add(TabCategoryScroll(
//           category: category,
//           selected: (i == 0),
//           offsetForm: categoryHeight * i + offsetForm,
//           offsetTo: offsetTo));
//       items.add(ProductCategoryItem(category: category));
//       for( int j = 0; j< category.products.length; j++){
//         final product = category.products[j];
//         items.add(ProductCategoryItem(products: product));
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
//   void homeInit(TickerProvider ticker){
//
//     double offsetForm = 0.0;
//     double offsetTo = 0.0;
//     for(int i = 0; i <  rappiCategories.length; i++){
//       final category =  rappiCategories[i];
//
//       if(i > 0){
//         offsetForm += rappiCategories[i - 1].products.length * productHeight;
//       }
//       if(i < rappiCategories.length -1){
//         offsetTo = offsetForm + rappiCategories[i + 1].products.length * productHeight;
//       }else{
//         offsetTo = double.infinity;
//       }
//       tabs.add(TabCategoryScroll(
//           category: category,
//           selected: (i == 0),
//           offsetForm: categoryHeight * i + offsetForm,
//           offsetTo: offsetTo));
//       items.add(ProductCategoryItem(category: category));
//       for( int j = 0; j< category.products.length; j++){
//         final product = category.products[j];
//         items.add(ProductCategoryItem(products: product));
//       }
//     }
//     scrollController.addListener(_onScrollingListener);
//   }
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
// class TabCategoryScroll{
//   final Category category;
//   final bool selected;
//   final double offsetForm;
//   final double offsetTo;
//   TabCategoryScroll({@required this.category,@required this.selected, @required this.offsetForm, @required this.offsetTo });
//   TabCategoryScroll copyWith(bool selected) => TabCategoryScroll(category: category, selected: selected, offsetForm: offsetForm, offsetTo:offsetTo);
// }