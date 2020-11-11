import 'dart:convert';
import 'dart:io';

import 'package:Doorstep/models/AppUser.dart';
import 'package:Doorstep/screens/home/home_screen.dart';
import 'package:Doorstep/screens/location-screen.dart';
import 'package:Doorstep/styles/styles.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/styles/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'auth/sign-in.dart';
import 'package:location/location.dart' as loc;
import 'package:launch_review/launch_review.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  String UserToken;
  String loginas;
  @override
  Future<void> initState()  {
    super.initState();

    _controller = AnimationController(vsync: this);

  }

  AnimationController _controller;


  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Container(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,0,0,20),
                    child: Container(
                        height: 200 ,
                        width: 200,
                        child:  Lottie.asset('assets/logo.json',repeat: true,  frameRate: FrameRate.max,controller: _controller,
                          onLoaded: (composition) {
                            _controller
                              ..duration = composition.duration
                              ..forward();
                            _controller.addStatusListener((status) {

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LocationScreen()));

                            });

                          },
                        ),



                    ),

                    //Image.asset("assets/icons/logo.png", ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(70,10,70,10),
                    child: Image.asset("assets/imgs/tag.png", ),
                  ),
                ],
              ),

            ],
          )),
        // color

    );
  }





}


