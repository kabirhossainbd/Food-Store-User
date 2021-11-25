

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  final Color color;
  final double size;
  final bool fromRestaurant;
  CartWidget({@required this.color, @required this.size, this.fromRestaurant = false});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Icon(
        Icons.shopping_cart, size: size,
        color: color,
      ),

      Provider.of<CartProvider>(context).cartList.length > 0 ? Positioned(
          top: -5, right: -5,
          child: Container(
            height: size < 20 ? 10 : size/2, width: size < 20 ? 10 : size/2, alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: fromRestaurant ? ColorResources.COLOR_WHITE : Theme.of(context).primaryColor,
              border: Border.all(width: size < 20 ? 0.7 : 1, color: fromRestaurant ? Theme.of(context).primaryColor : Theme.of(context).cardColor),
            ),
            child: Text(
              Provider.of<CartProvider>(context).cartList.length.toString(),
              style: rubikRegular.copyWith(
                fontSize: size < 20 ? size/3 : size/3.8,
                color: fromRestaurant ? Theme.of(context).primaryColor : ColorResources.COLOR_WHITE,
              ),
            ),
          ),
        ) : SizedBox(),
    ]);
  }
}
