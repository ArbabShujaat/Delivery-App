import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  ProductWidget({@required this.product});

  @override
  Widget build(BuildContext context) {
    void feedbackMessage(String message) {
      if (message != '') {
        showCustomSnackBar(message, context, isError: false);
      }
    }

    double _discountedPrice = PriceConverter.convertWithDiscount(
        context, product.price, product.discount, product.discountType);

    DateTime _currentTime =
        Provider.of<SplashProvider>(context, listen: false).currentTime;
    DateTime _start = DateFormat('hh:mm:ss').parse(product.availableTimeStarts);
    DateTime _end = DateFormat('hh:mm:ss').parse(product.availableTimeEnds);
    DateTime _startTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _start.hour, _start.minute, _start.second);
    DateTime _endTime = DateTime(_currentTime.year, _currentTime.month,
        _currentTime.day, _end.hour, _end.minute, _end.second);
    if (_endTime.isBefore(_startTime)) {
      _endTime = _endTime.add(Duration(days: 1));
    }
    bool _isAvailable =
        _currentTime.isAfter(_startTime) && _currentTime.isBefore(_endTime);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15.0,
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (con) => CartBottomSheet(
              product: product,
              callback: (CartModel cartModel) {
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(getTranslated('added_to_cart', context)),
                    backgroundColor: Colors.green));
              },
            ),
          );
        },
        child: Container(
          height: 120,
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
              horizontal: Dimensions.PADDING_SIZE_SMALL),
          margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[
                    Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300],
                blurRadius: 5,
                spreadRadius: 1,
              )
            ],
          ),
          child: Row(children: [
            Stack(
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
                _isAvailable
                    ? SizedBox()
                    : Positioned(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(0.6)),
                          child: Text(
                              getTranslated('not_available_now_break', context),
                              textAlign: TextAlign.center,
                              style: rubikRegular.copyWith(
                                color: Colors.white,
                                fontSize: 8,
                              )),
                        ),
                      ),
              ],
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(product.name,
                        style: rubikMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    SizedBox(height: 2),
                    RatingBar(
                        rating: product.rating.length > 0
                            ? double.parse(product.rating[0].average)
                            : 0.0,
                        size: 12),
                    SizedBox(height: 10),
                    Row(children: [
                      Text(
                        PriceConverter.convertPrice(context, product.price,
                            discount: product.discount,
                            discountType: product.discountType),
                        style: rubikBold,
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      product.price > _discountedPrice
                          ? Text(
                              PriceConverter.convertPrice(
                                  context, product.price),
                              style: rubikBold.copyWith(
                                color: ColorResources.COLOR_GREY,
                                decoration: TextDecoration.lineThrough,
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                              ))
                          : SizedBox(),
                    ]),
                  ]),
            ),
            Column(children: [
              Consumer<WishListProvider>(
                builder: (context, wishListProvider, child) {
                  return InkWell(
                    onTap: () {
                      if (wishListProvider.wishIdList.contains(product.id)) {
                        wishListProvider.removeFromWishList(
                            product, feedbackMessage);
                      } else {
                        wishListProvider.addToWishList(
                            product, feedbackMessage);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Icon(
                        wishListProvider.wishIdList.contains(product.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: wishListProvider.wishIdList.contains(product.id)
                            ? ColorResources.COLOR_PRIMARY
                            : ColorResources.COLOR_GREY,
                      ),
                    ),
                  );
                },
              ),
              Expanded(child: SizedBox()),
              Icon(Icons.add),
            ]),
          ]),
        ),
      ),
    );
  }
}
