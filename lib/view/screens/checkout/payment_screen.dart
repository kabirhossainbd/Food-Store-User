import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/cancel_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel orderModel;
  final bool fromCheckout;
  PaymentScreen({@required this.orderModel, @required this.fromCheckout});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedUrl;
  double value = 0.0;
  bool _isLoading = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController controllerGlobal;

  @override
  void initState() {
    super.initState();
    selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?customer_id=${widget.orderModel.userId}&order_id=${widget.orderModel.id}';

   if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) => Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: CustomAppBar(context: context, title: getTranslated('PAYMENT', context), onBackPressed: () => Navigator.pop(context)),
        bottomSheet: Container(
         height: 60,
        // padding: EdgeInsets.all(12),
         margin: EdgeInsets.all(12),
         child: !order.isLoading ? Row(children: [
           Expanded(child: SizedBox(
             height: 50,
             child: TextButton(
               onPressed: () {
                 Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
               },
               style: TextButton.styleFrom(
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
               ),
               child: Text(getTranslated('home', context), style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
             ),
           )),
           SizedBox(width: 10),
           Expanded(
               child:CustomButton(btnTxt: 'Cash On Delivery',
               onTap: () => order.updateCOD(widget.orderModel.id.toString(), context, false),
               )),
         ]) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),

       ),
        body: Center(
          child:Container(
            width: 1170,
            child: Stack(
              children: [
                WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: selectedUrl,
                  gestureNavigationEnabled: true,
                  userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.future.then((value) => controllerGlobal = value);
                    _controller.complete(webViewController);
                  },
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                    setState(() {
                      _isLoading = true;
                    });
                    bool _isSuccess = url.contains('success') && url.contains(AppConstants.BASE_URL);
                    bool _isFailed = url.contains('fail') && url.contains(AppConstants.BASE_URL);
                    bool _isCancel = url.contains('cancel') && url.contains(AppConstants.BASE_URL);
                    if(_isSuccess){
                      Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/${widget.orderModel.id}/payment-success');
                    }else if(_isFailed) {
                      Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/${widget.orderModel.id}/payment-fail');
                    }else if(_isCancel) {
                      Navigator.pushReplacementNamed(context, '${Routes.ORDER_SUCCESS_SCREEN}/${widget.orderModel.id}/payment-cancel');
                    }
                  },
                  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                _isLoading ? Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                ) : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<bool> _exitApp(BuildContext context) async {
  //   if (await controllerGlobal.canGoBack()) {
  //     controllerGlobal.goBack();
  //     return Future.value(false);
  //   } else {
  //     return showDialog(context: context, builder: (context) => CancelDialog(orderID: widget.orderModel.id, fromCheckout: widget.fromCheckout));
  //   }
  // }
}
