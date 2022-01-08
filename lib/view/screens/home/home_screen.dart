import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/combo_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/restaurant_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_dialog.dart';
import 'package:flutter_restaurant/view/base/main_app_bar.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/checkout/successfull_screen.dart';
import 'package:flutter_restaurant/view/screens/home/widget/banner_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/product_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/combo_offer.dart';
import 'package:flutter_restaurant/view/screens/home/widget/restaurant_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/web_slider.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/options_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();

  Future isNewAlert(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool(AppConstants.IS_FIRST_RUN) ?? true;

    if (isFirstRun) {
      showCupertinoDialog( context: context, builder: (context)=> AnimateDialog(
          icon: Icons.check,
          title: getTranslated('alert', context),
          isFailed: false,
          description: getTranslated('alert_description', context),
          isDescription: true,
          btnText: getTranslated('dismiss', context)),
        barrierDismissible: false,
      );
      prefs.setBool(AppConstants.IS_FIRST_RUN, false);
    } else {
      return null;
    }
  }



  // Future isReviewFirstRun(BuildContext context) async {
  //
  //   if (Provider.of<ThemeProvider>(context, listen: false).isReview) {
  //     showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) =>
  //     ReviewBottomSheet());
  //   } else {
  //     return null;
  //   }
  // }

  Future<void> _loadData(BuildContext context, bool reload) async {

    if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }
    await Provider.of<RestaurantProvider>(context, listen: false).getRestaurant(context, reload);
    await Provider.of<CategoryProvider>(context, listen: false).getCategoryList(context, reload);
    await Provider.of<ComboOfferProvider>(context, listen: false).getSetMenuList(context, reload);
    await Provider.of<BannerProvider>(context, listen: false).getBannerList(context, reload);
  }


  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   isReviewFirstRun(context);
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) =>  isNewAlert(context));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    _loadData(context, false);

    return Scaffold(
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: ColorResources.getBackgroundColor(context),
      drawer: ResponsiveHelper.isTab(context) ? Drawer(child: OptionsView(onTap: null)) : SizedBox(),
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) : null,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadData(context, true);
          },
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          child: Scrollbar(
            controller: _scrollController,
            child: CustomScrollView(controller: _scrollController, slivers: [

              // AppBar
              ResponsiveHelper.isDesktop(context) ? SliverToBoxAdapter(child: SizedBox()) : SliverAppBar(
                floating: true,
                elevation: 0,
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: ColorResources.getBackgroundColor(context),
                pinned: ResponsiveHelper.isTab(context) ? true : false,
                leading: ResponsiveHelper.isTab(context) ? IconButton(
                  onPressed: () => drawerGlobalKey.currentState.openDrawer(),
                  icon: Icon(Icons.menu,color: ColorResources.getTextColor(context)),
                ): null,
                title: Consumer<SplashProvider>(builder:(context, splash, child) => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ResponsiveHelper.isWeb() ? FadeInImage.assetNetwork(
                      placeholder: Images.logo, height: 120, width: 120,
                      image: splash.baseUrls != null ? Provider.of<ThemeProvider>(context).darkTheme ? Images.dark_logo :  '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}' : '',
                      imageErrorBuilder: (c, o, s) => Provider.of<ThemeProvider>(context).darkTheme ? Image.asset(Images.dark_logo, height: 120, width: 120) : Image.asset(Images.logo, height: 120, width: 120),
                    ) : Provider.of<ThemeProvider>(context).darkTheme ? Image.asset(Images.dark_logo, width: 90, height: 90) : Image.asset(Images.logo, width: 90, height: 90),
                    SizedBox(width: 10),
                  ],
                )),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, Routes.getNotificationRoute()),
                    icon: Icon(Icons.notifications, color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                  ResponsiveHelper.isTab(context) ? IconButton(
                    onPressed: () => Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(Icons.shopping_cart, color: Theme.of(context).textTheme.bodyText1.color),
                        Positioned(
                          top: -10, right: -10,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                            child: Center(
                              child: Text(
                                Provider.of<CartProvider>(context).cartList.length.toString(),
                                style: rubikMedium.copyWith(color: Colors.white, fontSize: 8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) : SizedBox(),
                ],
              ),

              // Search Button
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(child: Center(
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, Routes.getSearchRoute()),
                    child: Container(
                      height: 60, width: 1170,
                      color: ColorResources.getBackgroundColor(context),
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(color: ColorResources.getSearchBg(context), borderRadius: BorderRadius.circular(10)),
                        child: Row(children: [
                          Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL), child: Icon(Icons.search, size: 25)),
                          Expanded(child: Text(getTranslated('search_items_here', context), style: rubikRegular.copyWith(fontSize: 12))),
                        ]),
                      ),
                    ),
                  ),
                )),
              ),

              SliverToBoxAdapter(
                child: Center(
                  child: SizedBox(
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      ResponsiveHelper.isDesktop(context) ? Padding(
                        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                        child: WebBannerView(),
                      ): ResponsiveHelper.isDesktop(context) ? SizedBox() : Consumer<BannerProvider>(
                        builder: (context, banner, child) {
                          return banner.bannerList == null ? BannerView() : banner.bannerList.length == 0 ? SizedBox() : BannerView();
                        },
                      ) ,

                      Consumer<RestaurantProvider>(
                        builder: (context, restaurant, child) {
                          return restaurant.restaurantList == null ? RestaurantView() : restaurant.restaurantList.length == 0 ? SizedBox() : RestaurantView();
                        },
                      ),
                      //
                      // InkWell(
                      //   onTap: () {
                      //
                      //     print('GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG${Provider.of<ThemeProvider>(context, listen: false).isReview}');
                      //     if (Provider.of<ThemeProvider>(context, listen: false).isReview) {
                      //       showAnimatedDialog(context, AnimateDialog(
                      //         icon: CupertinoIcons.xmark_octagon_fill,
                      //         title: 'Alert',
                      //         description: 'We want you to have best experience with our food. Our kitchen is a bit far away from your location,'
                      //             'and the food won\'t remain hot and fresh after travelling such a long distance.',
                      //         isFailed: false,
                      //         isDescription: true,
                      //         btnText: 'Dismiss',
                      //       ), dismissible: false, isFlip: true);
                      //       Provider.of<ThemeProvider>(context, listen: false).toggleReview();
                      //       print('TTTTTTTTTTTTLLLLLLLLLLLLLLLLLLLLLLLLLL${Provider.of<ThemeProvider>(context, listen: false).isReview}');
                      //     } else {
                      //       return null;
                      //     }
                      //   },
                      //   child: Container(
                      //     height: 60, child: Text('CLICK', style: rubikRegular.copyWith(fontSize: 50),),
                      //   ),
                      // ),
                      // SizedBox(height: 10,),
                      //
                     // Image.asset(Images.qr_code),

                      // InkWell(
                      //  onTap: (){
                      //    Navigator.push(context, MaterialPageRoute(builder: (_) => OrderSuccessfulScreen()));
                      //  },
                      //   child: Container(
                      //     height: 60, child: Text('Banner', style: rubikRegular.copyWith(fontSize: 20),),
                      //   ),
                      // ),

                      Consumer<ComboOfferProvider>(
                        builder: (context, combo, child) {
                          return combo.comboList == null ? ComboOfferView() : combo.comboList.length == 0 ? SizedBox() : ComboOfferView();
                        },
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: TitleWidget(title: getTranslated('popular_item', context)),
                      ),
                      ProductView(productType: ProductType.POPULAR_PRODUCT, scrollController: _scrollController),

                    ]),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),

    );
  }
}



//ResponsiveHelper

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 60 || oldDelegate.minExtent != 60 || child != oldDelegate.child;
  }
}
