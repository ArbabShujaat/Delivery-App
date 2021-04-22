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
import 'package:flutter_restaurant/view/screens/forgot_password/verification_screen.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
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
          alignment: Alignment.center,
          width: width * 0.85,
          child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              return ListView(
                children: [
                  SizedBox(height: 12),
                  CustomAppBar(title: 'Forgot Password'),
                  SizedBox(height: 55),
                  Image.asset(
                    Images.locklock,
                    width: 142,
                    height: 142,
                  ),
                  SizedBox(height: 40),
                  Center(
                      child: Text(
                    'Please enter phone number to receive a verification code',
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
                        SizedBox(height: 80),
                        Text(
                          'Mobile Number',
                          style: Theme.of(context).textTheme.headline2.copyWith(
                              color: ColorResources.getHintColor(context)),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        CustomTextField(
                          hintText: '+91 9003471243',
                          // isShowBorder: ,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          controller: _emailController,
                          inputType: TextInputType.emailAddress,
                          inputAction: TextInputAction.done,
                        ),
                        SizedBox(height: 40),
                        !auth.isForgotPasswordLoading
                            ? Center(
                                child: CustomButton(
                                  width: width * 0.65,
                                  height: height * 0.06,
                                  btnTxt: getTranslated('send', context),
                                  onTap: () {
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .forgetPassword(_emailController.text)
                                        .then((value) {
                                      if (value.isSuccess) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    VerificationScreen(
                                                        emailAddress:
                                                            _emailController
                                                                .text)));
                                      } else {
                                        showCustomSnackBar(
                                            value.message, context);
                                      }
                                    });
                                  },
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorResources.COLOR_PRIMARY))),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
