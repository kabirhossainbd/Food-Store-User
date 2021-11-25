import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class AnimateDialog extends StatelessWidget {
  final bool isFailed;
  final double rotateAngle;
  final IconData icon;
  final String title;
  final String description;
  final bool isDescription;
  final String btnText;
  AnimateDialog({this.isFailed = false, this.rotateAngle = 0, @required this.icon, @required this.title, this.description, this.isDescription = false, @required this.btnText});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 400,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(
            left: 0, right: 0, top: -55,
            child: Container(
              height: 80,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: isFailed ? Theme.of(context).primaryColor : Theme.of(context).primaryColor, shape: BoxShape.circle),
              child: Transform.rotate(angle: rotateAngle, child: Icon(icon, size: 40, color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.center, children: [
              Center(
                child: Text(title, textAlign: TextAlign.center, style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,)),
              ),
              isDescription ? SizedBox(height: Dimensions.PADDING_SIZE_SMALL) : SizedBox(),
              isDescription ? Text(description, textAlign: TextAlign.center, style: rubikRegular) : SizedBox(),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Center(
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(btnText, textAlign: TextAlign.center, style: rubikMedium.copyWith(color: ColorResources.COLOR_WHITE, fontSize: Dimensions.FONT_SIZE_DEFAULT),)),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
