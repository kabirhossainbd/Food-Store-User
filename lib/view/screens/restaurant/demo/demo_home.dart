// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/data/model/response/category_model.dart';
// import 'package:flutter_restaurant/provider/restaurant_provider.dart';
// import 'package:flutter_restaurant/utill/color_resources.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/view/base/product_widget.dart';
// import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
// import 'package:flutter_restaurant/view/screens/restaurant/demo/data.dart';
// import 'package:flutter_restaurant/view/screens/restaurant/demo/test_c.dart';
// import 'package:flutter_restaurant/view/screens/restaurant/widget/prov_c.dart';
// import 'package:provider/provider.dart';
//
// import 'demo_provider.dart';
//
// class HomeDemo extends StatefulWidget {
//
//   @override
//   _HomePageDemoState createState() => _HomePageDemoState();
// }
//
// class _HomePageDemoState extends State<HomeDemo> with TickerProviderStateMixin {
//
//   final _bloc = RestaruntantProviderDemo();
//
//   @override
//   void initState() {
//     _bloc.init(this, context);
//     super.initState();
//   }
//   @override
//   void dispose() {
//     _bloc.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: ColorResources.getBackgroundColor(context),
//       body: SafeArea(
//         child:AnimatedBuilder(
//           animation: _bloc,
//           builder: (_, __)=> Column(crossAxisAlignment: CrossAxisAlignment.center ,children: [
//             Container(
//               height: 80,
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
//                 Text('HomePage'),
//                 SizedBox(width: 3,),
//                 Container(
//                     height: 60,
//                     width: 50,
//                     child: ClipOval(
//                         child: Image.network('https://picsum.photos/250?image=9')
//                     )
//                 )
//               ]),
//             ),
//             Container(
//               height: 80,
//               child: TabBar(
//                 onTap: (int index) {
//                   _bloc.onCategorySelected(index);
//                 },
//                 indicatorWeight: 0.1,
//                 isScrollable: true,
//                 controller: _bloc.tabController,
//                 tabs: _bloc.tabs.map((e) => TabWidgetDemo(e)).toList(),
//               ),
//             ),
//             Expanded(child: ListView.builder(
//                 controller: _bloc.scrollController,
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 itemCount: _bloc.items.length,
//                 itemBuilder: (context, index) {
//                   final item = _bloc.items[index];
//                   if(item.isCategory){
//                     return CategoryWidget(category: item.category);
//                   }
//                   return ProductWidget(product: item.products);
//                 })
//             )
//           ]),
//         ),
//       ),
//     );
//   }
// }
//
// class TabWidgetDemo extends StatelessWidget {
//   const TabWidgetDemo(this.category);
//   final TabCategoryDemo category;
//   @override
//   Widget build(BuildContext context) {
//     final selected = category.selected;
//     return Opacity(
//       opacity: selected ? 1 : 0.5,
//       child: Card(
//         elevation:selected ? 5 : 0,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(category.category.name, style: TextStyle(fontWeight: FontWeight.bold),),
//         ),
//       ),
//     );
//   }
// }
//
// class CategoryWidget extends StatelessWidget {
//   final CategoryModel category;
//   CategoryWidget({@required this.category});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: categoryHeight,
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       alignment: Alignment.centerLeft,
//       color: Colors.white,
//       child: Text(category.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade500),),
//     );
//   }
// }
//
//
// class ProductCategoryItem{
//   final Category category;
//   final Product products;
//   ProductCategoryItem({this.category, this.products});
//   bool get isCategory => category != null;
// }
