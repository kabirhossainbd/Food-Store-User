import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/menu_bar.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: ColorResources.getBackgroundColor(context),
        width: 1170,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, Routes.getMainRoute()),
                child: Provider.of<SplashProvider>(context).baseUrls != null ?  Consumer<SplashProvider>(
                    builder:(context, splash, child) => FadeInImage.assetNetwork(
                      placeholder: Images.logo,
                      image: Provider.of<ThemeProvider>(context).darkTheme  ? Images.dark_logo :  '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}',
                      width: 120, height: 400,
                      imageErrorBuilder: (c, o, s) => Provider.of<ThemeProvider>(context).darkTheme ? Image.asset(Images.dark_logo, width: 180, height: 180) : Image.asset(Images.logo, width: 120, height: 180),
                    )): SizedBox(),
              ),
            ),
            MenuBar(),
          ],
        )
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}
