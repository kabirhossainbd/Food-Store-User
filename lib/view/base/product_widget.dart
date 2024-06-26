import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Products product;
  ProductWidget({@required this.product});

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    double _startingPrice;
    double _endingPrice;
    if(product.choiceOptions.length != 0) {
      List<double> _priceList = [];
      product.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if(_priceList[0] < _priceList[_priceList.length-1]) {
        _endingPrice = _priceList[_priceList.length-1];
      }
    }else {
      _startingPrice = product.price.toDouble();
    }

    double _discountedPrice = PriceConverter.convertWithDiscount(context, product.price.toDouble(), product.discount.toDouble(), product.discountType);
    bool _isAvailable = DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds, context);

    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: InkWell(
        onTap: () {
         ResponsiveHelper.isMobile(context) ? showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (con) => CartBottomSheet(
                product: product,
                callback: (CartModel cartModel) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('added_to_cart', context)), backgroundColor: Colors.green));
                },
              ),
          ): showDialog(context: context, builder: (con) => Dialog(
             child: CartBottomSheet(
               product: product,
               callback: (CartModel cartModel) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('added_to_cart', context)), backgroundColor: Colors.green));
               },
             ),
         )) ;
        },
        child: Container(
          height: 85,
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: ColorResources.getBackgroundColor(context),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(
              color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
              blurRadius: 5, spreadRadius: 1,
            )],
          ),
          child: Row(children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder_image, height: 85, width: 85,
                    image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}',
                    imageErrorBuilder: (c, o, s) => Image.asset( Images.placeholder_image),

                 ),
                ),
                _isAvailable ? SizedBox() : Positioned(
                  top: 0, left: 0, bottom: 0, right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                    child: Text(getTranslated('not_available_now_break', context), textAlign: TextAlign.center, style: rubikRegular.copyWith(
                      color: Colors.white, fontSize: 8,
                    )),
                  ),
                ),
              ],
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                SelectableText(product.name, style: rubikMedium, maxLines: 1,  scrollPhysics: NeverScrollableScrollPhysics()),
                SizedBox(height: 4),
                RatingBar(rating: product.rating.length > 0 ? double.parse(product.rating[0].average) : 0.0, size: 10),
                SizedBox(height: 4),
                Text(
                  '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount.toDouble(), discountType: product.discountType)}'
                      '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount.toDouble(),
                      discountType: product.discountType)}' : ''}',
                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                ),
                product.price > _discountedPrice ? Text('${PriceConverter.convertPrice(context, _startingPrice)}'
                    '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}', style: rubikMedium.copyWith(
                  color: ColorResources.COLOR_GREY,
                  decoration: TextDecoration.lineThrough,
                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                )) : SizedBox(),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Consumer<WishListProvider>(builder:
                  (context, wishList, child) {
                  return InkWell(
                  onTap: () {
                    if(!_isLoggedIn){
                      showDialog(context: context, builder: (context) => NotLoggedInScreen(isFav: true,));
                    } else{
                      wishList.wishIdList.contains(product.id) ?  wishList.removeFromWishList(product, (message) {}) : wishList.addToWishList(product, (message) {});
                    }
                      },
                  child: Icon(
                    wishList.wishIdList.contains(product.id) ? Icons.favorite : Icons.favorite_border,
                    color: wishList.wishIdList.contains(product.id) ? Theme.of(context).primaryColor : ColorResources.COLOR_GREY,
                  ),
                );
              }),
              Expanded(child: SizedBox()),
              Icon(Icons.add),
            ]),
          ]),
        ),
      ),
    );
  }
}
