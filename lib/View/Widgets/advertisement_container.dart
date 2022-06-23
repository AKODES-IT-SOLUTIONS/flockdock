
import 'package:flocdock/constants/styles.dart';
import 'package:flutter/material.dart';

Widget AdvertisementContainer({
  required BuildContext context,String name="",
})
{
  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      decoration: BoxDecoration(
          color: const Color(0XFFC4C4C4),
          borderRadius: BorderRadius.circular(10)
      ),
      height: MediaQuery.of(context).size.height*0.1,
      width: double.infinity,
      child:  Center(child: Text("Advertisement",style: proximaBold.copyWith(color: Colors.black,),)),
    ),
  );
}