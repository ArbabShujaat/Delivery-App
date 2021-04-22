import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/auth/signup_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_restaurant/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _emailNumberFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserNumber() ??
            null;
    _passwordController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserPassword() ??
            null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            builder: (context, authProvider, child) => Form(
              key: _formKeyLogin,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  //SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      Images.logo,
                      height: MediaQuery.of(context).size.height / 4.5,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  SizedBox(height: 20),
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
                              onTap: () {},
                              backgroundColor: ColorResources.COLOR_PRIMARY,
                            ),
                            CustomButton(
                              width: width * 0.3,
                              btnTxt: 'Signup',
                              textColor: true,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => SignUpScreen()));
                              },
                              transparent: true,
                              backgroundColor: Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  CustomTextField(
                    hintText: 'Mobile Number/Email',
                    isShowBorder: false,
                    border: UnderlineInputBorder(),
                    focusNode: _emailNumberFocus,
                    nextFocus: _passwordFocus,
                    fillColor: Colors.transparent,
                    controller: _emailController,
                    inputType: TextInputType.emailAddress,
                    icon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    isShowPrefixIcon: false,
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  CustomTextField(
                    border: UnderlineInputBorder(),
                    icon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    fillColor: Colors.transparent,
                    isShowPrefixIcon: false,
                    hintText: 'Password',
                    isShowBorder: false,
                    isPassword: true,
                    isShowSuffixIcon: true,
                    focusNode: _passwordFocus,
                    controller: _passwordController,
                    inputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 22),

                  // for remember me section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<AuthProvider>(
                          builder: (context, authProvider, child) => InkWell(
                                onTap: () {
                                  authProvider.toggleRememberMe();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      getTranslated('remember_me', context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .copyWith(
                                              fontSize: Dimensions
                                                  .FONT_SIZE_EXTRA_SMALL,
                                              color:
                                                  ColorResources.getHintColor(
                                                      context)),
                                    ),
                                    SizedBox(
                                        width: Dimensions.PADDING_SIZE_SMALL),
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                          color: authProvider.isActiveRememberMe
                                              ? ColorResources.COLOR_PRIMARY
                                              : ColorResources.COLOR_WHITE,
                                          border: Border.all(
                                              color: authProvider
                                                      .isActiveRememberMe
                                                  ? Colors.transparent
                                                  : ColorResources
                                                      .COLOR_PRIMARY),
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      child: authProvider.isActiveRememberMe
                                          ? Icon(Icons.done,
                                              color: ColorResources.COLOR_WHITE,
                                              size: 17)
                                          : SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              )),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ForgotPasswordScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            getTranslated('forgot_password', context),
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color:
                                        ColorResources.getHintColor(context)),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      authProvider.loginErrorMessage.length > 0
                          ? CircleAvatar(
                              backgroundColor:
                                  ColorResources.getPrimaryColor(context),
                              radius: 5)
                          : SizedBox.shrink(),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authProvider.loginErrorMessage ?? "",
                          style: Theme.of(context).textTheme.headline2.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: ColorResources.getPrimaryColor(context),
                              ),
                        ),
                      )
                    ],
                  ),

                  // for login button
                  SizedBox(height: 10),
                  !authProvider.isLoading
                      ? CustomButton(
                          width: width * 0.6,
                          height: height * 0.05,
                          btnTxt: 'Login',
                          onTap: () async {
                            if (_formKeyLogin.currentState.validate()) {
                              _formKeyLogin.currentState.save();

                              print(authProvider.getUserNumber());
                              authProvider
                                  .login(_emailController.text,
                                      _passwordController.text)
                                  .then((status) async {
                                if (status.isSuccess) {
                                  if (authProvider.isActiveRememberMe) {
                                    authProvider.saveUserNumberAndPassword(
                                        _emailController.text,
                                        _passwordController.text);
                                  } else {
                                    authProvider.clearUserNumberAndPassword();
                                  }

                                  await Provider.of<WishListProvider>(context,
                                          listen: false)
                                      .initWishList(context);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) => DashboardScreen()));
                                }
                              });
                            }
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              ColorResources.COLOR_PRIMARY),
                        )),

                  // for create an account
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => SignUpScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create Account',
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color:
                                        ColorResources.getGreyColor(context)),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Text(
                            'Signup',
                            style:
                                Theme.of(context).textTheme.headline3.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: ColorResources.COLOR_PRIMARY,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
