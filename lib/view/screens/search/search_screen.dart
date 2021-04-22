import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/search_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/search/search_result_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();
    Provider.of<SearchProvider>(context, listen: false).initHistoryList();

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
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_LARGE),
                child: Consumer<SearchProvider>(
                  builder: (context, searchProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(26.0),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Search items here',
                              hintcenter: true,
                              fillColor: Color(0xffdcfdff),
                              isShowSuffixIcon: true,
                              suffixIconUrl: Images.search,
                              controller: _searchController,
                              inputAction: TextInputAction.search,
                              isIcon: true,
                              onSubmit: (text) {
                                if (_searchController.text.length > 0) {
                                  searchProvider.saveSearchAddress(
                                      _searchController.text);
                                  searchProvider.searchProduct(
                                      _searchController.text, context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => SearchResultScreen(
                                          searchString:
                                              _searchController.text)));
                                }
                              },
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                getTranslated('cancel', context),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(
                                        color:
                                            ColorResources.getGreyBunkerColor(
                                                context)),
                              ))
                        ],
                      ),
                      // for resent search section
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Searchs',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(
                                    color: ColorResources.COLOR_GREY_BUNKER),
                          ),
                          // searchProvider.historyList.length > 0
                          //     ? TextButton(
                          //         onPressed: searchProvider.clearSearchAddress,
                          //         child: Text(
                          //           getTranslated('remove_all', context),
                          //           style: Theme.of(context)
                          //               .textTheme
                          //               .headline2
                          //               .copyWith(
                          //                   color: ColorResources
                          //                       .COLOR_GREY_BUNKER),
                          //         ))
                          //     : SizedBox.shrink(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // for recent search list section
                      Expanded(
                        child: ListView.builder(
                            itemCount: searchProvider.historyList.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    searchProvider.searchProduct(
                                        searchProvider.historyList[index],
                                        context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => SearchResultScreen(
                                                searchString: searchProvider
                                                    .historyList[index])));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 9),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.history,
                                                size: 25,
                                                color:
                                                    ColorResources.COLOR_HINT),
                                            SizedBox(width: 13),
                                            Text(
                                              searchProvider.historyList[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .copyWith(
                                                      color: ColorResources
                                                          .COLOR_HINT,
                                                      fontSize: 18),
                                            )
                                          ],
                                        ),
                                        Transform.rotate(
                                          angle: 5.5,
                                          child: Icon(Icons.arrow_upward,
                                              size: 20,
                                              color: ColorResources.COLOR_HINT),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      )
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
