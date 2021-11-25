import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? SizedBox() : _globalKey.currentState.hideCurrentSnackBar();
        _globalKey.currentState.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Theme.of(context).primaryColor : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? getTranslated('no_connection', _globalKey.currentContext) : getTranslated('connected', _globalKey.currentContext),
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
    _route();

  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Provider.of<SplashProvider>(context, listen: false).initConfig(_globalKey, context).then((bool isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: 1), () async {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false).updateToken();
              await Provider.of<WishListProvider>(context, listen: false).initWishList(context);
              Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, ResponsiveHelper.isMobile(context) ? Routes.getOnBoardingRoute() : Routes.getMainRoute(), (route) => false);
            }
          }

        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Consumer<SplashProvider>(builder: (context, splash, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ResponsiveHelper.isWeb() ? FadeInImage.assetNetwork(
                placeholder: Images.logo,
                width: 250,
                image: splash.baseUrls != null ? '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}' : '',
                imageErrorBuilder: (c, o, s) => Image.asset(Images.logo),
              ) : ResponsiveHelper.isMobile(context) ?  FadeInImage.assetNetwork(
                placeholder: Images.logo,
                height: 80, width: 80,
                image: splash.baseUrls != null ? '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}' : '',
                imageErrorBuilder: (c, o, s) => Image.asset(Images.logo, height: 250, width: 150,),
              ) : ResponsiveHelper.isMobilePhone() ?  FadeInImage.assetNetwork(
                placeholder: Images.logo,
                height: 80, width: 80,
                image: splash.baseUrls != null ? '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}' : '',
                imageErrorBuilder: (c, o, s) => Image.asset(Images.logo, height: 250, width: 150,),
              ) : Image.asset(Images.logo, height: 250, width: 150,),
              SizedBox(height: 30),
              Text(
                ResponsiveHelper.isWeb() ? splash.configModel.restaurantName : AppConstants.APP_NAME,
                style: rubikBold.copyWith(color: Theme.of(context).primaryColor, fontSize: 30),
              ),
            ],
          );
        }),
      ),
    );
  }
}
