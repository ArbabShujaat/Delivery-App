import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
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
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              CustomAppBar(
                  title: getTranslated('my_favourite', context),
                  isBackButtonExist: false),
              SizedBox(
                height: 10,
              ),
              Consumer<WishListProvider>(
                builder: (context, wishlistProvider, child) => wishlistProvider
                            .wishList !=
                        null
                    ? wishlistProvider.wishIdList.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: wishlistProvider.wishList.length,
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            itemBuilder: (context, index) {
                              return ProductWidget(
                                  product: wishlistProvider.wishList[index]);
                            })
                        : NoDataScreen()
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                ColorResources.COLOR_PRIMARY))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
