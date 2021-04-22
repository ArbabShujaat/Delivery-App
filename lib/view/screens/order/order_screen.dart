import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/screens/order/widget/order_view.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorResources.COLOR_WHITE,
      // appBar:
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
          child: Consumer<OrderProvider>(
            builder: (context, order, child) {
              return Column(children: [
                SizedBox(
                  height: 20,
                ),
                CustomAppBar(
                  title: getTranslated('my_order', context),
                  isBackButtonExist: true,
                ),
                Container(
                  color: Theme.of(context).accentColor,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).textTheme.bodyText1.color,
                    indicatorColor: ColorResources.COLOR_PRIMARY,
                    indicatorWeight: 3,
                    unselectedLabelStyle: rubikRegular.copyWith(
                        color: ColorResources.COLOR_HINT,
                        fontSize: Dimensions.FONT_SIZE_SMALL),
                    labelStyle: rubikMedium.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL),
                    tabs: [
                      Tab(text: getTranslated('running', context)),
                      Tab(text: getTranslated('history', context)),
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: [
                    OrderView(isRunning: true),
                    OrderView(isRunning: false),
                  ],
                )),
              ]);
            },
          ),
        ),
      ),
    );
  }
}
