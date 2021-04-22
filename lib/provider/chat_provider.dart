import 'dart:io';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/model/response/chat_model.dart';
import 'package:flutter_restaurant/data/repository/chat_repo.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo chatRepo;
  ChatProvider({@required this.chatRepo});

  List<ChatModel> _chatList;
  File _imageFile;
  bool _isSendButtonActive = false;

  List<ChatModel> get chatList => _chatList;
  File get imageFile => _imageFile;
  bool get isSendButtonActive => _isSendButtonActive;

  void getChatList(BuildContext context) async {
    _chatList = null;
    notifyListeners();
    ApiResponse apiResponse = await chatRepo.getChatList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _chatList = [];
      apiResponse.response.data[0].forEach((chat) => _chatList.add(ChatModel.fromJson(chat)));
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  void sendMessage(String message, String token, String userID, BuildContext context) async {
    http.StreamedResponse response = await chatRepo.sendMessage(message, _imageFile, token);
    if (response.statusCode == 200) {
      getChatList(context);
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    _imageFile = null;
    _isSendButtonActive = false;
    notifyListeners();
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setImage(File image) {
    _imageFile = image;
    _isSendButtonActive = true;
    notifyListeners();
  }

  void removeImage(String text) {
    _imageFile = null;
    text.isEmpty ? _isSendButtonActive = false : _isSendButtonActive = true;
    notifyListeners();
  }

}