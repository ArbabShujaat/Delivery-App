import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

class CustomButton extends StatelessWidget {
  final Function onTap;
  final String btnTxt;
  final Color backgroundColor;
  final double width;
  final double height;
  final bool transparent;
  final bool textColor;
  CustomButton({
    this.onTap,
    @required this.btnTxt,
    this.backgroundColor,
    this.width,
    this.height,
    this.transparent = false,
    this.textColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // height: ,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Container(
          width: width,
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: transparent ? Colors.transparent : Color(0xff128b94),
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: FlatButton(
            onPressed: onTap,
            height: 50,
            minWidth: MediaQuery.of(context).size.width,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: backgroundColor == null
                ? Theme.of(context).primaryColor
                : backgroundColor,
            padding: EdgeInsets.all(0),
            disabledColor: ColorResources.getGreyColor(context),
            child: Text(btnTxt ?? "",
                style: Theme.of(context).textTheme.headline3.copyWith(
                    color:
                        textColor ? Colors.black : ColorResources.COLOR_WHITE,
                    fontSize: Dimensions.FONT_SIZE_LARGE)),
          ),
        ),
      ),
    );
  }
}
