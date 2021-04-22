import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_restaurant/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:http/http.dart' as http;

class ProductRepo {
  final DioClient dioClient;

  ProductRepo({@required this.dioClient});

  Future<ApiResponse> getPopularProductList(String offset) async {
    try {
      final response = await dioClient.get('${AppConstants.POPULAR_PRODUCT_URI}?limit=10&&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> searchProduct(String productId) async {
    try {
      final response = await dioClient.get('${AppConstants.SEARCH_PRODUCT_URI}$productId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> submitReview(ReviewBody reviewBody, List<File> files, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.REVIEW_URI}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    for (int index = 0; index < 3; index++) {
      if (files[index].path.isNotEmpty) {
        request.files.add(http.MultipartFile(
          'fileUpload[$index]',
          files[index].readAsBytes().asStream(),
          files[index].lengthSync(),
          filename: files[index].path.split('/').last,
        ));
      }
    }
    request.fields.addAll(<String, String>{'product_id': reviewBody.productId, 'comment': reviewBody.comment, 'rating': reviewBody.rating});
    http.StreamedResponse response = await request.send();
    print(response.reasonPhrase);
    return response;
  }
}
