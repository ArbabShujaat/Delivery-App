import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';
import 'package:flutter_restaurant/view/screens/checkout/payment_screen.dart';
import 'package:flutter_restaurant/view/screens/order/widget/order_cancel_dialog.dart';
import 'package:flutter_restaurant/view/screens/rare_review/rate_review_screen.dart';
import 'package:flutter_restaurant/view/screens/track/order_tracking_screen.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel orderModel;
  OrderDetailsScreen({@required this.orderModel});

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false)
        .getOrderDetails(orderModel.id.toString(), context);
    double deliveryCharge = double.parse(
        Provider.of<SplashProvider>(context, listen: false)
            .configModel
            .deliveryCharge);
    final GlobalKey<ScaffoldState> _scaffold = GlobalKey();

    return Scaffold(
      key: _scaffold,
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
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            CustomAppBar(title: getTranslated('order_details', context)),
            SizedBox(
              height: 10,
            ),
            Consumer<OrderProvider>(
              builder: (context, order, child) {
                double _itemPrice = 0;
                double _discount = 0;
                double _tax = 0;
                double _addOns = 0;
                if (order.orderDetails != null) {
                  order.orderDetails.forEach((orderDetails) {
                    orderDetails.addOnIds.forEach((addOnId) {
                      orderDetails.productDetails.addOns.forEach((addOn) {
                        if (addOn.id == addOnId) {
                          _addOns = _addOns + addOn.price;
                        }
                      });
                    });
                    _itemPrice = _itemPrice +
                        ((orderDetails.price) * orderDetails.quantity);
                    _discount = _discount + orderDetails.discountOnProduct;
                    _tax = _tax + orderDetails.taxAmount;
                  });
                }
                double _subTotal = _itemPrice + _tax + _addOns;
                double _total = _itemPrice +
                    _addOns -
                    _discount +
                    _tax +
                    deliveryCharge -
                    orderModel.couponDiscountAmount;

                return order.orderDetails != null
                    ? ListView(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        children: [
                          Row(children: [
                            Text('${getTranslated('order_id', context)}:',
                                style: rubikRegular),
                            SizedBox(
                                width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Text(orderModel.id.toString(), style: rubikMedium),
                            Expanded(child: SizedBox()),
                            Icon(Icons.watch_later, size: 17),
                            SizedBox(
                                width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Text(
                                DateConverter.isoStringToLocalDateOnly(
                                    orderModel.createdAt),
                                style: rubikRegular),
                          ]),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          Row(children: [
                            Text('${getTranslated('item', context)}:',
                                style: rubikRegular),
                            SizedBox(
                                width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Text(order.orderDetails.length.toString(),
                                style: rubikMedium.copyWith(
                                    color: Theme.of(context).primaryColor)),
                          ]),
                          Divider(height: 40),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: order.orderDetails.length,
                            itemBuilder: (context, index) {
                              List<AddOns> _addOns = [];
                              order.orderDetails[index].productDetails.addOns
                                  .forEach((addOn) {
                                if (order.orderDetails[index].addOnIds
                                    .contains(addOn.id)) {
                                  _addOns.add(addOn);
                                }
                              });

                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholder_image,
                                          image:
                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${order.orderDetails[index].productDetails.image}',
                                          height: 70,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                          width: Dimensions.PADDING_SIZE_SMALL),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      order.orderDetails[index]
                                                          .productDetails.name,
                                                      style: rubikMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                      '${getTranslated('quantity', context)}:',
                                                      style: rubikRegular),
                                                  Text(
                                                      order.orderDetails[index]
                                                          .quantity
                                                          .toString(),
                                                      style: rubikMedium.copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor)),
                                                ],
                                              ),
                                              SizedBox(
                                                  height: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              Row(children: [
                                                Text(
                                                  PriceConverter.convertPrice(
                                                    context,
                                                    order.orderDetails[index]
                                                            .price -
                                                        (order
                                                                .orderDetails[
                                                                    index]
                                                                .discountOnProduct /
                                                            order
                                                                .orderDetails[
                                                                    index]
                                                                .quantity),
                                                  ),
                                                  style: rubikBold,
                                                ),
                                                SizedBox(width: 5),
                                                Expanded(
                                                    child: Text(
                                                        PriceConverter
                                                            .convertPrice(
                                                                context,
                                                                order
                                                                    .orderDetails[
                                                                        index]
                                                                    .price),
                                                        style:
                                                            rubikBold.copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontSize: Dimensions
                                                              .FONT_SIZE_SMALL,
                                                          color: ColorResources
                                                              .COLOR_GREY,
                                                        ))),
                                                orderModel.orderStatus ==
                                                        'delivered'
                                                    ? InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (_) =>
                                                                RateReviewScreen(
                                                              product: order
                                                                  .orderDetails[
                                                                      index]
                                                                  .productDetails,
                                                              orderDetailsModel:
                                                                  order.orderDetails[
                                                                      index],
                                                            ),
                                                          ));
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: Dimensions
                                                                  .PADDING_SIZE_EXTRA_SMALL,
                                                              horizontal: Dimensions
                                                                  .PADDING_SIZE_SMALL),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Text(
                                                              getTranslated(
                                                                  'review',
                                                                  context),
                                                              style:
                                                                  rubikRegular),
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                              ]),
                                              SizedBox(
                                                  height: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              Row(children: [
                                                Container(
                                                    height: 10,
                                                    width: 10,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .color,
                                                    )),
                                                SizedBox(
                                                    width: Dimensions
                                                        .PADDING_SIZE_EXTRA_SMALL),
                                                Text(
                                                  '${getTranslated(orderModel.orderStatus == 'delivered' ? 'delivered_at' : 'ordered_at', context)} '
                                                  '${DateConverter.isoStringToLocalDateOnly(orderModel.orderStatus == 'delivered' ? order.orderDetails[index].updatedAt : order.orderDetails[index].createdAt)}',
                                                  style: rubikRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_SMALL),
                                                ),
                                              ]),
                                            ]),
                                      ),
                                    ]),
                                    _addOns.length > 0
                                        ? SizedBox(
                                            height: 30,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              padding: EdgeInsets.only(
                                                  top: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              itemCount: _addOns.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      right: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  child: Row(children: [
                                                    Text(_addOns[index].name,
                                                        style: rubikRegular),
                                                    SizedBox(width: 2),
                                                    Text(
                                                        '${_addOns[index].price}\$',
                                                        style: rubikMedium),
                                                  ]),
                                                );
                                              },
                                            ),
                                          )
                                        : SizedBox(),
                                    Divider(height: 40),
                                  ]);
                            },
                          ),

                          // Total
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('items_price', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                    PriceConverter.convertPrice(
                                        context, _itemPrice),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ]),
                          SizedBox(height: 10),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('tax', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                    '(+) ${PriceConverter.convertPrice(context, _tax)}',
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ]),
                          SizedBox(height: 10),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('addons', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                    '(+) ${PriceConverter.convertPrice(context, _addOns)}',
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ]),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: CustomDivider(),
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('subtotal', context),
                                    style: rubikMedium.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                    PriceConverter.convertPrice(
                                        context, _subTotal),
                                    style: rubikMedium.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ]),
                          SizedBox(height: 10),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('discount', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                    '(-) ${PriceConverter.convertPrice(context, _discount)}',
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ]),
                          SizedBox(height: 10),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('coupon_discount', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                  '(-) ${PriceConverter.convertPrice(context, orderModel.couponDiscountAmount)}',
                                  style: rubikRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE),
                                ),
                              ]),
                          SizedBox(height: 10),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('delivery_fee', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Text(
                                    '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ]),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: CustomDivider(),
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('total_amount', context),
                                    style: rubikMedium.copyWith(
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_LARGE,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                Text(
                                  PriceConverter.convertPrice(context, _total),
                                  style: rubikMedium.copyWith(
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_LARGE,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ]),
                          SizedBox(height: 30),

                          !order.showCancelled
                              ? Row(children: [
                                  orderModel.orderStatus == 'pending'
                                      ? Expanded(
                                          child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    width: 2,
                                                    color: ColorResources
                                                        .DISABLE_COLOR)),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      OrderCancelDialog(
                                                        orderID: orderModel.id
                                                            .toString(),
                                                        callback: (String
                                                                message,
                                                            bool isSuccess,
                                                            String orderID) {
                                                          if (isSuccess) {
                                                            _scaffold
                                                                .currentState
                                                                .showSnackBar(SnackBar(
                                                                    content: Text(
                                                                        '$message. Order ID: $orderID'),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green));
                                                          } else {
                                                            _scaffold
                                                                .currentState
                                                                .showSnackBar(SnackBar(
                                                                    content: Text(
                                                                        message),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green));
                                                          }
                                                        },
                                                      ));
                                            },
                                            height: 50,
                                            child: Text(
                                                getTranslated(
                                                    'cancel_order', context),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline3
                                                    .copyWith(
                                                      color: ColorResources
                                                          .DISABLE_COLOR,
                                                      fontSize: Dimensions
                                                          .FONT_SIZE_LARGE,
                                                    )),
                                          ),
                                        ))
                                      : SizedBox(),
                                  (orderModel.paymentStatus == 'unpaid' &&
                                          orderModel.paymentMethod !=
                                              'cash_on_delivery')
                                      ? Expanded(
                                          child: Container(
                                          height: 50,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          child: CustomButton(
                                            btnTxt: getTranslated(
                                                'pay_now', context),
                                            onTap: () async {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          PaymentScreen(
                                                              orderModel:
                                                                  orderModel,
                                                              fromCheckout:
                                                                  false)));
                                            },
                                          ),
                                        ))
                                      : SizedBox(),
                                ])
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                      getTranslated('order_cancelled', context),
                                      style: rubikBold.copyWith(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ),

                          (orderModel.orderStatus == 'confirmed' ||
                                  orderModel.orderStatus == 'processing' ||
                                  orderModel.orderStatus == 'out_for_delivery')
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                      vertical: Dimensions.PADDING_SIZE_SMALL),
                                  child: CustomButton(
                                    btnTxt:
                                        getTranslated('track_order', context),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  OrderTrackingScreen(
                                                      orderID: orderModel.id
                                                          .toString())));
                                    },
                                  ),
                                )
                              : SizedBox(),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
