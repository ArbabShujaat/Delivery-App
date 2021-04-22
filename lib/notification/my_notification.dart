import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class MyNotification {
  static Future<void> showNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    if(message['data']['image'] != null && message['data']['image'].isNotEmpty) {
      try{
        await showBigPictureNotificationHiddenLargeIcon(message, fln);
      }catch(e) {
        await showBigTextNotification(message, fln);
      }
    }else {
      await showBigTextNotification(message, fln);
    }
  }

  static Future<void> showTextNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message['data']['title'];
    String _body = message['data']['body'];
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description', sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max, priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: 'Custom_Sound');
  }

  static Future<void> showBigTextNotification(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message['data']['title'];
    String _body = message['data']['body'];
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      _body, htmlFormatBigText: true,
      contentTitle: _title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id', 'big text channel name', 'big text channel description', importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.high, sound: RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: 'Custom_Sound');
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message['data']['title'];
    String _body = message['data']['body'];
    String _image = message['data']['image'];
    final String largeIconPath = await _downloadAndSaveFile(_image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(_image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: _title, htmlFormatContentTitle: true,
      summaryText: _body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id', 'big text channel name', 'big text channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.high, sound: RawResourceAndroidNotificationSound('notification'),
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, _title, _body, platformChannelSpecifics, payload: 'Custom_Sound');
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }

}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print('background: $message}');
  var androidInitialize = new AndroidInitializationSettings('notification_icon');
  var iOSInitialize = new IOSInitializationSettings();
  var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  MyNotification.showNotification(message, flutterLocalNotificationsPlugin);
}