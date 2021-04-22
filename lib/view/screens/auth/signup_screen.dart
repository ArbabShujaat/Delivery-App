import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/auth/create_account_screen.dart';
import 'package:flutter_restaurant/view/screens/auth/login_screen.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/verification_screen.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

class SignUpScreen extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffffffff),
                Color(0xffdcfdff),
              ]),
        ),
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Container(
          width: width * 0.75,
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) => ListView(
              physics: BouncingScrollPhysics(),
              children: [
                // SizedBox(height: ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    Images.logo,
                    height: height * 0.15,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: width * 0.6,
                  height: height * 0.05,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomButton(
                            textColor: true,
                            transparent: true,
                            width: width * 0.3,
                            btnTxt: 'Login',
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => LoginScreen()));
                            },
                            backgroundColor: Colors.transparent,
                          ),
                          CustomButton(
                            width: width * 0.3,
                            btnTxt: 'Signup',
                            onTap: () {},
                            backgroundColor: ColorResources.COLOR_PRIMARY,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Text(
                  'Name',
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: ColorResources.getHintColor(context)),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  hintText: 'Madhu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                  isShowBorder: true,
                  // inputAction: TextInputAction.done,
                  inputType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                SizedBox(height: 10),
                Text(
                  'Email',
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: ColorResources.getHintColor(context)),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  hintText: 'Madhu@gmail.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                  isShowBorder: true,
                  // inputAction: TextInputAction.done,
                  // inputType: TextInputType.emailAddress,
                  // controller: _emailController,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Phone Number',
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: ColorResources.getHintColor(context)),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  hintText: 'Madhu@gmail.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                  isShowBorder: true,
                  // inputAction: TextInputAction.done,
                  // inputType: TextInputType.emailAddress,
                  // controller: _emailController,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Password',
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: ColorResources.getHintColor(context)),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  hintText: '+91 9003471243',
                  isPassword: true,
                  // focusNode: _passwordFocus,
                  // nextFocus: _confirmPasswordFocus,
                  isShowSuffixIcon: false,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                  // inputAction: TextInputAction.next,
                  // controller: _passwordController,
                ),
                SizedBox(height: 10),
                // for confirm password section
                Text(
                  'Confirm Password',
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: ColorResources.getHintColor(context)),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                CustomTextField(
                  hintText: '+91 9003471243',
                  isShowBorder: true,
                  isPassword: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                  isShowSuffixIcon: false,
                  // focusNode: _confirmPasswordFocus,
                  // controller: _confirmPasswordController,
                  // inputAction: TextInputAction.done,
                ),

                SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    authProvider.verificationMessage.length > 0
                        ? CircleAvatar(
                            backgroundColor:
                                ColorResources.getPrimaryColor(context),
                            radius: 5)
                        : SizedBox.shrink(),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        authProvider.verificationMessage ?? "",
                        style: Theme.of(context).textTheme.headline2.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: ColorResources.getPrimaryColor(context),
                            ),
                      ),
                    )
                  ],
                ),
                // for continue button
                SizedBox(height: 12),
                !authProvider.isPhoneNumberVerificationButtonLoading
                    ? CustomButton(
                        width: width * 0.5,
                        height: height * 0.06,
                        btnTxt: 'Signup',
                        onTap: () {
                          authProvider
                              .checkEmail(_emailController.text)
                              .then((value) async {
                            if (value.isSuccess) {
                              authProvider.updateEmail(_emailController.text);
                              if (value.message == 'active') {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => VerificationScreen(
                                        emailAddress: _emailController.text,
                                        fromSignUp: true)));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => CreateAccountScreen()));
                              }
                            }
                          });
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            ColorResources.COLOR_PRIMARY),
                      )),

                // for create an account
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have account',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL,
                              color: ColorResources.getGreyColor(context)),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          'Login',
                          style: Theme.of(context).textTheme.headline3.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: ColorResources.COLOR_PRIMARY,
                              ),
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
    );
  }
}
