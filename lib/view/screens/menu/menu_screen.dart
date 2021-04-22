import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/screens/address/address_screen.dart';
import 'package:flutter_restaurant/view/screens/chat/chat_screen.dart';
import 'package:flutter_restaurant/view/screens/coupon/coupon_screen.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter_restaurant/view/screens/language/choose_language_screen.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:flutter_restaurant/view/screens/order/order_screen.dart';
import 'package:flutter_restaurant/view/screens/profile/profile_screen.dart';
import 'package:flutter_restaurant/view/screens/support/support_screen.dart';
import 'package:flutter_restaurant/view/screens/terms/terms_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MenuScreen extends StatelessWidget {
  final Function onTap;
  MenuScreen({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(children: [
          Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) => Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Image.asset(
                      Images.menuu,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.55,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding: EdgeInsets.symmetric(vertical: 50),
                  // decoration: BoxDecoration(
                  // color: ColorResources.getPrimaryColor(context)),

                  child: ListView(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: ColorResources.COLOR_WHITE, width: 2)),
                          child: ClipOval(
                              // child: FadeInImage.assetNetwork(
                              //   placeholder: Images.placeholder_user,
                              //   image:
                              //       '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
                              //       '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.image : ''}',
                              //   height: 80,
                              //   width: 80,
                              //   fit: BoxFit.cover,
                              // ),
                              ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          enabled: profileProvider.userInfoModel == null,
                          child: Column(children: [
                            SizedBox(height: 20),
                            profileProvider.userInfoModel != null
                                ? Text(
                                    '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                                    style: rubikRegular.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_LARGE,
                                        color: ColorResources.COLOR_WHITE),
                                  )
                                : Container(
                                    height: 15,
                                    width: 150,
                                    color: Colors.white),
                            SizedBox(height: 10),
                            profileProvider.userInfoModel != null
                                ? Text(
                                    '${profileProvider.userInfoModel.email ?? ''}',
                                    style: rubikRegular.copyWith(
                                        color: ColorResources.BACKGROUND_COLOR),
                                  )
                                : Container(
                                    height: 15,
                                    width: 100,
                                    color: Colors.white),
                          ]),
                        )
                      ]),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                children: [
                  // SwitchListTile(
                  //   value: Provider.of<ThemeProvider>(context).darkTheme,
                  //   onChanged: (bool isActive) =>
                  //       Provider.of<ThemeProvider>(context, listen: false)
                  //           .toggleTheme(),
                  //   title: Text(getTranslated('dark_theme', context),
                  //       style: rubikMedium.copyWith(
                  //           fontSize: Dimensions.FONT_SIZE_LARGE)),
                  //   activeColor: Theme.of(context).primaryColor,
                  // ),
                  ListTile(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => DashboardScreen())),
                    leading: Image.asset(Images.home,
                        width: 20,
                        height: 20,
                        color: ColorResources.COLOR_PRIMARY),
                    title: Text('Home',
                        style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                  ListTile(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ProfileScreen())),
                    leading: Image.asset(Images.profile,
                        width: 20,
                        height: 20,
                        color: ColorResources.COLOR_PRIMARY),
                    title: Text(getTranslated('profile', context),
                        style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                  ListTile(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ChatScreen())),
                    leading: Icon(
                      Icons.email,
                      color: ColorResources.COLOR_PRIMARY,
                    ),
                    title: Text('Messages',
                        style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                  ListTile(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => CouponScreen())),
                    leading: Image.asset(Images.coupon,
                        width: 20,
                        height: 20,
                        color: ColorResources.COLOR_PRIMARY),
                    title: Text(getTranslated('coupon', context),
                        style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                  ListTile(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => OrderScreen())),
                    leading: Image.asset(
                      Images.order,
                      width: 20,
                      height: 20,
                      color: ColorResources.COLOR_PRIMARY,
                    ),
                    title: Text(getTranslated('my_order', context),
                        style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),

                  ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ChooseLanguageScreen(fromMenu: true))),
                    leading: Image.asset(Images.language,
                        width: 20,
                        height: 20,
                        color: ColorResources.COLOR_PRIMARY),
                    title: Text(getTranslated('language', context),
                        style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                  ListTile(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SupportScreen())),
                    leading: Icon(Icons.contact_support,
                        size: 20, color: ColorResources.COLOR_PRIMARY),
                    title: Text(getTranslated('help_and_support', context),
                        style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                  ListTile(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => TermsScreen())),
                    leading: Icon(Icons.rule,
                        size: 20, color: ColorResources.COLOR_PRIMARY),
                    title: Text(getTranslated('terms_and_condition', context),
                        style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                  ListTile(
                    onTap: () {
                      showDialog(
                          context: context, child: SignOutConfirmationDialog());
                    },
                    leading: Image.asset(Images.log_out,
                        width: 20,
                        height: 20,
                        color: ColorResources.COLOR_PRIMARY),
                    title: Text(getTranslated('logout', context),
                        style: rubikMedium.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                ]),
          ),
        ]),
      ),
    );
  }
}