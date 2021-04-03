import 'dart:convert';
import 'dart:io';

import 'package:Doorstep/models/Addresses.dart';
import 'package:Doorstep/models/AppUser.dart';
import 'package:Doorstep/screens/home/home_screen.dart';
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
    home: LocationScreen(),
  ));
}

class LocationScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return LocationScreenState();
  }
}

class LocationScreenState extends State<LocationScreen> {

  String UserToken;
  String loginas;
  @override
  Future<void> initState()  {
    super.initState();



    // for(int i=901;i<=1050;i++){
    //   //Code128
    //   print("Doorstep0000$i");
    // }

   start();

  }




  Future<void> addLocation() async {
   // showLoadingDialogue("Getting Location");


    getLocation().then((value) async {

      DataStream.userlocation=value;
     // DataStream.userAddress=value.;

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

  String userTokenID;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  static FirebaseUser userD;

  Future<Timer> loadData() async {

    DataStream.addresses = new List();

//    Timer(
//        Duration(seconds: 3), () {
      FirebaseAuth.instance.currentUser().then((firebaseUser){




        if(firebaseUser != null){

          DataStream.UserId=firebaseUser.uid;
          DataStream.PhoneNumber=firebaseUser.phoneNumber;




          final userDbRef = FirebaseDatabase.instance.reference().child("Users").child(DataStream.UserId);

          userDbRef.once().then((value) async {
            if(value.value!=null){

              DataStream.appuser= new AppUser(value.value["first_name"], value.value["last_name"],value.value["phone"] , value.value["email"],value.value["userTokenID"]);


              _firebaseMessaging.getToken().then((token) {
                //  print("Device Token: $token");
                userTokenID=token;
                FirebaseDatabase database = new FirebaseDatabase();
                DatabaseReference db = database.reference()
                    .child('Users').child(DataStream.UserId);

                db.update({
                  'userTokenID':token,
                });

                // db.set(<dynamic, dynamic>{
                //   'first_name':  DataStream.appuser.first_name,
                //   'last_name':  DataStream.appuser.last_name,
                //   'phone':  DataStream.appuser.phone,
                //   'email':  DataStream.appuser.email,
                //
                //   // 'first_name':  " ",
                //   // 'last_name': " ",
                //   // 'phone': "+921234567890",
                //   // 'email':  " ",
                //   'userTokenID':token,
                //
                // }).then((value) {
                //   print("Token Set");
                // });

              });

              final locationDbRef = FirebaseDatabase.instance.reference().child("Users").child(DataStream.UserId).child("addresses");
              locationDbRef.onChildAdded.listen((event) {

                DataStream.addresses.add(Addresses.fromSnapshot(event.snapshot));

                print(Addresses.fromSnapshot(event.snapshot).key);
              });


              setState(() {

              });
            }
            
          }
          );
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

  void getUserDetails(){




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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 10,),

              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,0,0,updateavail?55:0),
                    child: Container(
                        height: 200 ,
                        width: 200,
                        child:  Lottie.asset(updateavail?'assets/update.json':'assets/location.json',repeat: true,fit: BoxFit.scaleDown),



                    ),

                    //Image.asset("assets/icons/logo.png", ),
                  ),
                  FlatButton(

                    color: Colors.white,
                    onPressed: () async {
                      error=false;
                      loadData();
                      setState(() {

                      });
                    },
                    child: Text( updateavail?"Update Available":
                        "Getting Location" ,textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 32,fontWeight: FontWeight.w100,
                    ),),
                  ),
                ],
              ),


              Column(children: [
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
                              iOSAppId: "1538598183");

                          setState(() {

                          });
                        },
                        child: Text( "Update App",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ):

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/icons/logo.png",height: 23,width: 23, ),

                    SpinKitFadingCircle(
                      size: 60,
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
                SizedBox(height: 15,),

              ],),



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
            DataStream.DeliverChargesPharmacy = value.value['delivery_charges_pharmacy'];
            DataStream.delivery_charges_per_shop = value.value['delivery_charges_per_shop'];

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


