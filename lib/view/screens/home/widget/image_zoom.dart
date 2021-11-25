// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant/data/model/response/product_model.dart';
// import 'package:flutter_restaurant/helper/responsive_helper.dart';
// import 'package:flutter_restaurant/provider/splash_provider.dart';
// import 'package:flutter_restaurant/utill/dimensions.dart';
// import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
// import 'package:provider/provider.dart';
//
// class ProductImageScreen extends StatefulWidget {
//   final Products products;
//   ProductImageScreen({@required this.products});
//
//   @override
//   _ProductImageScreenState createState() => _ProductImageScreenState();
// }
//
// class _ProductImageScreenState extends State<ProductImageScreen> {
//   int pageIndex;
//   PageController _pageController;
//
//   @override
//   void initState() {
//     super.initState();
//    // pageIndex = Provider.of<ProductDetailsProvider>(context, listen: false).imageSliderIndex;
//     _pageController = PageController(initialPage: 1);
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: widget.products.name, isBackButtonExist: true, context: context,),
//       body: SafeArea(
//         child: Container(
//           height: ResponsiveHelper.isMobile(context) ? 320 : 400,
//           width: ResponsiveHelper.isMobile(context) ? 280 : 550,
//           child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 alignment: Alignment.center,
//                 height: ResponsiveHelper.isMobile(context) ? 250 : 300,
//                 width: MediaQuery.of(context).size.width,
//                 padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                 margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
//                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                 child: PhotoViewGallery.builder(
//                   scrollPhysics: const BouncingScrollPhysics(),
//                   builder: (BuildContext context, int index) {
//                     return PhotoViewGalleryPageOptions(
//                       imageProvider: NetworkImage('${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${widget.products.image}'),
//                       initialScale: PhotoViewComputedScale.contained,
//                       heroAttributes: PhotoViewHeroAttributes(tag: index.toString()),
//                     );
//                   },
//                   backgroundDecoration: BoxDecoration(color: ColorResources.getBackgroundColor(context)),
//                   itemCount: 1,
//                   loadingBuilder: (context, event) => Center(
//                     child: Container(
//                       width: 20.0,
//                       height: 20.0,
//                       child: CircularProgressIndicator(
//                         value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes,
//                         valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
//                       ),
//                     ),
//                   ),
//                   pageController: _pageController,
//                   onPageChanged: (int index) {
//                     setState(() {
//                       pageIndex = index;
//                     });
//                   },
//                 ),
//               ),
//               SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
