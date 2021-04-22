import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/repository/product_repo.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo productRepo;

  ProductProvider({@required this.productRepo});

  // Latest products
  List<Product> _popularProductList;
  bool _isLoading = false;
  int _popularPageSize;
  List<String> _offsetList = [];
  List<int> _variationIndex;
  int _quantity = 1;
  List<int> _addOnIdList = [];
  List<AddOns> _addOnList = [];

  List<Product> get popularProductList => _popularProductList;

  bool get isLoading => _isLoading;

  int get popularPageSize => _popularPageSize;

  List<int> get variationIndex => _variationIndex;

  int get quantity => _quantity;

  List<int> get addOnIdList => _addOnIdList;

  List<AddOns> get addOnList => _addOnList;

  void getPopularProductList(BuildContext context, String offset) async {
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo.getPopularProductList(offset);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        if (offset == '1') {
          _popularProductList = [];
        }
        _popularProductList.addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _popularPageSize = ProductModel.fromJson(apiResponse.response.data).totalSize;
        _isLoading = false;
        notifyListeners();
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      }
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void initData(Product product) {
    _variationIndex = [];
    product.choiceOptions.forEach((element) => _variationIndex.add(0));
    _quantity = 1;
    _addOnIdList = [];
    _addOnList = [];
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity + 1;
    } else {
      _quantity = _quantity - 1;
    }
    notifyListeners();
  }

  void setCartVariationIndex(int index, int i) {
    _variationIndex[index] = i;
    notifyListeners();
  }

  void addAddOn(bool isAdd, AddOns addOns) {
    if (isAdd) {
      _addOnIdList.add(addOns.id);
      _addOnList.add(addOns);
    } else {
      _addOnIdList.remove(addOns.id);
      _addOnList.remove(addOns);
    }
    notifyListeners();
  }

  int _rating = 0;

  int get rating => _rating;

  void setRating(int rate) {
    _rating = rate;
    notifyListeners();
  }
  String _errorText;
  String get errorText => _errorText;
  void setErrorText(String error) {
    _errorText = error;
    notifyListeners();
  }
  void removeData() {
    _errorText = null;
    _rating = 0;
    notifyListeners();
  }
  Future<ResponseModel> submitReview(ReviewBody reviewBody, List<File> files, String token) async {
    _isLoading = true;
    notifyListeners();

    http.StreamedResponse response = await productRepo.submitReview(reviewBody, files, token);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      _rating = 0;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      _errorText = null;
      notifyListeners();
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
      responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }
}
