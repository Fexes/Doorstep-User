import 'package:naqelapp/custom_drawer/trader_drawer.dart';
import 'package:naqelapp/custom_drawer/trader_drawer_user_controller.dart';
import 'package:naqelapp/screens/home/trader/trader_profile_screen.dart';
import 'package:naqelapp/styles/app_theme.dart';
import 'package:naqelapp/custom_drawer/driver_drawer_user_controller.dart';
import 'package:naqelapp/screens/home/driver/driver_jobs_screen.dart';

import 'package:flutter/material.dart';




class TraderNavigationHomeScreen extends StatefulWidget {
  @override
  _TraderNavigationHomeScreenState createState() => _TraderNavigationHomeScreenState();
}

class _TraderNavigationHomeScreenState extends State<TraderNavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;
 // AnimationController sliderAnimationController;

  @override
  void initState() {
    drawerIndex = DrawerIndex.PROFILE;
    screenView = const TraderProfilePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: TraderDrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,

            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.JOBS) {
        setState(() {
       //   screenView = const DriverHomePage();
        });
      } else if (drawerIndex == DrawerIndex.PROFILE) {
        setState(() {
          screenView = const TraderProfilePage();

        });
      }
      else if (drawerIndex == DrawerIndex.PAYMENTS) {
        setState(() {
        // screenView = const TruckPage();
        });
      }


      else {
        //do in your way......
      }
    }
  }
}

