import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/place_order_body.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/order_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/coupon_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/address/add_new_address_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/order_successful_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/payment_screen.dart';
import 'package:flutter_restaurant/view/screens/checkout/widget/custom_check_box.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final double amount;
  CheckoutScreen({@required this.cartList, @required this.amount});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _noteController = TextEditingController();
  GoogleMapController _mapController;
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false)
        .initAddressList(context);
    Provider.of<OrderProvider>(context, listen: false)
        .setAddressIndex(0, notify: false);
    _isCashOnDeliveryActive =
        Provider.of<SplashProvider>(context, listen: false)
                .configModel
                .cashOnDelivery ==
            'true';
    _isDigitalPaymentActive =
        Provider.of<SplashProvider>(context, listen: false)
                .configModel
                .digitalPayment ==
            'true';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Container(
          alignment: Alignment.center,
          width: width * 0.85,
          child: ListView(
            children: [
              CustomAppBar(title: getTranslated('checkout', context)),
              Consumer<OrderProvider>(
                builder: (context, order, child) {
                  return Consumer<LocationProvider>(
                    builder: (context, address, child) {
                      if (_mapController != null &&
                          address.addressList != null &&
                          address.addressList.length > 0) {
                        _mapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                zoom: 15,
                                target: LatLng(
                                  double.parse(address
                                      .addressList[order.addressIndex]
                                      .latitude),
                                  double.parse(address
                                      .addressList[order.addressIndex]
                                      .longitude),
                                ))));
                      }
                      return ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL),
                              child: Row(children: [
                                Text(getTranslated('delivery_address', context),
                                    style: rubikMedium.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Expanded(child: SizedBox()),
                                FlatButton.icon(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => AddNewAddressScreen(
                                              fromCheckout: true))),
                                  icon: Icon(Icons.add),
                                  label: Text(getTranslated('add', context),
                                      style: rubikRegular),
                                ),
                              ]),
                            ),
                            SizedBox(
                              height: 60,
                              child: address.addressList != null
                                  ? address.addressList.length > 0
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.only(
                                              left: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          itemCount: address.addressList.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                order.setAddressIndex(index);
                                                if (_mapController != null) {
                                                  _mapController.animateCamera(
                                                      CameraUpdate
                                                          .newCameraPosition(
                                                              CameraPosition(
                                                                  zoom: 15,
                                                                  target:
                                                                      LatLng(
                                                                    double.parse(address
                                                                        .addressList[
                                                                            index]
                                                                        .latitude),
                                                                    double.parse(address
                                                                        .addressList[
                                                                            index]
                                                                        .longitude),
                                                                  ))));
                                                }
                                              },
                                              child: Container(
                                                height: 60,
                                                width: 200,
                                                margin: EdgeInsets.only(
                                                    right: Dimensions
                                                        .PADDING_SIZE_LARGE),
                                                decoration: BoxDecoration(
                                                  color: index ==
                                                          order.addressIndex
                                                      ? Theme.of(context)
                                                          .accentColor
                                                      : ColorResources
                                                          .getBackgroundColor(
                                                              context),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: index ==
                                                          order.addressIndex
                                                      ? Border.all(
                                                          color: ColorResources
                                                              .getPrimaryColor(
                                                                  context),
                                                          width: 2)
                                                      : null,
                                                ),
                                                child: Row(children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .PADDING_SIZE_EXTRA_SMALL),
                                                    child: Icon(
                                                      address.addressList[index]
                                                                  .addressType ==
                                                              'Home'
                                                          ? Icons.home_filled
                                                          : address
                                                                      .addressList[
                                                                          index]
                                                                      .addressType ==
                                                                  'Workplace'
                                                              ? Icons.work
                                                              : Icons
                                                                  .list_alt_rounded,
                                                      color: index ==
                                                              order.addressIndex
                                                          ? ColorResources
                                                              .getPrimaryColor(
                                                                  context)
                                                          : Theme.of(context)
                                                              .textTheme
                                                              .bodyText1
                                                              .color,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              address
                                                                  .addressList[
                                                                      index]
                                                                  .addressType,
                                                              style:
                                                                  rubikRegular
                                                                      .copyWith(
                                                                fontSize: Dimensions
                                                                    .FONT_SIZE_SMALL,
                                                                color: ColorResources
                                                                    .getGreyBunkerColor(
                                                                        context),
                                                              )),
                                                          Text(
                                                              address
                                                                  .addressList[
                                                                      index]
                                                                  .address,
                                                              style:
                                                                  rubikRegular,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ]),
                                                  ),
                                                  index == order.addressIndex
                                                      ? Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color: ColorResources
                                                                  .getPrimaryColor(
                                                                      context)),
                                                        )
                                                      : SizedBox(),
                                                ]),
                                              ),
                                            );
                                          },
                                        )
                                      : Center(
                                          child: Text('No address available'))
                                  : Center(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor))),
                            ),
                            Container(
                              height: 200,
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              margin: EdgeInsets.symmetric(
                                  vertical: Dimensions.PADDING_SIZE_LARGE,
                                  horizontal: Dimensions.PADDING_SIZE_SMALL),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                color: Theme.of(context).accentColor,
                              ),
                              child: GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        37.42796133580664, -122.085749655962),
                                    zoom: 18),
                                zoomControlsEnabled: false,
                                markers: Set.of(address.addressList == null
                                    ? []
                                    : address.addressList.length == 0
                                        ? []
                                        : [
                                            Marker(
                                              markerId: MarkerId("home"),
                                              position: LatLng(
                                                double.parse(address
                                                    .addressList[
                                                        order.addressIndex]
                                                    .latitude),
                                                double.parse(address
                                                    .addressList[
                                                        order.addressIndex]
                                                    .longitude),
                                              ),
                                              icon: BitmapDescriptor
                                                  .defaultMarker,
                                            )
                                          ]),
                                onMapCreated:
                                    (GoogleMapController controller) =>
                                        _mapController = controller,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL),
                              child: Text(
                                  getTranslated('payment_method', context),
                                  style: rubikMedium.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE)),
                            ),
                            _isCashOnDeliveryActive
                                ? CustomCheckBox(
                                    title: getTranslated(
                                        'cash_on_delivery', context),
                                    index: 0)
                                : SizedBox(),
                            _isDigitalPaymentActive
                                ? CustomCheckBox(
                                    title: getTranslated(
                                        'digital_payment', context),
                                    index: _isCashOnDeliveryActive ? 1 : 0)
                                : SizedBox(),
                            // Padding(
                            //   padding:
                            //       EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            //   child: CustomTextField(
                            //     controller: _noteController,
                            //     hintText:
                            //         getTranslated('additional_note', context),
                            //     maxLines: 5,
                            //     inputType: TextInputType.multiline,
                            //     inputAction: TextInputAction.newline,
                            //     capitalization: TextCapitalization.sentences,
                            //   ),
                            // ),
                            // SizedBox(height: 20),
                            Padding(
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              child: !order.isLoading
                                  ? Builder(
                                      builder: (context) => CustomButton(
                                          width: width * 0.7,
                                          height: height * 0.06,
                                          btnTxt: getTranslated(
                                              'confirm_order', context),
                                          onTap: () {
                                            if (address.addressList == null ||
                                                address.addressList.length ==
                                                    0) {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Select an address'),
                                                      backgroundColor:
                                                          Colors.red));
                                            } else {
                                              List<Cart> carts = [];
                                              for (int index = 0;
                                                  index <
                                                      widget.cartList.length;
                                                  index++) {
                                                CartModel cart =
                                                    widget.cartList[index];
                                                carts.add(Cart(
                                                  cart.productId.toString(),
                                                  cart.discountedPrice
                                                      .toString(),
                                                  '',
                                                  cart.variation,
                                                  cart.discountAmount,
                                                  cart.quantity,
                                                  cart.taxAmount,
                                                  cart.addOnIds,
                                                ));
                                              }
                                              print(widget
                                                  .cartList[0].variation.length
                                                  .toString());
                                              order.placeOrder(
                                                PlaceOrderBody(
                                                  cart: carts,
                                                  couponDiscountAmount: Provider
                                                          .of<CouponProvider>(
                                                              context,
                                                              listen: false)
                                                      .discount,
                                                  couponDiscountTitle: '',
                                                  deliveryAddressId: Provider
                                                          .of<LocationProvider>(
                                                              context,
                                                              listen: false)
                                                      .addressList[
                                                          order.addressIndex]
                                                      .id,
                                                  orderAmount: widget.amount,
                                                  orderNote:
                                                      _noteController.text ??
                                                          '',
                                                  paymentMethod:
                                                      _isCashOnDeliveryActive
                                                          ? order.paymentMethodIndex ==
                                                                  0
                                                              ? 'cash_on_delivery'
                                                              : null
                                                          : null,
                                                ),
                                                _callback,
                                              );
                                            }
                                          }),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor))),
                            ),
                          ]);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if (isSuccess) {
      Provider.of<CartProvider>(context, listen: false).clearCartList();
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
      if (_isCashOnDeliveryActive &&
          Provider.of<OrderProvider>(context, listen: false)
                  .paymentMethodIndex ==
              0) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    OrderSuccessfulScreen(orderID: orderID, status: 0)));
      } else {
        OrderModel _orderModel = OrderModel(
          paymentMethod: '',
          id: int.parse(orderID),
          userId: Provider.of<ProfileProvider>(context, listen: false)
              .userInfoModel
              .id,
          couponDiscountAmount:
              Provider.of<CouponProvider>(context, listen: false).discount,
          createdAt: DateConverter.localDateToIsoString(DateTime.now()),
          updatedAt: DateConverter.localDateToIsoString(DateTime.now()),
          orderStatus: 'pending',
          paymentStatus: 'unpaid',
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => PaymentScreen(
                    orderModel: _orderModel, fromCheckout: true)));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }
}
