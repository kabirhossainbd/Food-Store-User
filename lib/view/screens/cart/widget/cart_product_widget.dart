import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  CartProductWidget({@required this.cart, @required this.cartIndex, @required this.isAvailable, @required this.addOns});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ResponsiveHelper.isMobile(context)? showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (con) => CartBottomSheet(
            product: cart.product,
            cartIndex: cartIndex,
            cart: cart,
            callback: (CartModel cartModel) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('updated_in_cart', context)), backgroundColor: Colors.green));
            },
          ),
        ) :
        showDialog(context: context, builder: (con) => Dialog(
          child: CartBottomSheet(
            product: cart.product,
            cartIndex: cartIndex,
            cart: cart,
            callback: (CartModel cartModel) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('updated_in_cart', context)), backgroundColor: Colors.green));
            },
          ),
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          Positioned(
            top: 0, bottom: 0, right: 0, left: 0,
            child: Icon(Icons.delete, color: ColorResources.COLOR_WHITE, size: 50),
          ),
          Dismissible(
            key: Key(cart.variation.length > 0 ? cart.variation[0].type : cart.product.id.toString()),
            onDismissed: (DismissDirection direction) {
              Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
              Provider.of<CartProvider>(context, listen: false).removeFromCart(cartIndex);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: ColorResources.getBackgroundColor(context),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                  blurRadius: 5, spreadRadius: 1,
                )],
              ),
              child: Column(
                children: [

                  Row(children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder_image, height: 70, width: 85, fit: BoxFit.cover,
                            image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${cart.product.image}',
                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 70, width: 85, fit: BoxFit.cover),
                          ),
                        ),
                        isAvailable ? SizedBox() : Positioned(
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
                        Text(cart.product.name, style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                        SizedBox(height: 2),
                        RatingBar(rating: cart.product.rating.length > 0 ? double.parse(cart.product.rating[0].average) : 0.0, size: 12),
                        SizedBox(height: 5),
                        Row(children: [
                          Flexible(
                            child: Text(
                              PriceConverter.convertPrice(context, cart.discountedPrice),
                              style: rubikBold,
                            ),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          cart.discountAmount > 0 ? Flexible(
                            child: Text(PriceConverter.convertPrice(context, cart.discountedPrice+cart.discountAmount), style: rubikBold.copyWith(
                              color: ColorResources.COLOR_GREY,
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              decoration: TextDecoration.lineThrough,
                            )),
                          ) : SizedBox(),
                        ]),
                      ]),
                    ),

                    Container(
                      decoration: BoxDecoration(color: ColorResources.getBackgroundColor(context), borderRadius: BorderRadius.circular(5)),
                      child: Row(children: [
                        InkWell(
                          onTap: () {
                            Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                            if (cart.quantity > 1) {
                              Provider.of<CartProvider>(context, listen: false).setQuantity(false, cart);
                            }else {
                              Provider.of<CartProvider>(context, listen: false).removeFromCart(cartIndex);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Icon(Icons.remove, size: 20),
                          ),
                        ),
                        Text(cart.quantity.toString(), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                        InkWell(
                          onTap: () {
                            Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                            Provider.of<CartProvider>(context, listen: false).setQuantity(true, cart);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Icon(Icons.add, size: 20),
                          ),
                        ),
                      ]),
                    ),

                    !ResponsiveHelper.isMobile(context) ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      child: IconButton(
                        onPressed: () {
                          Provider.of<CouponProvider>(context, listen: false).removeCouponData(true);
                          Provider.of<CartProvider>(context, listen: false).removeFromCart(cartIndex);
                        },
                        icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
                      ),
                    ) : SizedBox(),

                  ]),

                  addOns.length > 0 ? SizedBox(
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                      itemCount: addOns.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                          child: Row(children: [
                            InkWell(
                              onTap: () {
                                Provider.of<CartProvider>(context, listen: false).removeAddOn(cartIndex, index);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor, size: 18),
                              ),
                            ),
                            Text(addOns[index].name, style: rubikRegular),
                            SizedBox(width: 2),
                            Text(PriceConverter.convertPrice(context, addOns[index].price), style: rubikMedium),
                            SizedBox(width: 2),
                            Text('(${cart.addOnIds[index].quantity})', style: rubikRegular),
                          ]),
                        );
                      },
                    ),
                  ) : SizedBox(),

                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
