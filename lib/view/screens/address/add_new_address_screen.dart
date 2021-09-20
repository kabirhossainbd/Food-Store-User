import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:provider/provider.dart';

class AddNewAddressScreen extends StatelessWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel address;
  AddNewAddressScreen({this.isEnableUpdate = false, this.address, this.fromCheckout = false});

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final List<Branches> _branches = [];

  @override
  Widget build(BuildContext context) {
    _branches.addAll(Provider.of<SplashProvider>(context, listen: false).configModel.branches);
    Provider.of<LocationProvider>(context, listen: false).initializeAllAddressType(context: context);
    Provider.of<LocationProvider>(context, listen: false).updateAddressStatusMessae(message: '');
    Provider.of<LocationProvider>(context, listen: false).updateErrorMessage(message: '');

    if (isEnableUpdate && address != null) {
     // Provider.of<LocationProvider>(context, listen: false).updatePosition(CameraPosition(target: LatLng(double.parse(address.latitude), double.parse(address.longitude))));
      _locationController.text = '${address.address}';
      _contactPersonNameController.text = '${address.contactPersonName}';
      _contactPersonNumberController.text = '${address.contactPersonNumber}';
      if (address.addressType == 'Home') {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(0);
      } else if (address.addressType == 'Workplace') {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(1);
      } else {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(2);
      }
    }

    return Scaffold(
      appBar: CustomAppBar(context: context, title: isEnableUpdate ? getTranslated('update_address', context) : getTranslated('add_new_address', context)),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {

            return Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                        child: SizedBox(
                          width: 1170,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // for label us
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0),
                                child: Text(
                                  getTranslated('label_us', context),
                                  style:
                                  Theme.of(context).textTheme.headline3.copyWith(color: ColorResources.getGreyBunkerColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                                ),
                              ),

                              Container(
                                height: 50,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: locationProvider.getAllAddressType.length,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      locationProvider.updateAddressIndex(index);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT, horizontal: Dimensions.PADDING_SIZE_LARGE),
                                      margin: EdgeInsets.only(right: 17),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          border: Border.all(
                                              color:
                                              locationProvider.selectAddressIndex == index ? Theme.of(context).primaryColor : ColorResources.BORDER_COLOR),
                                          color: locationProvider.selectAddressIndex == index ? Theme.of(context).primaryColor : ColorResources.SEARCH_BG),
                                      child: Text(
                                        locationProvider.getAllAddressType[index],
                                        style: Theme.of(context).textTheme.headline2.copyWith(
                                            color: locationProvider.selectAddressIndex == index ? ColorResources.COLOR_WHITE : ColorResources.COLOR_BLACK),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0),
                                child: Text(
                                  getTranslated('delivery_address', context),
                                  style:
                                  Theme.of(context).textTheme.headline3.copyWith(color: ColorResources.getGreyBunkerColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                                ),
                              ),

                              // for Address Field
                              Text(
                                getTranslated('address_line_01', context),
                                style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              CustomTextField(
                                hintText: getTranslated('address_line_02', context),
                                isShowBorder: true,
                                inputType: TextInputType.streetAddress,
                                inputAction: TextInputAction.next,
                                focusNode: _addressNode,
                                nextFocus: _nameNode,
                                controller: _locationController,
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              // for Contact Person Name
                              Text(
                                getTranslated('contact_person_name', context),
                                style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              CustomTextField(
                                hintText: getTranslated('enter_contact_person_name', context),
                                isShowBorder: true,
                                inputType: TextInputType.name,
                                controller: _contactPersonNameController,
                                focusNode: _nameNode,
                                nextFocus: _numberNode,
                                inputAction: TextInputAction.next,
                                capitalization: TextCapitalization.words,
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              // for Contact Person Number
                              Text(
                                getTranslated('contact_person_number', context),
                                style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              CustomTextField(
                                hintText: getTranslated('enter_contact_person_number', context),
                                isShowBorder: true,
                                inputType: TextInputType.phone,
                                inputAction: TextInputAction.done,
                                focusNode: _numberNode,
                                controller: _contactPersonNumberController,
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              SizedBox(
                                height: Dimensions.PADDING_SIZE_DEFAULT,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                locationProvider.addressStatusMessage != null
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    locationProvider.addressStatusMessage.length > 0 ? CircleAvatar(backgroundColor: Colors.green, radius: 5) : SizedBox.shrink(),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        locationProvider.addressStatusMessage ?? "",
                        style:
                        Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.green, height: 1),
                      ),
                    )
                  ],
                )
                    : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    locationProvider.errorMessage.length > 0
                        ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                        : SizedBox.shrink(),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        locationProvider.errorMessage ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor, height: 1),
                      ),
                    )
                  ],
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                Container(
                  height: 50.0,
                  width: 1170,
                  child: !locationProvider.isLoading ? CustomButton(
                    btnTxt: isEnableUpdate ? getTranslated('update_address', context) : getTranslated('save_location', context),
                    onTap: locationProvider.loading ? null : () {

                        AddressModel addressModel = AddressModel(
                          addressType: locationProvider.getAllAddressType[locationProvider.selectAddressIndex],
                          contactPersonName: _contactPersonNameController.text ?? '',
                          contactPersonNumber: _contactPersonNumberController.text ?? '',
                          address: _locationController.text ?? '',
                          latitude: '0',
                          longitude: '0',
                          id: 0,
                          userId: 0,
                        );
                        if (isEnableUpdate) {
                          addressModel.id = address.id;
                          addressModel.userId = address.userId;
                          addressModel.method = 'put';
                          locationProvider.updateAddress(context, addressModel: addressModel, addressId: addressModel.id).then((value) {});
                        } else {
                          locationProvider.addAddress(addressModel).then((value) {
                            if (value.isSuccess) {
                              if (fromCheckout) {
                                Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
                                Provider.of<OrderProvider>(context, listen: false).setAddressIndex(0);
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.message), backgroundColor: Colors.green));
                                Navigator.pop(context);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.message), backgroundColor: Colors.red));
                            }
                          });
                        }
                      },
                  )
                      : Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      )),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
