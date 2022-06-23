import 'package:flocdock/View/Widgets/my_spacing.dart';
import 'package:flocdock/View/Widgets/my_text.dart';
import 'package:flocdock/constants/constants.dart';
import 'package:flocdock/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget EventCategory({
  required String img,
  required String groupName,
  bool isSelected=false,
}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSelected?KBlue:KbgBlack,width: 2),
        image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover)),
    child: Padding(
      padding: const EdgeInsets.only(top: 50, right: 5, left: 5, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: groupName,
            fontFamily: "Proxima",
            color: KWhite,
            weight: FontWeight.w800,
            size: 18,
          ),
        ],
      ),
    ),
  );
}
