import 'package:Doorstep/models/Addresses.dart';
import 'package:Doorstep/styles/styles.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'DataStream.dart';


class AddLocationDialogue extends StatefulWidget {




  @override
  _AddLocationDialogue createState() => new _AddLocationDialogue();
}


class _AddLocationDialogue extends State<AddLocationDialogue> {
  final addresscontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {

  
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
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                "Add Location",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(

                controller: addresscontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name i.e. Home, Work etc.',

                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),

                ),
              ),
              SizedBox(height: 16.0),

              FlatButton(
                onPressed: () {

                     addLocation().then((value) {


                      setState(() {

                      });


                    });





                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on),
                    Text(PickedAddress),
                    Icon(Icons.location_on,color: Colors.white,),

                  ],
                ),
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
                      child: Text("Cancel",style: TextStyle(color: Colors.red),),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {

                        AddressKey= addresscontroller.text;

                        if((AddressKey!=""||AddressKey!=null)&&PickedAddress!="Pick Location") {
                          FirebaseDatabase database = new FirebaseDatabase();
                          DatabaseReference db = database.reference()
                              .child('Users').child(DataStream.UserId).child("addresses").child(
                              AddressKey);

                          db.set(<dynamic, dynamic>{
                            'location': "${PickedLocation.latitude},${PickedLocation.longitude}",
                            'address': PickedAddress,

                          }).then((value) {
                            setState(() {

                            });
                          });
                        }else{
                          FocusScope.of(context).requestFocus(FocusNode());

                          ToastUtils.showCustomToast(
                              context, "Please add Address Name\nand Select Location", false);
                        }



                      },
                      child: Text("Save"),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),


      ],
    );


  }


  String AddressKey="";
  String PickedAddress="Pick Location";
  LatLng PickedLocation;


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
 