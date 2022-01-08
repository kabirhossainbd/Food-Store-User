import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/restaurant_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/view/screens/restaurant/demo/data.dart';
import 'package:flutter_restaurant/view/screens/restaurant/demo/test_c.dart';
import 'package:provider/provider.dart';

class HomeDemo extends StatefulWidget {

  @override
  _HomePageDemoState createState() => _HomePageDemoState();
}

class _HomePageDemoState extends State<HomeDemo> with TickerProviderStateMixin {


  @override
  void initState() {
    Provider.of<RestaruntantProviderDemo>(context, listen: false).init(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorResources.getBackgroundColor(context),
      body: SafeArea(
        child:Consumer<RestaruntantProviderDemo>(
          builder: (context, resProv, child) {


            TabController tabController;
            List<TabCategoryDemo> tabs = [];
            List<ProductCategoryItem> items = [];
            ScrollController scrollController = ScrollController();
            bool _listen = true;


            // void init(TickerProvider ticker){
            //   tabController = TabController(length: rappiCategories.length, vsync: ticker);

              double offsetForm = 0.0;
              double offsetTo = 0.0;
              for(int i = 0; i <  rappiCategories.length; i++){
                final category =  rappiCategories[i];

                if(i > 0){
                  offsetForm += rappiCategories[i - 1].products.length * productHeight;
                }
                if(i < rappiCategories.length -1){
                  offsetTo = offsetForm + rappiCategories[i + 1].products.length * productHeight;
                }else{
                  offsetTo = double.infinity;
                }
                tabs.add(TabCategoryDemo(
                    category: category,
                    selected: (i == 0),
                    offsetForm: categoryHeight * i + offsetForm,
                    offsetTo: offsetTo));
                items.add(ProductCategoryItem(category: category));
                for( int j = 0; j< category.products.length; j++){
                  final product = category.products[j];
                  items.add(ProductCategoryItem(products: product));
                }
              }
            //   scrollController.addListener(_onScrollingListener);
            // }



            // void _onScrollingListener() {
            //   if (_listen) {
            //     for (int i = 0; i < tabs.length; i++) {
            //       final tab = tabs[i];
            //       if (scrollController.offset >= tab.offsetForm &&
            //           scrollController.offset <= tab.offsetTo
            //           && !tab.selected) {
            //         onCategorySelected(i, animationRequired: false);
            //         tabController.animateTo(i);
            //         break;
            //       }
            //     }
            //   }
            // }

            void onCategorySelected(int index, {bool animationRequired = true}) async{
              final selected  = tabs[index];
              for(int i = 0; i <  tabs.length; i++){
                final condition = selected.category.name == tabs[i].category.name;
                tabs[i] = tabs[i].copyWith(condition);
              }

              if(animationRequired){
                _listen = false;
                await scrollController.animateTo(selected.offsetForm,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
                _listen = true;
              }
            }


            //home Scroll

            return  Column(crossAxisAlignment: CrossAxisAlignment.center ,children: [
              Container(
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

                  Text('HomePage'),
                  SizedBox(width: 3,),
                  Container(
                      height: 60,
                      width: 50,
                      child: ClipOval(
                          child: Image.network('https://picsum.photos/250?image=9')
                      )
                  )
                ]),
              ),
              Container(
                height: 80,
                child: TabBar(
                  onTap: onCategorySelected,
                  indicatorWeight: 0.1,
                  isScrollable: true,
                  controller: TabController(length: rappiCategories.length, vsync: this),
                  tabs: tabs.map((e) => TabWidgetDemo(e)).toList(),
                ),
              ),
              Expanded(child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    if(item.isCategory){
                      return CategoryWidget(category: item.category);
                    }
                    return ProductWidgetDemo(product: item.products);
                  })
              )
            ]);

            },
        ),
      ),
    );
  }
}

class TabWidgetDemo extends StatelessWidget {
  const TabWidgetDemo(this.category);
  final TabCategoryDemo category;
  @override
  Widget build(BuildContext context) {
    final selected = category.selected;
    return Opacity(
      opacity: selected ? 1 : 0.5,
      child: Card(
        elevation:selected ? 5 : 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(category.category.name, style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final Category category;
  CategoryWidget({@required this.category});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: categoryHeight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: Text(category.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade500),),
    );
  }
}

class ProductWidgetDemo extends StatelessWidget {
  final Product product;
  ProductWidgetDemo({@required this.product});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: productHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Card(
            elevation: 6,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            child: Row( crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(product.image),
                ),
                Expanded(
                  child: Column( mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(product.description, style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(product.price.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}


class ProductCategoryItem{
  final Category category;
  final Product products;
  ProductCategoryItem({this.category, this.products});
  bool get isCategory => category != null;
}
