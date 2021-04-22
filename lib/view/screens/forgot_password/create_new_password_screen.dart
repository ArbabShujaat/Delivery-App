import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  final String resetToken;
  final String email;
  CreateNewPasswordScreen({@required this.resetToken, @required this.email});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

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
        child: Container(
          alignment: Alignment.center,
          width: width * 0.85,
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(height: 12),
                  CustomAppBar(title: 'Create New Password'),
                  SizedBox(height: 55),
                  Image.asset(
                    Images.openlock,
                    width: 142,
                    height: 142,
                  ),
                  SizedBox(height: 40),
                  Center(
                      child: Text(
                    'Enter password to create your new password',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(color: ColorResources.getHintColor(context)),
                  )),
                  Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // for password section

                        SizedBox(height: 60),
                        Text(
                          'New Password',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                              color: ColorResources.getHintColor(context)),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        CustomTextField(
                          hintText: '+91 9003471243',
                          isPassword: true,
                          focusNode: _passwordFocus,
                          nextFocus: _confirmPasswordFocus,
                          isShowSuffixIcon: false,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(26.0),
                          ),
                          inputAction: TextInputAction.next,
                          controller: _passwordController,
                        ),
                        SizedBox(height: 35),
                        // for confirm password section
                        Text(
                          'Confirm Password',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                              color: ColorResources.getHintColor(context)),
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
                          focusNode: _confirmPasswordFocus,
                          controller: _confirmPasswordController,
                          inputAction: TextInputAction.done,
                        ),

                        SizedBox(height: 30),
                        !auth.isForgotPasswordLoading
                            ? Center(
                                child: CustomButton(
                                  width: width * 0.65,
                                  height: height * 0.06,
                                  btnTxt: 'Save',
                                  onTap: () {
                                    if (_passwordController.text.isEmpty) {
                                      showCustomSnackBar(
                                          'Enter new password', context);
                                    } else if (_confirmPasswordController
                                        .text.isEmpty) {
                                      showCustomSnackBar(
                                          'Enter new password again', context);
                                    } else if (_passwordController.text !=
                                        _confirmPasswordController.text) {
                                      showCustomSnackBar(
                                          'Password does not matched', context);
                                    } else {
                                      auth
                                          .resetPassword(
                                              resetToken,
                                              _passwordController.text,
                                              _confirmPasswordController.text)
                                          .then((value) {
                                        if (value.isSuccess) {
                                          auth
                                              .login(email,
                                                  _passwordController.text)
                                              .then((value) {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            DashboardScreen()));
                                          });
                                        } else {
                                          showCustomSnackBar(
                                              'Failed to reset password',
                                              context);
                                        }
                                      });
                                    }
                                  },
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor))),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
