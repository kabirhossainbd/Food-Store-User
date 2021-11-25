import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/combo_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class ComboOfferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<ComboOfferProvider>(context, listen: false).getSetMenuList(context, true);

    return Scaffold(
      appBar: CustomAppBar(context: context, title: getTranslated('combo_offer', context)),
      body: Consumer<ComboOfferProvider>(
        builder: (context, combo, child) {
          return combo.comboList != null ? combo.comboList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<ComboOfferProvider>(context, listen: false).getSetMenuList(context, true);
            },
            backgroundColor: Theme.of(context).primaryColor,
            color: ColorResources.COLOR_WHITE,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: combo.comboList.length,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio:  1/1.3,
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 4 : 2),
                      itemBuilder: (context, index) {
                        double _startingPrice;
                        double _endingPrice;
                        if(combo.comboList[index].choiceOptions.length != 0) {
                          List<double> _priceList = [];
                          combo.comboList[index].variations.forEach((variation) => _priceList.add(variation.price));
                          _priceList.sort((a, b) => a.compareTo(b));
                          _startingPrice = _priceList[0];
                          if(_priceList[0] < _priceList[_priceList.length-1]) {
                            _endingPrice = _priceList[_priceList.length-1];
                          }
                        }else {
                          _startingPrice = combo.comboList[index].price;
                        }

                        double _discount = combo.comboList[index].price - PriceConverter.convertWithDiscount(context,
                            combo.comboList[index].price, combo.comboList[index].discount.toDouble(), combo.comboList[index].discountType);

                        bool _isAvailable = DateConverter.isAvailable(combo.comboList[index].availableTimeStarts, combo.comboList[index].availableTimeEnds, context);

                        return InkWell(
                          onTap: () {
                            ResponsiveHelper.isMobile(context) ? showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (con) => CartBottomSheet(
                              product: combo.comboList[index], fromSetMenu: true,
                              callback: (CartModel cartModel) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('added_to_cart', context)), backgroundColor: Colors.green));
                              },
                            )
                            ): showDialog(context: context, builder: (con) => Dialog(
                              child: CartBottomSheet(
                                product: combo.comboList[index], fromSetMenu: true,
                                callback: (CartModel cartModel) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('added_to_cart', context)), backgroundColor: Colors.green));
                                },
                              ),
                            ));
                          },
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: ColorResources.getBackgroundColor(context),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)]
                                ),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                                  Expanded(
                                    flex: 6,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder_image,
                                        fit: BoxFit.fitWidth,
                                        image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${combo.comboList[index].image}',
                                        width: ResponsiveHelper.isMobile(context)
                                            ? 110
                                            : ResponsiveHelper.isTab(context)
                                            ? 140
                                            : ResponsiveHelper.isDesktop(context)
                                            ? 140
                                            : null,
                                        height: ResponsiveHelper.isMobile(context)
                                            ? 120
                                            : ResponsiveHelper.isTab(context)
                                            ? 140
                                            : ResponsiveHelper.isDesktop(context)
                                            ? 140
                                            : null,
                                        imageErrorBuilder: (c, o, s) => Image.asset( Images.placeholder_image),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                        Text(
                                          combo.comboList[index].name,
                                          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                          maxLines: 1, overflow: TextOverflow.ellipsis,
                                        ),

                                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        RatingBar(
                                          rating: combo.comboList[index].rating.length > 0 ? double.parse(combo.comboList[index].rating[0].average) : 0.0,
                                          size: 12,
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${PriceConverter.convertPrice(context, _startingPrice, discount: combo.comboList[index].discount.toDouble(),
                                                  discountType: combo.comboList[index].discountType, asFixed: 1)}''${_endingPrice!= null
                                                  ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: combo.comboList[index].discount.toDouble(),
                                                  discountType: combo.comboList[index].discountType, asFixed: 1)}' : ''}',
                                              style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                            ),
                                            _discount > 0 ? SizedBox() : Icon(Icons.add, color: Theme.of(context).textTheme.bodyText1.color),
                                          ],
                                        ),
                                        _discount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Text(
                                            '${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}'
                                                '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                                            style: rubikBold.copyWith(
                                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                              color: ColorResources.getGreyColor(context),
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                          Icon(Icons.add, color: Theme.of(context).textTheme.bodyText1.color),
                                        ]) : SizedBox(),
                                      ]),
                                    ),
                                  ),

                                ]),
                              ),
                              _isAvailable ? SizedBox() : Positioned(
                                top: 0, left: 0, bottom: ResponsiveHelper.isTab(context) ? 120 : 100, right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  child: Text(getTranslated('not_available_now', context), textAlign: TextAlign.center, style: rubikRegular.copyWith(
                                    color: Colors.white, fontSize: Dimensions.FONT_SIZE_SMALL,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ) : NoDataScreen() : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
