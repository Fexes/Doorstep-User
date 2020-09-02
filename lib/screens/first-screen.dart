import 'dart:convert';
import 'dart:io';

import 'package:Doorstep/screens/home/home_screen.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'auth/sign-in.dart';
import 'package:location/location.dart' as loc;

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

class SplashScreenState extends State<SplashScreen> {

  String UserToken;
  String loginas;
  @override
  void initState() {
    super.initState();



      final locationDbRef = FirebaseDatabase.instance.reference().child("Admin").child("Delivery");

      locationDbRef.once().then((value) async {
        print(value.value["delivery_charges"]);

          DataStream.DeliverCharges = value.value['delivery_charges'];

        final locationDbRef = FirebaseDatabase.instance.reference().child("Admin").child("Radius");

        locationDbRef.once().then((value) async {
          print(value.value["user_order_radius"]);

          DataStream.OrderRadius = value.value['user_order_radius'];


          loadData();

        }
        );


      }
      );

  }




  Future<void> addLocation() async {
   // showLoadingDialogue("Getting Location");


    getLocation().then((value) async {

      DataStream.userlocation=value;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => Home()));
    });


  }
  Future<LatLng> getLocation() async {
    LatLng userPosition;
    // print(userPosition.toString());
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();



    var geolocator = Geolocator();
    GeolocationStatus geolocationStatus =
    await geolocator.checkGeolocationPermissionStatus();
    switch (geolocationStatus) {
      case GeolocationStatus.denied:
        print('denied');
        break;
      case GeolocationStatus.disabled:
        print('disabled');break;
      case GeolocationStatus.restricted:
        print('restricted');
        break;
      case GeolocationStatus.unknown:
        print('unknown');
        break;
      case GeolocationStatus.granted:
        print('granted');



        await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((Position _position) async {
          if (_position != null) {

            userPosition = LatLng(_position.latitude, _position.longitude);

            setState((){
            });
          }
        });
        break;
    }

    return userPosition;

  }

  static FirebaseUser userD;
  Future<Timer> loadData() async {

//    Timer(
//        Duration(seconds: 3), () {
      FirebaseAuth.instance.currentUser().then((firebaseUser){



        if(firebaseUser != null){

          DataStream.UserId=firebaseUser.uid;
          DataStream.PhoneNumber=firebaseUser.phoneNumber;


        }
        _checkGps().then((value){

          if(value){
            addLocation();
          }else{
            ToastUtils.showCustomToast(context, "Location Service Disabled", false);

          }

        });


          // print(DataStream.PhoneNumber);

      });
        //    });







}
  loc.Location location = loc.Location();//explicit reference to the Location class

  Future _checkGps() async {
    if (!await location.serviceEnabled()) {
      location.requestService();
      return false;
    }else{
      return true;
    }

  }

bool error=false;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Container(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(100,100,100,30),
                child: Image.asset("assets/icons/logo.png", ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(70,30,70,30),
                child: Image.asset("assets/imgs/tag.png", ),
              ),

//              Column(
//                children: [
//                  Text( "DOORSTEP",style: TextStyle(color: Colors.black,fontSize: 42,fontWeight: FontWeight.w700,
//                  ),),
//                  SizedBox(height: 5,),
//
//                  Text( "Everything at your Doorstep",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w300),),
//                ],
//              ),

              SizedBox(height: 100,),
              error?
              SizedBox(
                width:200,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),

                  ),

                  color: primaryDark,
                  onPressed: () async {
                    error=false;
                    loadData();
                    setState(() {

                    });
                  },
                  child: Text( "Retry",style: TextStyle(color: Colors.white),),
                ),
              ):
              SpinKitFadingCircle(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index==1 ? Colors.green[900] :index==2 ?Colors.green[800] : index==3 ?Colors.green[700] : index==4 ?
                      Colors.green[600] :index==5 ?Colors.green[500] : index==6 ?Colors.green[400]:
                      index==1 ?Colors.green[300] : index==1 ?Colors.green[200] : index==1 ?Colors.green[100] : index==1 ?
                      Colors.green[100] :index==1 ?Colors.green[100] :Colors.green[900]
                      ,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  );
                },
              ),
            ],
          )),
        // color

    );
  }



}

