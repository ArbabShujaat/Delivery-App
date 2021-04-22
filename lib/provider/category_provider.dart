import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/repository/category_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;

  CategoryProvider({@required this.categoryRepo});

  List<CategoryModel> _categoryList;
  List<CategoryModel> _subCategoryList;
  List<Product> _categoryProductList;

  List<CategoryModel> get categoryList => _categoryList;
  List<CategoryModel> get subCategoryList => _subCategoryList;
  List<Product> get categoryProductList => _categoryProductList;

  void getCategoryList(BuildContext context) async {
    if (_categoryList == null) {
      ApiResponse apiResponse = await categoryRepo.getCategoryList();
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _categoryList = [];
        apiResponse.response.data.forEach(
            (category) => _categoryList.add(CategoryModel.fromJson(category)));
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
  }

  void getSubCategoryList(BuildContext context, String categoryID) async {
    _subCategoryList = null;
    notifyListeners();
    ApiResponse apiResponse = await categoryRepo.getSubCategoryList(categoryID);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _subCategoryList = [];
      apiResponse.response.data.forEach(
          (category) => _subCategoryList.add(CategoryModel.fromJson(category)));
      getCategoryProductList(context, categoryID);
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  void getCategoryProductList(BuildContext context, String categoryID) async {
    _categoryProductList = null;
    notifyListeners();
    ApiResponse apiResponse =
        await categoryRepo.getCategoryProductList(categoryID);
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _categoryProductList = [];
      apiResponse.response.data.forEach(
          (category) => _categoryProductList.add(Product.fromJson(category)));
      notifyListeners();
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
    }
  }

  int _selectCategory = -1;

  int get selectCategory => _selectCategory;

  updateSelectCategory(int index) {
    _selectCategory = index;
    notifyListeners();
  }
}
