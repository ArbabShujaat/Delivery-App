import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/checkout_screen.dart';
import 'package:flutter_restaurant/view/screens/order/order_details_screen.dart';
import 'package:flutter_restaurant/view/screens/track/order_tracking_screen.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  final bool isRunning;
  OrderView({@required this.isRunning});

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
                Color(0xffffffff),
                Color(0xffdcfdff),
              ]),
        ),
        child: Consumer<OrderProvider>(
          builder: (context, order, index) {
            List<OrderModel> orderList;
            if (order.runningOrderList != null) {
              orderList = isRunning
                  ? order.runningOrderList.reversed.toList()
                  : order.historyOrderList.reversed.toList();
            }

            return orderList != null
                ? orderList.length > 0
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        itemCount: orderList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            margin: EdgeInsets.only(
                                bottom: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[
                                      Provider.of<ThemeProvider>(context)
                                              .darkTheme
                                          ? 700
                                          : 300],
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                )
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(children: [
                              Row(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder_image,
                                    image:
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${'hjgh'}',
                                    height: 70,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text(
                                            '${getTranslated('order_id', context)}:',
                                            style: rubikRegular.copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_SMALL)),
                                        SizedBox(
                                            width: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                        Text(orderList[index].id.toString(),
                                            style: rubikMedium.copyWith(
                                                fontSize: Dimensions
                                                    .FONT_SIZE_SMALL)),
                                      ]),
                                      SizedBox(
                                          height: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Text(
                                        '${orderList[index].detailsCount} ${getTranslated('items', context)}',
                                        style: rubikRegular.copyWith(
                                            color: ColorResources.COLOR_GREY),
                                      ),
                                      SizedBox(
                                          height: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Row(children: [
                                        Icon(Icons.check_circle,
                                            color: ColorResources.COLOR_PRIMARY,
                                            size: 15),
                                        SizedBox(
                                            width: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                        Text(
                                          '${orderList[index].orderStatus[0].toUpperCase()}${orderList[index].orderStatus.substring(1).replaceAll('_', ' ')}',
                                          style: rubikRegular.copyWith(
                                              color:
                                                  ColorResources.COLOR_PRIMARY),
                                        ),
                                      ]),
                                    ]),
                              ]),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                              SizedBox(
                                height: 50,
                                child: Row(children: [
                                  Expanded(
                                      child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    clipBehavior: Clip.antiAlias,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      // color: transparent ? Colors.transparent : Color(0xff128b94),
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                    ),
                                    child: CustomButton(
                                      // : RoundedRectangleBorder(
                                      //     borderRadius: BorderRadius.circular(10),
                                      //     side: BorderSide(
                                      //         width: 2,
                                      //         color:
                                      //             ColorResources.DISABLE_COLOR)),
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      backgroundColor: Colors.transparent,
                                      textColor: true,
                                      transparent: true,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    OrderDetailsScreen(
                                                        orderModel:
                                                            orderList[index])));
                                      },
                                      // height: 50,
                                      btnTxt: isRunning
                                          ? 'Cancel Order'
                                          : 'Details',

                                      // padding: EdgeInsets.all(0),
                                      // child: Text(
                                      //     getTranslated('details', context),
                                      //     style: Theme.of(context)
                                      //         .textTheme
                                      //         .headline3
                                      //         .copyWith(
                                      //           color:
                                      //               ColorResources.DISABLE_COLOR,
                                      //           fontSize:
                                      //               Dimensions.FONT_SIZE_LARGE,
                                      //         )),
                                    ),
                                  )),
                                  SizedBox(width: 30),
                                  Expanded(
                                      child: CustomButton(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    btnTxt: getTranslated(
                                        isRunning ? 'track_order' : 'reorder',
                                        context),
                                    onTap: () async {
                                      if (isRunning) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    OrderTrackingScreen(
                                                        orderID:
                                                            orderList[index]
                                                                .id
                                                                .toString())));
                                      } else {
                                        List<OrderDetailsModel> orderDetails =
                                            await order.getOrderDetails(
                                                orderList[index].id.toString(),
                                                context);
                                        List<CartModel> _cartList = [];
                                        orderDetails.forEach((orderDetail) =>
                                            _cartList.add(CartModel(
                                              orderDetail.productDetails.name,
                                              orderDetail.productDetails.image,
                                              orderDetail.productId,
                                              orderDetail.price,
                                              PriceConverter
                                                  .convertWithDiscount(
                                                      context,
                                                      orderDetail.price,
                                                      orderDetail
                                                          .discountOnProduct,
                                                      'amount'),
                                              orderDetail.variant,
                                              [],
                                              orderDetail.discountOnProduct,
                                              orderDetail.quantity,
                                              orderDetail.taxAmount,
                                              [],
                                              [],
                                              orderDetail.productDetails.rating,
                                            )));
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => CheckoutScreen(
                                                      cartList: _cartList,
                                                      amount: orderList[index]
                                                          .orderAmount,
                                                    )));
                                      }
                                    },
                                  )),
                                ]),
                              ),
                            ]),
                          );
                        },
                      )
                    : NoDataScreen(isOrder: true)
                : Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor)));
          },
        ),
      ),
    );
  }
}
