import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/menu_bar.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function onBackPressed;
  final BuildContext context;
  CustomAppBar({@required this.title, this.isBackButtonExist = true, this.onBackPressed, @required this.context});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? Center(
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
                  child: Provider.of<SplashProvider>(context).baseUrls != null?  Consumer<SplashProvider>(
                      builder:(context, splash, child) =>  FadeInImage.assetNetwork(
                        placeholder: Images.logo,
                        image: Provider.of<ThemeProvider>(context).darkTheme  ? Images.dark_logo :  '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}',
                        width: 150, height: 80,
                        imageErrorBuilder: (c, o, s) => Provider.of<ThemeProvider>(context).darkTheme ? Image.asset(Images.dark_logo, width: 120, height: 80) : Image.asset(Images.logo, width: 120, height: 80),
                      )): SizedBox(),
                ),
              ),
              MenuBar(),
            ],
          )
      ),
    ) : AppBar(
      title: Text(title, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getTextColor(context))),
      centerTitle: true,
      leading: isBackButtonExist ? IconButton(
        icon: Icon(Icons.arrow_back_ios),
        color: Theme.of(context).textTheme.bodyText1.color,
        onPressed: () => onBackPressed != null ? onBackPressed() : Navigator.pop(context),
      ) : SizedBox(),
      backgroundColor: ColorResources.getBackgroundColor(context),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, ResponsiveHelper.isDesktop(context) ? 80 : 50);
}
