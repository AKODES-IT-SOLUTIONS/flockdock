import 'package:flocdock/View/Screens/Home/home_page.dart';
import 'package:flocdock/View/Screens/discover/discover_page.dart';
import 'package:flocdock/View/Screens/favorite/favorite.dart';
import 'package:flocdock/View/Screens/inbox/inbox_page.dart';
import 'package:flocdock/View/Widgets/my_spacing.dart';
import 'package:flocdock/View/Widgets/my_text.dart';
import 'package:flocdock/constants/constants.dart';
import 'package:flocdock/constants/images.dart';
import 'package:flocdock/mixin/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';


class BottomBar extends StatefulWidget {
  int pageIndex;
  BottomBar({Key? key,this.pageIndex=0}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int pageIndex=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageIndex=widget.pageIndex;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: GetPlatform.isIOS? 68:60,
      color: KPureBlack,
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding:  EdgeInsets.only(bottom: GetPlatform.isIOS?10.0:0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: (){
                pageIndex=0;
                  Get.to(HomePage());
              },
              child: Column(
                children: [
                  SvgPicture.asset(Images.nearby,color: pageIndex == 0?KWhite:Kunactive,),
                  spaceVertical(5),
                  MyText(
                    text: "Nearby",
                    color: pageIndex == 0?KWhite:Kunactive,
                    size: pageIndex == 0?15:12,
                  )

                ],
              ),
            ),
            InkWell(
              onTap: (){
                  pageIndex = 1;
                  Get.to(InboxPage());
              },
              child: Column(
                children: [
                  SvgPicture.asset(Images.inbox,color: pageIndex == 1?KWhite:Kunactive,),
                  spaceVertical(5),
                  MyText(
                    text: "Inbox",
                    color: pageIndex == 1?KWhite:Kunactive,
                    size: pageIndex == 1?15:12,
                  )

                ],
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  pageIndex = 2;
                  Get.to(DiscoverPage());
                });
              },
              child: Column(
                children: [
                  SvgPicture.asset(Images.discover,color: pageIndex == 2?KWhite:Kunactive,),
                  spaceVertical(5),
                  MyText(
                    text: "Discover",
                    color: pageIndex == 2?KWhite:Kunactive,
                    size: pageIndex == 2?15:12,
                  )

                ],
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  pageIndex = 3;
                  Get.to(FavoritePage());
                });
              },
              child: Column(
                children: [
                  SvgPicture.asset(Images.favourites,color: pageIndex == 3?KWhite:Kunactive,),
                  spaceVertical(5),
                  MyText(
                    text: "Favourites",
                    color: pageIndex == 3?KWhite:Kunactive,
                    size: pageIndex == 3?15:12,
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}


