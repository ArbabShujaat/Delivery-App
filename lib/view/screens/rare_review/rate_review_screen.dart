import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

class RateReviewScreen extends StatelessWidget {
  final Product product;
  final OrderDetailsModel orderDetailsModel;
  RateReviewScreen({this.product, this.orderDetailsModel});

  final TextEditingController _controller = TextEditingController();
  final List<File> _files = [File(''), File(''), File('')];

  @override
  Widget build(BuildContext context) {
    print(product.toJson());

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
        child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) => Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    CustomAppBar(title: getTranslated('rate_review', context)),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL),
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 7, right: 10, top: 15),
                              margin: EdgeInsets.only(
                                  bottom: 10, right: 10, left: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 1))
                                  ],
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.PADDING_SIZE_SMALL)),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholder_image,
                                          image:
                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}',
                                          height: 70,
                                          width: 85,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                          width: Dimensions.PADDING_SIZE_SMALL),
                                      Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                            Text(product.name,
                                                style: rubikMedium,
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            SizedBox(height: 12),
                                            Text('\$ ${product.price}',
                                                style: rubikBold),
                                          ])),
                                      Row(
                                        children: [
                                          Text(
                                              '${getTranslated('quantity', context)}: ',
                                              style: rubikMedium.copyWith(
                                                  color: ColorResources
                                                      .getGreyBunkerColor(
                                                          context)),
                                              overflow: TextOverflow.ellipsis),
                                          Text(
                                            orderDetailsModel.quantity
                                                .toString(),
                                            style: rubikMedium.copyWith(
                                                color: ColorResources
                                                    .getPrimaryColor(context),
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 22),
                                  Container(
                                      height: 1,
                                      color: ColorResources.COLOR_GAINSBORO),
                                  SizedBox(height: 22),
                                  Text(
                                      '${getTranslated('rate_the_food', context)}: ',
                                      style: rubikMedium.copyWith(
                                          color:
                                              ColorResources.getGreyBunkerColor(
                                                  context)),
                                      overflow: TextOverflow.ellipsis),
                                  SizedBox(height: 24),
                                  Container(
                                    height: 30,
                                    child: ListView.builder(
                                      itemCount: 5,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          child: Icon(
                                            Provider.of<ProductProvider>(
                                                            context)
                                                        .rating <
                                                    (index + 1)
                                                ? Icons.star_border
                                                : Icons.star,
                                            size: 20,
                                            color: Provider.of<ProductProvider>(
                                                            context)
                                                        .rating <
                                                    (index + 1)
                                                ? ColorResources.getGreyColor(
                                                    context)
                                                : ColorResources
                                                    .getPrimaryColor(context),
                                          ),
                                          onTap: () =>
                                              Provider.of<ProductProvider>(
                                                      context,
                                                      listen: false)
                                                  .setRating(index + 1),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  Text(
                                      '${getTranslated('share_your_opinion', context)}: ',
                                      style: rubikMedium.copyWith(
                                          color:
                                              ColorResources.getGreyBunkerColor(
                                                  context)),
                                      overflow: TextOverflow.ellipsis),
                                  SizedBox(height: 17),
                                  CustomTextField(
                                    maxLines: 3,
                                    controller: _controller,
                                    hintText: getTranslated(
                                        'write_your_review_here', context),
                                    fillColor:
                                        ColorResources.getSearchBg(context),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productProvider.errorText != null
                              ? CircleAvatar(
                                  backgroundColor:
                                      ColorResources.getPrimaryColor(context),
                                  radius: 5)
                              : SizedBox.shrink(),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              productProvider.errorText != null
                                  ? productProvider.errorText ?? ""
                                  : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color:
                                        ColorResources.getPrimaryColor(context),
                                  ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_LARGE),
                      child: Column(
                        children: [
                          !productProvider.isLoading
                              ? CustomButton(
                                  btnTxt: getTranslated('submit', context),
                                  onTap: () {
                                    //Navigator.of(context).push(MaterialPageRoute(builder: (_) => ThanksFeedbackScreen()));
                                    if (productProvider.rating == 0) {
                                      productProvider
                                          .setErrorText('Add a rating');
                                    } else if (_controller.text.isEmpty) {
                                      productProvider
                                          .setErrorText('Write something');
                                    } else {
                                      productProvider.setErrorText('');
                                      ReviewBody reviewBody = ReviewBody(
                                        productId: orderDetailsModel.productId
                                            .toString(),
                                        rating:
                                            productProvider.rating.toString(),
                                        comment: _controller.text.isEmpty
                                            ? ''
                                            : _controller.text,
                                      );
                                      productProvider
                                          .submitReview(
                                              reviewBody,
                                              _files,
                                              Provider.of<AuthProvider>(context,
                                                      listen: false)
                                                  .getUserToken())
                                          .then((value) {
                                        if (value.isSuccess) {
                                          Navigator.pop(context);
                                          FocusScopeNode currentFocus =
                                              FocusScope.of(context);
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                          _controller.clear();
                                        } else {
                                          productProvider
                                              .setErrorText(value.message);
                                        }
                                      });
                                    }
                                  },
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor))),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) => DashboardScreen()));
                              },
                              child: Text(
                                getTranslated('skip', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(
                                        fontSize: Dimensions.FONT_SIZE_SMALL),
                              )),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                        ],
                      ),
                    )
                  ],
                )),
      ),
    );
  }
}
