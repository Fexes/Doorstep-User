import 'dart:convert';
import 'dart:io';

import 'package:Doorstep/models/AppUser.dart';
import 'package:Doorstep/models/message.dart';
import 'package:Doorstep/screens/home/home_screen.dart';
import 'package:Doorstep/screens/location-screen.dart';
import 'package:Doorstep/styles/styles.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _getToken() {
    _firebaseMessaging.getToken().then((token) {
        print("Device Token: $token");
      DataStream.userTokenID=token;

    });
  }

  List<Message> messagesList;

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _setMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _setMessage(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _setMessage(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }
  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    String mMessage = data['message'];
    print("Title: $title, body: $body, message: $mMessage");
    setState(() {
      Message msg = Message(title, body, mMessage);
      messagesList.add(msg);
    });
  }
  String UserToken;
  String loginas;
  @override
  Future<void> initState()  {
    super.initState();
    _getToken();
    _configureFirebaseListeners();
   // _controller = AnimationController();
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

                    //Image.asset("assets/icons/dslogo.png", ),
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


