import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:provider/provider.dart';

class ReviewBottomSheet extends StatefulWidget {

  @override
  _ReviewBottomSheetState createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {


  final TextEditingController _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          decoration: BoxDecoration(
            color: ColorResources.getBackgroundColor(context),
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [


            Row(
              children: [
                Expanded(child: Text('How was your experience with previous order?', style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),)),
                IconButton(
                  icon: Icon(Icons.cancel, color: Theme.of(context).primaryColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Divider(height: 5),

            // Rate
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Container(
                height: 30,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Icon(
                        CupertinoIcons.star,
                        size: 30,
                        color: productProvider.ratting < (index+1) ? ColorResources.getGreyColor(context)
                            : Theme.of(context).primaryColor,
                      ),
                      onTap: () => productProvider.getRating(index+1),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: CustomTextField(
                maxLines: 2,
                controller: _controller,
                inputAction: TextInputAction.done,
                fillColor: ColorResources.getSearchBg(context),
              ),
            ),

            productProvider.errorText != null ? Text(productProvider.errorText,
                style: rubikBold.copyWith(color: Colors.red)) : SizedBox.shrink(),

            Builder(
              builder: (context) => ! productProvider.isLoading ? Padding(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                child: CustomButton(
                  btnTxt: 'Submit',
                  onTap: () {
                    if(productProvider.ratting == 0) {
                      productProvider.setErrorText('Add a rating');
                    }else if(_controller.text.isEmpty) {
                      productProvider.setErrorText('Write something');
                    }else {
                      productProvider.setErrorText('');
                      ReviewBody reviewBody = ReviewBody(
                        productId: '18',
                        rating: productProvider.ratting.toString(),
                        comment: _controller.text.isEmpty ? '' : _controller.text,
                        orderId: '10089',
                      );
                      productProvider.submitHomeReview(reviewBody).then((value) {
                        if(value.isSuccess) {
                          Navigator.pop(context);
                          showCustomSnackBar('Review submitted successfully', context, isError: false);
                          Provider.of<ThemeProvider>(context, listen: false).setReview(false);
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          _controller.clear();
                        }else {
                          productProvider.setErrorText(value.message);
                        }
                      });
                    }
                  },
                ),
              ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
            ),

          ]),
        ); },
    );
  }
}
