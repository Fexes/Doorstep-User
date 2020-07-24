import 'dart:io';

 import 'package:Doorstep/models/Cart.dart';
import 'package:Doorstep/models/Shops.dart';
import 'package:Doorstep/screens/auth/sign-in.dart';
import 'package:Doorstep/screens/first-screen.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:Doorstep/styles/styles.dart';
import 'package:Doorstep/screens/auth/sign-up.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'package:progress_dialog/progress_dialog.dart';

import 'package:http/http.dart' as http;

import 'product_catalog.dart';
import 'home_screen.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {

  bool isloadingDialogueShowing=false;

  bool isLoadingError=false;
  hideLoadingDialogue(){

    if(isloadingDialogueShowing) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      isloadingDialogueShowing=false;
      isLoadingError=false;
    }
  }
  showLoadingDialogue(String message){

    if(!isloadingDialogueShowing) {
      loadingdialog= Dialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child:   Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
              Text(""+message, style: TextStyle(fontSize: 12,color: Colors.white),),
            ],
          )
      );
      showDialog(
          context: context, builder: (BuildContext context) => loadingdialog);
      showDialog(
          context: context, builder: (BuildContext context) => loadingdialog);
      isloadingDialogueShowing = true;
    }
    isLoadingError=true;


  }


  @override
  void dispose() {
    super.dispose();
   }
  Dialog loadingdialog;


  @override
    initState()   {
    super.initState();

    setuplist();




  }

  List<Cart> carts;
  String userid;
   DatabaseReference volunteerRef;
  Future<void> setuplist() async {

    carts = new List();
    FirebaseAuth.instance.currentUser().then((firebaseUser){
      if(firebaseUser == null)
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
      }
      else{



        userid=firebaseUser.uid;
        final FirebaseDatabase database = FirebaseDatabase.instance;
        volunteerRef = database.reference().child("cart").child(firebaseUser.uid);
        volunteerRef.onChildAdded.listen(_onEntryAdded);
        volunteerRef.onChildChanged.listen(_onEntryChanged);
        volunteerRef.onChildRemoved.listen(_onEntryRemoved);
       }
    });

  }


  _onEntryChanged(Event event) {
    var old = carts.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });


//    for(int i=0;i<=carts.length-1;i++){
//      Subtotal=Subtotal+carts[i].cardprice;
//    }


    setState(() {
      carts[carts.indexOf(old)] = Cart.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      carts.add(Cart.fromSnapshot(event.snapshot));

    });
  }

  _onEntryRemoved(Event event) {
    setState(() {
      carts.remove(Cart.fromSnapshot(event.snapshot));
    });
  }


  int calSubtotal(){
    int Subtotal=0;

    for(int i=0;i<=carts.length-1;i++){
      Subtotal=Subtotal+(carts[i].no_of_items*carts[i].cardprice);
    }

        return Subtotal;
  }

  int caltotal(){
    int total=0;

    for(int i=0;i<=carts.length-1;i++){
      total=total+(carts[i].no_of_items*carts[i].cardprice);
    }

    return total+DataStream.DeliverCharges;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.white,

    appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);

          },
        ),
        title:  Text("Checkout"),
        automaticallyImplyLeading: false,
      ),

      body: Stack(
        children: [
          Column(
            children: <Widget>[
              SizedBox(height: 20,),
              carts.length>0?
              Flexible(
                flex: 9,
                child:

                  ListView.builder(
                    itemCount: carts.length+1,
                    itemBuilder: (context, index) {
                      return index!=carts.length?

                      index==0?Padding(
                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
                        child: Container(

                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(

                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:20,
                                        child: Text(
                                          '',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.black),
                                        ),
                                      ),
                                       Text(
                                        'Items',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    'Price  ',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.redAccent),
                                  ),


                                ],
                              ),
                              SizedBox(height: 15,),
                              Container(
                                height: 1,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(

                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:30,
                                        child: Text(
                                          '${carts[index].no_of_items} x ',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200,color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        '${carts[index].cardname}',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200,color: Colors.black),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    'Rs. ${carts[index].no_of_items*carts[index].cardprice}',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ):

                      Padding(
                      padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
                      child: Container(

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:30,
                                  child: Text(
                                    '${carts[index].no_of_items} x ',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200,color: Colors.black),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  '${carts[index].cardname}',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200,color: Colors.black),
                                ),
                              ],
                            ),

                            Text(
                              'Rs. ${carts[index].no_of_items*carts[index].cardprice}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                    ):
                      Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(

                              height: 135,
                               width: screenWidth(context)-10,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [

                                    Container(
                                      height: 1,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 10,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Subtotal ',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: Colors.black),
                                        ),
                                        Text(
                                          'Rs. ${calSubtotal()}',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: Colors.black),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Delivery Charges ',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: Colors.black),
                                        ),
                                        Text(
                                          'Rs. ${DataStream.DeliverCharges}',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      height: 1,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Total ',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black),
                                            ),
                                            Text(
                                              '(incl. VAT)',
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200,color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Rs. ${caltotal()}',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                               width: screenWidth(context)-10,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                   crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [


                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Contact info ',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),
                                        Text(
                                          '03350581041',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: Colors.black),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Container(
                                      height: 1,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 15,),

                                    GestureDetector(
                                      onTap:(){
                                        addLocation();
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:CrossAxisAlignment.start,

                                            children: [
                                              Text(
                                                'Delivery Location',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                              ),
                                              SizedBox(height: 5,),

                                              Container(
                                                width:screenWidth(context)/2,
                                                child: Text(
                                                  '${Useraddress}',
                                                  maxLines:3,
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: Colors.black),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Icon(Icons.keyboard_arrow_right,color: Colors.redAccent,size: 40,)
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    Container(
                                      height: 1,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 15,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Delivery Time ',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),
                                        Text(
                                          '45 min',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: Colors.black),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 5,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Payment Method ',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),
                                        Text(
                                          'Cash on delivery',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: Colors.black),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(

                              width: screenWidth(context)-10,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'By completing this order, I agree to all terms & conditions.',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,color: Colors.black),
                                    ),

                                  ],
                                ),
                              ),

                            ),
                          ),
                          SizedBox(height: 70,),

                        ],
                      );

                    },
                  )
              ):
              SizedBox(),

//              Flexible(
//                  flex: 1,
//                  child: SizedBox(height: 1,)),

            ],
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20),
              child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: isaddressaded?Colors.green:Colors.grey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),
                      boxShadow: [
                        BoxShadow(
                        color: isaddressaded?Colors.green.withOpacity(0.5):Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    width: screenWidth(context)-40,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: isaddressaded?Colors.green:Colors.grey,
                      onPressed: (){

                        if(isaddressaded){

                          FirebaseDatabase database = new FirebaseDatabase();
                          DatabaseReference _userRef = database.reference()
                              .child('order').child(DataStream.UserId);


                          for(int i=0;i<=carts.length-1;i++){

                            _userRef.push().set(<dynamic, dynamic>{
                              'no_of_items': carts[i].no_of_items,
                              'cardid': carts[i].cardid.toString(),
                              'cardname': carts[i].cardname.toString(),
                              'cardimage': carts[i].cardimage.toString(),
                              'cardprice': carts[i].cardprice,
                              'town':"Bahria Town Phase 4",
                              'shopcatagory': DataStream.ShopCatagory,
                              'shopid': DataStream.ShopId,



                            }).then((value) {
                              FirebaseDatabase database = new FirebaseDatabase();
                              DatabaseReference _userRef = database.reference()
                                  .child('cart').child(DataStream.UserId);
                              _userRef.remove();
                             });

                          }




                        }else{
                          ToastUtils.showCustomToast(context, "Add Delivery Location", null);
                        }

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white),
                            height: 22,
                            width: 22,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Text(carts.length.toString(),style: TextStyle(color: isaddressaded?Colors.green:Colors.grey,fontSize: 14),),
                              ],
                            ),
                          ),
                          SizedBox(width: 20,),
                          Text('Place Order',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 18),),
                          SizedBox(width: 20,),

                          Text(
                            'Rs. ${caltotal()}',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),

            ),
          ),
        ],
      ),
    );

  }
  String googleAPIKey = "AIzaSyD_U_2NzdPIL7TWb8ECBHWO1eROR2yrebI";

  String Useraddress="Add Location";
  bool isaddressaded=false;
  LatLng deliverylocation;
  Future<void> addLocation() async {

    LocationResult result = await showLocationPicker(
      context,
      googleAPIKey,
    //  initialCenter: userPosition,
      myLocationButtonEnabled: true,
      layersButtonEnabled: true,

    );
    print("result = $result");
    if(result!=null){
      isaddressaded=true;
      print(result.address);
      Useraddress=result.address;
      deliverylocation=result.latLng;
      setState(() {

      });
    }
  }

}
