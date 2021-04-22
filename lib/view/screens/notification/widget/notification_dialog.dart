import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/notification_model.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:provider/provider.dart';

class NotificationDialog extends StatelessWidget {
  final NotificationModel notificationModel;
  NotificationDialog({@required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          Container(
            height: 70, width: 70,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor.withOpacity(0.20)),
            child: ClipOval(
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder_image,
                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.notificationImageUrl}/${notificationModel.image}',
                height: 70, width: 70, fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              notificationModel.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1.copyWith(
                color: ColorResources.getGreyBunkerColor(context).withOpacity(.75),
              ),
            ),
          )
        ],
      ),
    );
  }
}
