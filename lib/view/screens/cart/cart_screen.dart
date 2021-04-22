import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter_restaurant/view/screens/checkout/checkout_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<CouponProvider>(context, listen: false).removeCouponData();
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final TextEditingController _couponController = TextEditingController();
    double deliveryCharge = double.parse(
        Provider.of<SplashProvider>(context, listen: false)
            .configModel
            .deliveryCharge);

    return Scaffold(
      key: _scaffoldKey,
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
          width: MediaQuery.of(context).size.width * 0.9,
          child: ListView(
            children: [
              SizedBox(
                height: 20.0,
              ),
              CustomAppBar(
                  title: getTranslated('my_cart', context),
                  isBackButtonExist: false),
              Consumer<CartProvider>(
                builder: (context, cart, child) {
                  double _itemPrice = cart.amount;
                  double _discount = 0;
                  double _tax = 0;
                  double _addOns = 0;
                  cart.cartList.forEach((cartModel) {
                    cartModel.addOns
                        .forEach((addOn) => _addOns = _addOns + addOn.price);
                    _discount = _discount +
                        (cartModel.discountAmount * cartModel.quantity);
                    _tax = _tax + (cartModel.taxAmount * cartModel.quantity);
                  });
                  double _subTotal = _itemPrice + _tax + _addOns;
                  double _total = _subTotal -
                      _discount -
                      Provider.of<CouponProvider>(context).discount +
                      deliveryCharge;

                  return cart.cartList.length > 0
                      ? ListView(
                          shrinkWrap: true,
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          physics: BouncingScrollPhysics(),
                          children: [
                              // Product
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: cart.cartList.length,
                                itemBuilder: (context, index) {
                                  return CartProductWidget(
                                      cart: cart.cartList[index]);
                                },
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              // Coupon
                              Consumer<CouponProvider>(
                                builder: (context, coupon, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(26),
                                      border: Border.all(color: Colors.black),
                                      color: Colors.white,
                                    ),
                                    child: Row(children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _couponController,
                                          style: rubikRegular,
                                          decoration: InputDecoration(
                                            hintText: getTranslated(
                                                'enter_promo_code', context),
                                            hintStyle: rubikRegular.copyWith(
                                                color:
                                                    ColorResources.getHintColor(
                                                        context)),
                                            isDense: true,
                                            filled: true,
                                            enabled: coupon.discount == 0,
                                            fillColor:
                                                Theme.of(context).accentColor,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(26),
                                                // topRight:  Radius.circular(26),
                                                bottomLeft: Radius.circular(26),
                                              ),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (_couponController
                                                  .text.isNotEmpty &&
                                              !coupon.isLoading) {
                                            if (coupon.discount < 1) {
                                              coupon
                                                  .applyCoupon(
                                                      _couponController.text,
                                                      _total)
                                                  .then((discount) {
                                                if (discount > 0) {
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'You got ${Provider.of<SplashProvider>(context, listen: false).configModel.currencySymbol}$discount discount'),
                                                          backgroundColor:
                                                              Colors.green));
                                                } else {
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Failed to get discount'),
                                                          backgroundColor:
                                                              Colors.red));
                                                }
                                              });
                                            } else {
                                              coupon.removeCouponData();
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 100,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(26.0),
                                            // borderSide: BorderSide.none,
                                          ),
                                          child: coupon.discount <= 0
                                              ? !coupon.isLoading
                                                  ? Text(
                                                      getTranslated(
                                                          'apply', context),
                                                      style:
                                                          rubikMedium.copyWith(
                                                              color:
                                                                  Colors.white),
                                                    )
                                                  : CircularProgressIndicator(
                                                      backgroundColor:
                                                          Colors.white)
                                              : Icon(Icons.clear,
                                                  color: Colors.white),
                                        ),
                                      ),
                                    ]),
                                  );
                                },
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              // Total
                              // Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text(getTranslated('items_price', context),
                              //           style: rubikRegular.copyWith(
                              //               fontSize:
                              //                   Dimensions.FONT_SIZE_LARGE)),
                              //       Text(
                              //           PriceConverter.convertPrice(
                              //               context, _itemPrice),
                              //           style: rubikRegular.copyWith(
                              //               fontSize:
                              //                   Dimensions.FONT_SIZE_LARGE)),
                              //     ]),
                              // SizedBox(height: 10),

                              // Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text(getTranslated('tax', context),
                              //           style: rubikRegular.copyWith(
                              //               fontSize:
                              //                   Dimensions.FONT_SIZE_LARGE)),
                              //       Text(
                              //           '(+) ${PriceConverter.convertPrice(context, _tax)}',
                              //           style: rubikRegular.copyWith(
                              //               fontSize:
                              //                   Dimensions.FONT_SIZE_LARGE)),
                              //     ]),
                              // SizedBox(height: 10),

                              // Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text(getTranslated('addons', context),
                              //           style: rubikRegular.copyWith(
                              //               fontSize:
                              //                   Dimensions.FONT_SIZE_LARGE)),
                              //       Text(
                              //           '(+) ${PriceConverter.convertPrice(context, _addOns)}',
                              //           style: rubikRegular.copyWith(
                              //               fontSize:
                              //                   Dimensions.FONT_SIZE_LARGE)),
                              //     ]),

                              // Padding(
                              //   padding: EdgeInsets.symmetric(
                              //       vertical: Dimensions.PADDING_SIZE_SMALL),
                              //   child: CustomDivider(),
                              // ),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sub Total',
                                      style: rubikRegular.copyWith(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                        PriceConverter.convertPrice(
                                            context, _subTotal),
                                        style: rubikRegular.copyWith(
                                          fontSize: 18,
                                        )),
                                  ]),
                              SizedBox(height: 13),

                              // Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text(getTranslated('discount', context),
                              //           style: rubikRegular.copyWith(
                              //               fontSize: 18)),
                              //       Text(
                              //           '(-) ${PriceConverter.convertPrice(context, _discount)}',
                              //           style: rubikRegular.copyWith(
                              //               fontSize: 18)),
                              //     ]),
                              // SizedBox(height: 13),

                              // Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text(
                              //         getTranslated('coupon_discount', context),
                              //         style: rubikRegular.copyWith(
                              //           fontSize: 18,
                              //           color: ColorResources.COLOR_PRIMARY,
                              //         ),
                              //       ),
                              //       Text(
                              //         '(-) ${PriceConverter.convertPrice(context, Provider.of<CouponProvider>(context).discount)}',
                              //         style: rubikRegular.copyWith(
                              //             fontSize: Dimensions.FONT_SIZE_LARGE),
                              //       ),
                              //     ]),
                              // SizedBox(height: 10),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(getTranslated('delivery_fee', context),
                                        style: rubikRegular.copyWith(
                                          fontSize: 18,
                                        )),
                                    Text(
                                        '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                        style: rubikRegular.copyWith(
                                          fontSize: 18,
                                        )),
                                  ]),

                              // Padding(
                              //   padding: EdgeInsets.symmetric(
                              //       vertical: Dimensions.PADDING_SIZE_SMALL),
                              //   child: CustomDivider(),
                              // ),
                              SizedBox(height: 15),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(getTranslated('total_amount', context),
                                        style: rubikMedium.copyWith(
                                          fontSize:
                                              Dimensions.FONT_SIZE_EXTRA_LARGE,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                    Text(
                                      PriceConverter.convertPrice(
                                          context, _total),
                                      style: rubikMedium.copyWith(
                                          fontSize:
                                              Dimensions.FONT_SIZE_EXTRA_LARGE,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ]),
                              SizedBox(height: 30),

                              CustomButton(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  btnTxt: getTranslated('place_order', context),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => CheckoutScreen(
                                                  cartList: cart.cartList,
                                                  amount: _total,
                                                )));
                                  }),
                            ])
                      : NoDataScreen(isCart: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
