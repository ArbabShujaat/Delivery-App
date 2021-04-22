import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/set_menu_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';

class SetMenuProvider extends ChangeNotifier {
  final SetMenuRepo setMenuRepo;
  SetMenuProvider({@required this.setMenuRepo});

  List<Product> _setMenuList;
  List<Product> get setMenuList => _setMenuList;

  void getSetMenuList(BuildContext context) async {
    if(setMenuList == null) {
      ApiResponse apiResponse = await setMenuRepo.getSetMenuList();
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _setMenuList = [];
        apiResponse.response.data.forEach((setMenu) => _setMenuList.add(Product.fromJson(setMenu)));
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
      notifyListeners();
    }
  }
}