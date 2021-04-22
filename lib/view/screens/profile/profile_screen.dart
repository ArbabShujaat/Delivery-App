import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FocusNode _firstNameFocus;
  FocusNode _lastNameFocus;
  FocusNode _emailFocus;
  FocusNode _phoneNumberFocus;
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  File file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _choose() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameFocus = FocusNode();
    _lastNameFocus = FocusNode();
    _emailFocus = FocusNode();
    _phoneNumberFocus = FocusNode();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();

    if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel !=
        null) {
      UserInfoModel _userInfoModel =
          Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
      _firstNameController.text = _userInfoModel.fName ?? '';
      _lastNameController.text = _userInfoModel.lName ?? '';
      _phoneNumberController.text = _userInfoModel.phone ?? '';
      _emailController.text = _userInfoModel.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffdcfdff),
                Color(0xffffffff),
              ]),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              CustomAppBar(title: getTranslated('my_profile', context)),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_LARGE),
                child: Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    return profileProvider.userInfoModel != null
                        ? ListView(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            children: [
                              // for profile image
                              Container(
                                margin: EdgeInsets.only(top: 42, bottom: 24),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: ColorResources.COLOR_PRIMARY,
                                  border: Border.all(
                                      color: ColorResources.COLOR_PRIMARY,
                                      width: 3),
                                  shape: BoxShape.circle,
                                ),
                                child: InkWell(
                                  onTap: _choose,
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: file == null
                                            ? FadeInImage.assetNetwork(
                                                placeholder:
                                                    Images.placeholder_user,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                image:
                                                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profileProvider.userInfoModel.image}',
                                              )
                                            : Image.file(file,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.fill),
                                      ),
                                      Positioned(
                                        bottom: 15,
                                        right: -10,
                                        child: Image.asset(Images.edit),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // for name
                              Center(
                                  child: Text(
                                '${profileProvider.userInfoModel.fName} ${profileProvider.userInfoModel.lName}',
                                style: rubikMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                    color: ColorResources.COLOR_PRIMARY),
                              )),

                              SizedBox(height: 28),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // for first name section
                                    Text(
                                      getTranslated('first_name', context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                              color:
                                                  ColorResources.getHintColor(
                                                      context)),
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL),
                                    CustomTextField(
                                      hintText: 'John',
                                      isShowBorder: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      controller: _firstNameController,
                                      focusNode: _firstNameFocus,
                                      nextFocus: _lastNameFocus,
                                      inputType: TextInputType.name,
                                      capitalization: TextCapitalization.words,
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_LARGE),

                                    // for last name section
                                    Text(
                                      getTranslated('last_name', context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                              color:
                                                  ColorResources.getHintColor(
                                                      context)),
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL),
                                    CustomTextField(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      hintText: 'Doe',
                                      isShowBorder: true,
                                      controller: _lastNameController,
                                      focusNode: _lastNameFocus,
                                      nextFocus: _emailFocus,
                                      inputType: TextInputType.name,
                                      capitalization: TextCapitalization.words,
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_LARGE),

                                    // for email section
                                    Text(
                                      getTranslated('email', context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                              color:
                                                  ColorResources.getHintColor(
                                                      context)),
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL),
                                    CustomTextField(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      hintText:
                                          getTranslated('demo_gmail', context),
                                      isShowBorder: true,
                                      controller: _emailController,
                                      isEnabled: false,
                                      focusNode: _emailFocus,
                                      nextFocus: _phoneNumberFocus,
                                      inputType: TextInputType.emailAddress,
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_LARGE),

                                    // for phone Number section
                                    Text(
                                      getTranslated('mobile_number', context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                              color:
                                                  ColorResources.getHintColor(
                                                      context)),
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL),
                                    CustomTextField(
                                      hintText:
                                          getTranslated('number_hint', context),
                                      isShowBorder: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      controller: _phoneNumberController,
                                      focusNode: _phoneNumberFocus,
                                      inputType: TextInputType.phone,
                                      inputAction: TextInputAction.done,
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_LARGE),
                                  ],
                                ),
                              ),

                              !profileProvider.isLoading
                                  ? CustomButton(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      btnTxt: getTranslated(
                                          'update_profile', context),
                                      onTap: () async {
                                        if (profileProvider
                                                    .userInfoModel.fName ==
                                                _firstNameController.text &&
                                            profileProvider
                                                    .userInfoModel.lName ==
                                                _lastNameController.text &&
                                            profileProvider
                                                    .userInfoModel.phone ==
                                                _phoneNumberController.text &&
                                            profileProvider
                                                    .userInfoModel.email ==
                                                _emailController.text &&
                                            file == null) {
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Change something to update'),
                                                  backgroundColor:
                                                      ColorResources
                                                          .COLOR_PRIMARY));
                                        } else {
                                          UserInfoModel updateUserInfoModel =
                                              profileProvider.userInfoModel;
                                          updateUserInfoModel.fName =
                                              _firstNameController.text ?? "";
                                          updateUserInfoModel.lName =
                                              _lastNameController.text ?? "";
                                          updateUserInfoModel.phone =
                                              _phoneNumberController.text ?? '';

                                          ResponseModel _responseModel =
                                              await profileProvider
                                                  .updateUserInfo(
                                            updateUserInfoModel,
                                            file,
                                            Provider.of<AuthProvider>(context,
                                                    listen: false)
                                                .getUserToken(),
                                          );
                                          if (_responseModel.isSuccess) {
                                            profileProvider
                                                .getUserInfo(context);
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Updated Successfully'),
                                                    backgroundColor:
                                                        Colors.green));
                                          } else {
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        _responseModel.message),
                                                    backgroundColor:
                                                        Colors.red));
                                          }
                                          setState(() {});
                                        }
                                      },
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  ColorResources
                                                      .COLOR_PRIMARY))),
                            ],
                          )
                        : Center(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    ColorResources.COLOR_PRIMARY)));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
