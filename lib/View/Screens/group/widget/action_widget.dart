import 'package:flocdock/constants/constants.dart';
import 'package:flocdock/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
Widget ActionWidget({required String icon,required String text, Color color=KWhite,void Function()? onTap})
{
  return GestureDetector(
    onTap: onTap,
    child: Column(
        children:[
          SvgPicture.asset(icon,color: color,width: 18,height: 18,),
          SizedBox(height: 5,),
          Text(text,style: proximaBold.copyWith(color: color,)),
        ]
    ),
  );
}