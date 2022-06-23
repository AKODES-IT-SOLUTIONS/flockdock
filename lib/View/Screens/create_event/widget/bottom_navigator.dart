import 'package:flocdock/View/Widgets/my_button.dart';
import 'package:flocdock/View/Widgets/my_text.dart';
import 'package:flocdock/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget BottomNavigator({
  bool isLeading=true,
  String trailing="NEXT",
  int selected=1,
  void Function()? onTapLeading,
  void Function()? onTapTrailing,
}) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding:  EdgeInsets.only(bottom: GetPlatform.isIOS?8.0:0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onTapLeading,
            child: MyText(
              text: "PREVIOUS",
              color: isLeading?KWhite:KbgBlack,
            ),
          ),
          Row(
            children: [
              for(int i=1;i<=4;i++)
                Container(
                  height: 5,
                  width: 5,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected==i?KBlue:KDullBlack,
                  ),
                )
            ],
          ),
          MyButton(
            text: trailing,
            textColor: KWhite,
            buttonColor: KBlue,
            buttonHight: 30.0,
            buttonWidth: 80.0,
            onPressed: onTapTrailing,
          )

        ],
      ),
    ),
  );
}