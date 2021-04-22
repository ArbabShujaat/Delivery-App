import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/set_menu_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/banner_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/brand_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/category_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/product_view.dart';
import 'package:flutter_restaurant/view/screens/home/widget/set_menu_view.dart';
import 'package:flutter_restaurant/view/screens/notification/notification_screen.dart';
import 'package:flutter_restaurant/view/screens/search/search_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(context);
    Provider.of<SetMenuProvider>(context, listen: false)
        .getSetMenuList(context);
    Provider.of<BannerProvider>(context, listen: false).getBannerList(context);

    return Scaffold(
      // backgroundColor: ColorResources.getBackgroundColor(context),
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
        child: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar
              SliverPadding(
                padding: const EdgeInsets.only(top: 18.0),
              ),
              SliverAppBar(
                floating: false,
                elevation: 0,
                centerTitle: true,
                leadingWidth: 120,
                leading: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        'India',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),

                    // Container(
                    //   width: 60,
                    //   child: ListView(
                    //     scrollDirection: Axis.horizontal,
                    //     children: [
                    //       DropdownButtonHideUnderline(
                    //         child: DropdownButton(
                    //             hint: Text(
                    //               'Location',
                    //               style: TextStyle(fontSize: 8),
                    //             ),

                    //             // value: ,

                    //             items: [
                    //               DropdownMenuItem(
                    //                 child: Flexible(
                    //                   fit: FlexFit.tight,
                    //                   child: Text(
                    //                     'Karachi',
                    //                   ),
                    //                 ),
                    //                 value: 1,
                    //               ),
                    //               DropdownMenuItem(
                    //                 child: Flexible(
                    //                   fit: FlexFit.tight,
                    //                   child: Text(
                    //                     'Lahore',
                    //                   ),
                    //                 ),
                    //                 value: 2,
                    //               ),
                    //               DropdownMenuItem(
                    //                 child: Flexible(
                    //                   fit: FlexFit.tight,
                    //                   child: Text(
                    //                     'Multan',
                    //                   ),
                    //                 ),
                    //                 value: 3,
                    //               ),
                    //             ],
                    //             onChanged: (value) {}),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                backgroundColor: Colors.transparent,
                title: Image.asset(Images.logo, width: 50, height: 50),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => NotificationScreen())),
                    icon: Icon(Icons.notifications,
                        color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: 18.0),
              ),
              // Search Button
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                ),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(
                      child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SearchScreen()));
                    },
                    child: Container(
                      height: 50,
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                          vertical: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffdcfdff),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(children: [
                          Expanded(
                              child: Text('Search items here',
                                  textAlign: TextAlign.center,
                                  style: rubikRegular.copyWith(fontSize: 12))),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL),
                              child: Icon(Icons.search, size: 25)),
                        ]),
                      ),
                    ),
                  )),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<BannerProvider>(
                        builder: (context, banner, child) {
                          return banner.bannerList == null
                              ? BannerView()
                              : banner.bannerList.length == 0
                                  ? SizedBox()
                                  : BannerView();
                        },
                      ),
                      Consumer<CategoryProvider>(
                        builder: (context, category, child) {
                          return category.categoryList == null
                              ? CategoryView()
                              : category.categoryList.length == 0
                                  ? SizedBox()
                                  : CategoryView();
                        },
                      ),
                      Consumer<CategoryProvider>(
                        builder: (context, category, child) {
                          return category.categoryList == null
                              ? BrandView()
                              : category.categoryList.length == 0
                                  ? SizedBox()
                                  : BrandView();
                        },
                      ),
                      // Consumer<SetMenuProvider>(
                      //   builder: (context, setMenu, child) {
                      //     return setMenu.setMenuList == null
                      //         ? SetMenuView()
                      //         : setMenu.setMenuList.length == 0
                      //             ? SizedBox()
                      //             : SetMenuView();
                      //   },
                      // ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TitleWidget(
                                title: getTranslated('popular_item', context)),
                            Text('View All'),
                          ],
                        ),
                      ),
                      ProductView(
                          productType: ProductType.POPULAR_PRODUCT,
                          scrollController: _scrollController),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
