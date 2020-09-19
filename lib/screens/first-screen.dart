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
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'auth/sign-in.dart';
import 'package:location/location.dart' as loc;
import 'package:launch_review/launch_review.dart';

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
  Future<void> initState()  {
    super.initState();

   start();

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

        _checkGps().then((value) {


            if(value){
            //  ToastUtils.showCustomToast(context, "Getting Location", null);
            }else{

              ToastUtils.showCustomToast(context, "Location Service Disabled", false);

            }

        }).whenComplete(() {

          addLocation();

        });

        // _checkGps().then((value){
        //   if(value){
        //     addLocation();
        //   }else{
        //
        //     ToastUtils.showCustomToast(context, "Location Service Disabled", false);
        //
        //   }
        //
        // });


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


              updateavail?
              Column(
                children: [
                  SizedBox(
                    width:300,
                    child: FlatButton(

                      color: Colors.white,

                      child: Text( "A new version of Doorstep is available. Please Update the App" ,textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w300,
                      ),),
                    ),
                  ),
                  SizedBox(height: 10,),


                   SizedBox(
                    width:200,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),

                      ),

                      color: primaryDark,
                      onPressed: () async {

                        LaunchReview.launch(androidAppId:"com.doorstep.app",
                            iOSAppId: "1:391131119962:ios:7800a1fb8c2e8cfcdcf363");

                        setState(() {

                        });
                      },
                      child: Text( "Update App",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
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
              // SizedBox(
              //   width:300,
              //   child: FlatButton(
              //
              //     color: Colors.white,
              //
              //     child: Text( "The App is Under Maintenance" ,textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w300,
              //     ),),
              //   ),
              // ),

              SizedBox(height: 5,),
              SizedBox(
                width:300,
                child: FlatButton(

                  color: Colors.white,
                  onPressed: () async {
                    error=false;
                    loadData();
                    setState(() {

                    });
                  },
                  child: Text( "Version    $appVersion" ,textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w200,
                  ),),
                ),
              ),

            ],
          )),
        // color

    );
  }

  String appVersion="";
  String code="";

  bool updateavail=false;
  bool maintenance=false;

  Future<void> start() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.buildNumber;

     appVersion = packageInfo.version;
    setState(() {

    });

    print(versionName);

    final versionDbRef = FirebaseDatabase.instance.reference().child("Admin").child("AppVersion");

    versionDbRef.once().then((value) async {


      code=value.value["version_code"];

      if(code=="maintenance"){
        maintenance=true;

      }else {
        maintenance=false;
        if (int.parse(value.value["version_code"]) > int.parse(versionName)) {
          updateavail = true;
          setState(() {

          });
        } else {
          updateavail = false;
          setState(() {

          });
          final locationDbRef = FirebaseDatabase.instance.reference().child(
              "Admin").child("Delivery");

          locationDbRef.once().then((value) async {
            print(value.value["delivery_charges"]);

            DataStream.DeliverCharges = value.value['delivery_charges'];

            final locationDbRef = FirebaseDatabase.instance.reference().child(
                "Admin").child("Radius");

            locationDbRef.once().then((value) async {
              print(value.value["user_order_radius"]);

              DataStream.OrderRadius = value.value['user_order_radius'];


              loadData();
            }
            );
          }
          );
        }
      }




    }
    );
  }



}




