import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/signup_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/main_app_bar.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatelessWidget {
  final String email;
  CreateAccountScreen({@required this.email});

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: MainAppBar(), preferredSize: Size.fromHeight(80)) : null,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              physics: BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: 1170,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        getTranslated('create_account', context),
                        style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 24, color: ColorResources.getGreyBunkerColor(context)),
                      )),
                      SizedBox(height: 20),

                      // for first name section
                      Text(
                        getTranslated('first_name', context),
                        style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        isShowBorder: true,
                        controller: _firstNameController,
                        focusNode: _firstNameFocus,
                        nextFocus: _lastNameFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      // for last name section
                      Text(
                        getTranslated('last_name', context),
                        style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        isShowBorder: true,
                        controller: _lastNameController,
                        focusNode: _lastNameFocus,
                        nextFocus: _numberFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      // for mobile section
                      Text(
                        getTranslated('mobile_number', context),
                        style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        isShowBorder: true,
                        controller: _numberController,
                        focusNode: _numberFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.phone,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                      // for password section
                      Text(
                        getTranslated('password', context),
                        style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        isShowBorder: true,
                        isPassword: true,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        nextFocus: _confirmPasswordFocus,
                        isShowSuffixIcon: true,
                      ),
                      SizedBox(height: 22),

                      // for confirm password section
                      Text(
                        getTranslated('confirm_password', context),
                        style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        isShowBorder: true,
                        isPassword: true,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        isShowSuffixIcon: true,
                        inputAction: TextInputAction.done,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      // for refer section

                      RichText(
                        text: TextSpan(text: '${getTranslated('refer code', context)} : ', style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            children: [
                              TextSpan(
                                  text: '(${getTranslated('optional', context)})',style: rubikRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_SMALL)
                              ),
                            ]),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      CustomTextField(
                        isShowBorder: true,
                        controller: _referController,
                        focusNode: _referFocus,
                        inputType: TextInputType.text,
                        inputAction: TextInputAction.done,
                      ),


                      SizedBox(height: 22),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authProvider.registrationErrorMessage.length > 0
                              ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                              : SizedBox.shrink(),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authProvider.registrationErrorMessage ?? "",
                              style: Theme.of(context).textTheme.headline2.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          )
                        ],
                      ),

                      // for signup button
                      SizedBox(height: 10),
                      !authProvider.isLoading
                          ? CustomButton(
                              btnTxt: getTranslated('signup', context),
                              onTap: () {
                                String _firstName = _firstNameController.text.trim();
                                String _lastName = _lastNameController.text.trim();
                                String _number = _numberController.text.trim();
                                String _password = _passwordController.text.trim();
                                String _confirmPassword = _confirmPasswordController.text.trim();
                                String _refer = _referController.text.trim();
                                if (_firstName.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_first_name', context), context);
                                }else if (_lastName.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_last_name', context), context);
                                }else if (_number.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                }else if (_password.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_password', context), context);
                                }else if (_password.length < 6) {
                                  showCustomSnackBar(getTranslated('password_should_be', context), context);
                                }else if (_confirmPassword.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_confirm_password', context), context);
                                }else if(_password != _confirmPassword) {
                                  showCustomSnackBar(getTranslated('password_did_not_match', context), context);
                                }else {
                                  SignUpModel signUpModel = SignUpModel(
                                    fName: _firstName,
                                    lName: _lastName,
                                    email: email,
                                    password: _password,
                                    phone: _number,
                                    refer_id: _refer,
                                  );
                                  authProvider.registration(signUpModel).then((status) async {
                                    if (status.isSuccess) {
                                      await Provider.of<WishListProvider>(context, listen: false).initWishList(context);
                                      Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                    }
                                  });
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                            )),

                      // for already an account
                      SizedBox(height: 11),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, Routes.getLoginRoute());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getTranslated('already_have_account', context),
                                style: Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyColor(context)),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Text(
                                getTranslated('login', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyBunkerColor(context)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
