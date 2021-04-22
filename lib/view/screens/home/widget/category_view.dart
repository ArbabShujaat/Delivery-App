import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/category/category_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

List<String> categoryName = [
  "Snacks & \nmunchies",
  "Beverages",
  "Health & \nWellness",
  "Instant food",
  "Dairy & \nBakery",
  "Paan Corner"
];

class CategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
              child: TitleWidget(
                title: 'All Categories',
              ),
            ),
            SizedBox(
              height: 300,
              child: category.categoryList != null
                  ? category.categoryList.length > 0
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 10),
                          itemCount: 6,
                          // padding: EdgeInsets.only(
                          //     left: Dimensions.PADDING_SIZE_SMALL),
                          physics: NeverScrollableScrollPhysics(),
                          // scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CategoryScreen(
                                          categoryModel:
                                              category.categoryList[index]))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: 0.0,
                                ),
                                child: Column(children: [
                                  ClipOval(
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder_image,
                                      image:
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${category.categoryList[index].image}',
                                      width: 85,
                                      height: 85,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      categoryName[index],
                                      style: rubikMedium.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                              getTranslated('no_category_available', context)))
                  : CategoryShimmer(),
            ),
          ],
        );
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled:
                  Provider.of<CategoryProvider>(context).categoryList == null,
              child: Column(children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: ColorResources.COLOR_WHITE,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                    height: 10, width: 50, color: ColorResources.COLOR_WHITE),
              ]),
            ),
          );
        },
      ),
    );
  }
}
