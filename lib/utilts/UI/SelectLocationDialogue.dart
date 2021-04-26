import 'package:Doorstep/models/Addresses.dart';
import 'package:Doorstep/screens/auth/sign-in.dart';
import 'package:Doorstep/screens/location-screen.dart';
import 'package:Doorstep/styles/styles.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glutton/glutton.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'AddLocationDialogue.dart';
import 'DataStream.dart';


class SelectLocationDialogue extends StatefulWidget {




  @override
  _SelectLocationDialogue createState() => new _SelectLocationDialogue();
}


class _SelectLocationDialogue extends State<SelectLocationDialogue> {

  bool allAddressedAdded=false;
  Color selectedColor=const Color(0x3300ff72);
  @override
  Widget build(BuildContext context) {

  //  print("DataStream.addresses.length ${DataStream.addresses.length}");
    if(DataStream.addresses.length==3){
      allAddressedAdded=true;
    //  print("allAddressedAdded ${allAddressedAdded}");

    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 24.0+ 16.0,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          margin: EdgeInsets.only(top: 90.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  "Change Location",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: DataStream.addresses.map((Addresses address){
                    return

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: GestureDetector(
                          onTap: () async {

                            bool isSuccess = await Glutton.eat("SavedAddress", address.key);


                            DataStream.userlocation=new LatLng(double.parse(address.location.split(",")[0]), double.parse(address.location.split(",")[1]));

                            DataStream.userAddress=address.address;
                            ToastUtils.showCustomToast(context, "${address.key} Selected",true);
                            DataStream.savedAddresskey=address.key;
                            if(isSuccess) {
                              Navigator.of(context).pop();
                            }



                          },
                          child: Container(
                            decoration: BoxDecoration(
                            //  color:const Color(0x3300ff72),
                              color:address.key==DataStream.savedAddresskey? Colors.green.shade200:Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  address.key.toLowerCase().contains("home")?Icon(Icons.home):
                                  address.key.toLowerCase().contains("work")?Icon(Icons.work):
                                  Icon(Icons.location_on),

                                  Column(
                                    children: [
                                      Text(
                                        address.key,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 5,),

                                      Container(
                                        width: screenWidth(context)/2,

                                        child: Text(
                                          address.address,
                                          maxLines: 4,
                                          style: TextStyle(

                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w300,

                                          ),
                                        ),
                                      ),
                                    ],
                                  ),


                                  SizedBox(width: 2,),


                                ],
                              ),
                            ),
                          ),
                        ),
                      );

                  }).toList(),
                ),
                allAddressedAdded?SizedBox():
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    GestureDetector(


                        onTap: () {

                          setState(() {

                          });
                          showDialog(context: context,
                              builder: (BuildContext context) {
                                return AddLocationDialogue(
                                  // title: "Charge Location",
                                  // description: "Base Delivery Charges are Rs.${DataStream.DeliverCharges}, Delivery Charges for Pharmacies are Rs.${DataStream.DeliverChargesPharmacy} and Delivery Charges for each addition shop are Rs.${DataStream.delivery_charges_per_shop}",
                                  // orderId: "# " ,
                                  //  buttonText: "Ok",
                                  // context:context

                                );
                              }
                          ).then((value) {

                            setState(() {

                            });
                          });





                        },
                        child: Icon(Icons.add_circle,color: Colors.green,)),
                    FlatButton(
                      onPressed: () {

                        setState(() {

                        });
                        showDialog(context: context,
                            builder: (BuildContext context) {
                              return AddLocationDialogue(
                                // title: "Charge Location",
                                // description: "Base Delivery Charges are Rs.${DataStream.DeliverCharges}, Delivery Charges for Pharmacies are Rs.${DataStream.DeliverChargesPharmacy} and Delivery Charges for each addition shop are Rs.${DataStream.delivery_charges_per_shop}",
                                // orderId: "# " ,
                                //  buttonText: "Ok",
                                // context:context

                              );
                            }
                        ).then((value) {

                          setState(() {

                          });
                        });





                      },
                      child: Text("Add New Location"),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text("Edit Addresses in Profile Tab",style: TextStyle(color: Colors.grey,fontSize: 12),),
                SizedBox(height: 5,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        color: Colors.blue.shade50,
                        onPressed: () {

                          addLocation().then((value) {
                            Navigator.of(context).pop();

                          });


                        },
                        child: Text("Pick Location",style: TextStyle(color: Colors.blue),),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        color: Colors.deepPurple.shade50,

                        onPressed: () async {

                          bool s =await Glutton.flush();
                          bool isSuccess = await Glutton.eat("SavedAddress", "Current Location");

                          if(s){
                            bool isSuccess = await Glutton.eat("SavedAddress", "Current Location");

                            if(isSuccess){
                              DataStream.userlocation=null;
                              DataStream.userAddress="Current Location";
                              Navigator.of(context).pop();

                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LocationScreen()));

                            }

                          }



                        },
                        child: Text("Current Location",style: TextStyle(color: Colors.deepPurple),),
                      ),
                    ),

                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {

                          Navigator.of(context).pop();


                        },
                        child: Text("Dismiss",style: TextStyle(color: Colors.red),),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),


      ],
    );


  }


 static String PickedAddress="";
  static LatLng PickedLocation;

  // String PickedAddressKeyHome="Home";
  // String PickedAddressKeyWork="Work";
  // String PickedAddressKeyOther="Other";
  //
  // String PickedAddressHome="Set Home Address";
  // LatLng PickedLocationHome;
  //
  // String PickedAddressWork="Set Work Address";
  // LatLng PickedLocationWork;
  //
  // String PickedAddressOther="Set Other Address";
  // LatLng PickedLocationOther;
  Future<void> addLocation() async {


    LocationResult result = await showLocationPicker(
        context,
        DataStream.googleAPIKey,

        // appBarColor: Colors.green,
        initialCenter: DataStream.userlocation,
        myLocationButtonEnabled: true,
        automaticallyAnimateToCurrentLocation: true

    );
    print("result = $result");
    if(result!=null){

      //  Navigator.of(context).pop();

      //   errorDialog.p

      PickedAddress=result.address;
      PickedLocation=result.latLng;

      DataStream.userlocation=PickedLocation;
      DataStream.userAddress=PickedAddress;

      print(PickedAddress);

    }
  }

}
 