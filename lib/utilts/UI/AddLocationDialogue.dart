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
  final addressnamecontroller = TextEditingController();

  String selectedicon="";

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
              SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Column(
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        child: FloatingActionButton(
                          onPressed:() {
                            setState(() {
                              selectedicon="home";

                            });
                          },
                          backgroundColor: selectedicon=="home"?Colors.green:Colors.grey,
                          child: const Icon(Icons.home),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text("Home",style: TextStyle(color: selectedicon=="home"?Colors.green:Colors.grey),),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        child: FloatingActionButton(
                          onPressed:() {
                            setState(() {
                              selectedicon="work";

                            });
                          },
                          backgroundColor: selectedicon=="work"?Colors.green:Colors.grey,
                          child: const Icon(Icons.work),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text("Work",style: TextStyle(color: selectedicon=="work"?Colors.green:Colors.grey),),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 50.0,
                        height: 50.0,
                        child: FloatingActionButton(

                          onPressed:() {
                            setState(() {
                              selectedicon="other";

                            });
                          },
                          backgroundColor: selectedicon=="other"?Colors.green:Colors.grey,

                          // tooltip: 'Increment',
                          child: const Icon(Icons.location_on),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text("Other",style: TextStyle(color: selectedicon=="other"?Colors.green:Colors.grey),),
                    ],
                  ),

                ],
              ),
              // TextField(
              //
              //   controller: addressnamecontroller,
              //   decoration: InputDecoration(
              //     border: InputBorder.none,
              //     hintText: 'Name  (Home, Work)',
              //
              //     enabledBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(color: Colors.green),
              //     ),
              //     focusedBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(color: Colors.green),
              //     ),
              //
              //   ),
              // ),
              SizedBox(height: 8.0),
              TextField(

                controller: addresscontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: ' Complete Address',

                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),

                ),
              ),
              SizedBox(height: 10.0),

              FlatButton(
                onPressed: () {

                     addLocation().then((value) {


                      setState(() {

                      });


                    });





                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on),
                    Container(width: screenWidth(context)/2,child: Text(PickedAddress,maxLines: 3,)),
 
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


                         CompleteAddress= addresscontroller.text;

                         CompleteAddress.trim();

 // ., $, #, [, ], /,


                        if((selectedicon!="")&&PickedAddress!="Pick Location"&&(CompleteAddress!=""||CompleteAddress!=null)) {
                          FirebaseDatabase database = new FirebaseDatabase();
                          DatabaseReference db = database.reference()
                              .child('Users').child(DataStream.UserId).child("addresses").child(
                              selectedicon);

                          db.set(<dynamic, dynamic>{
                            'location': "${PickedLocation.latitude},${PickedLocation.longitude}",
                            'address': CompleteAddress,

                          }).then((value) {

                            DataStream.addresses.clear();
                            final locationDbRef = FirebaseDatabase.instance.reference().child("Users").child(DataStream.UserId).child("addresses");
                            locationDbRef.onChildAdded.listen((event) {

                              DataStream.addresses.add(Addresses.fromSnapshot(event.snapshot));

                              print(Addresses.fromSnapshot(event.snapshot).key);
                            });

                            Navigator.of(context).pop();


                          });
                        }else{
                          FocusScope.of(context).requestFocus(FocusNode());

                          ToastUtils.showCustomToast(
                              context, "Please Select category\nType Complete Address\nand Select Location", false);
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


  String CompleteAddress="";
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
    String encode(String key) {
      return key.replaceAllMapped(new RegExp(r'[\.\$\#\[\]/%]'),
              (match) => '%${match.group(0).codeUnitAt(0)}');
    }
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
 