import 'dart:io';
import 'dart:math';

import 'package:Doorstep/models/Cart.dart';
import 'package:Doorstep/models/Order.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'package:progress_dialog/progress_dialog.dart';

import 'package:http/http.dart' as http;

import 'cart_screen.dart';
import 'product_catalog.dart';
import 'home_screen.dart';

class OrderItemsScreen extends StatefulWidget {


  String status;
  Order order;
   OrderItemsScreen(String s, Order o){
     status=s;
     order=o;

  }


  @override
  _OrderItemsScreenState createState() => _OrderItemsScreenState(status,order);
}

class _OrderItemsScreenState extends State<OrderItemsScreen> {

  bool isloadingDialogueShowing=false;

  bool isLoadingError=false;

  String status;
  Order order;
  _OrderItemsScreenState(String s, Order o){
    status=s;
    order=o;

  }


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

  List<Cart> ordereditems;
  String userid;
   DatabaseReference volunteerRef;
  Future<void> setuplist() async {

    ordereditems = new List();
    FirebaseAuth.instance.currentUser().then((firebaseUser){
      if(firebaseUser == null)
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
      }
      else{

        userid=firebaseUser.uid;
        final FirebaseDatabase database = FirebaseDatabase.instance;
        volunteerRef = database.reference().child("User Orders").child(DataStream.UserId).child(status).child(order.orderID).child("items");
        volunteerRef.onChildAdded.listen(_onEntryAdded);
        volunteerRef.onChildChanged.listen(_onEntryChanged);
        volunteerRef.onChildRemoved.listen(_onEntryRemoved);
       }
    });

  }


  _onEntryChanged(Event event) {
    var old = ordereditems.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });


//    for(int i=0;i<=ordereditems.length-1;i++){
//      Subtotal=Subtotal+ordereditems[i].cardprice;
//    }


    setState(() {
      ordereditems[ordereditems.indexOf(old)] = Cart.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      ordereditems.add(Cart.fromSnapshot(event.snapshot));

    });
  }

  _onEntryRemoved(Event event) {
    setState(() {
      ordereditems.remove(Cart.fromSnapshot(event.snapshot));
    });
  }


  int calSubtotal(){
    int Subtotal=0;

    for(int i=0;i<=ordereditems.length-1;i++){
      Subtotal=Subtotal+(ordereditems[i].no_of_items*ordereditems[i].cardprice);
    }

        return Subtotal;
  }

  int caltotal(){
    int total=0;

    for(int i=0;i<=ordereditems.length-1;i++){
      total=total+(ordereditems[i].no_of_items*ordereditems[i].cardprice);
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
        title:  Text("Order   # "+order.orderID),
        automaticallyImplyLeading: false,
      ),

      body: Stack(
        children: [
          Column(
            children: <Widget>[
              SizedBox(height: 20,),
              ordereditems.length>0?
              Flexible(
                flex: 9,
                child:

                  ListView.builder(
                    itemCount: ordereditems.length+1,
                    itemBuilder: (context, index) {
                      return index!=ordereditems.length?

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
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.black),
                                        ),
                                      ),
                                       Text(
                                        'Items',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    'Price  ',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.redAccent),
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
                                          '${ordereditems[index].no_of_items} x ',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        '${ordereditems[index].cardname}',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    'Rs. ${ordereditems[index].no_of_items*ordereditems[index].cardprice}',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.redAccent),
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
                                    '${ordereditems[index].no_of_items} x ',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  '${ordereditems[index].cardname}',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
                                ),
                              ],
                            ),

                            Text(
                              'Rs. ${ordereditems[index].no_of_items*ordereditems[index].cardprice}',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.redAccent),
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
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),
                                        Text(
                                          'Rs. ${calSubtotal()}',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Delivery Charges ',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),
                                        Text(
                                          'Rs. ${DataStream.DeliverCharges}',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
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
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black),
                                            ),
                                            Text(
                                              '(incl. VAT)',
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,color: Colors.black),
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

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:CrossAxisAlignment.start,

                                          children: [
                                            Text(
                                              'Order Date',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black),
                                            ),
                                            SizedBox(height: 5,),

                                            Container(
                                              width:screenWidth(context)/1.5,
                                              child: Text(
                                                order.orderDate +"  "+order.orderTime,
                                                maxLines:5,
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                              ),
                                            ),

                                          ],
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
                                        crossAxisAlignment:CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:CrossAxisAlignment.start,

                                            children: [
                                              Text(
                                                'Delivery Location',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black),
                                              ),
                                              SizedBox(height: 5,),

                                              Container(
                                                width:screenWidth(context)/1.5,
                                                child: Text(
                                                  order.address,
                                                  maxLines:5,
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                                ),
                                              ),

                                            ],
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
                                        Text(
                                          'Payment Method ',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black),
                                        ),
                                        Text(
                                          'Cash on delivery',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),

                                      ],
                                    ),

                                  ],
                                ),
                              ),

                            ),
                          ),


                        ],
                      );

                    },
                  )
              ):
              SizedBox(),



            ],
          ),

          status=="History"?
          Positioned(
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20),
              child:  Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green[100],
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                width: screenWidth(context)-40,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.green,
                  onPressed: (){

                    int chk=0;

                    FirebaseDatabase database = new FirebaseDatabase();
                    DatabaseReference _userRef = database.reference()
                        .child("Cart").child(DataStream.UserId);






                    volunteerRef = database.reference().child("User Orders").child(DataStream.UserId).child("History").child(order.orderID).child("items");
                    volunteerRef.onChildAdded.listen((event) {

                      // ordereditems.add(Cart.fromSnapshot(event.snapshot));

                    //  print("Shops."+Cart.fromSnapshot(event.snapshot).town+"."+Cart.fromSnapshot(event.snapshot).shopcatagory+"."+Cart.fromSnapshot(event.snapshot).shopid+" orders."+"active."+orders[index].orderID);

                      _userRef.push().set(<dynamic, dynamic>{
                        'no_of_items': Cart.fromSnapshot(event.snapshot).no_of_items,
                        'cardid': Cart.fromSnapshot(event.snapshot).cardid.toString(),
                        'cardname': Cart.fromSnapshot(event.snapshot).cardname.toString(),
                        'cardimage': Cart.fromSnapshot(event.snapshot).cardimage.toString(),
                        'cardprice': Cart.fromSnapshot(event.snapshot).cardprice,
                        'town':Cart.fromSnapshot(event.snapshot).town,
                        'shopcatagory': Cart.fromSnapshot(event.snapshot).shopcatagory,
                        'shopid': Cart.fromSnapshot(event.snapshot).shopid,

                      }).then((value) {
                   //     Navigator.pop(context);
                        if(chk==0) {
                          chk++;
                          Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) => CartScreen(),),);
                          //    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CartScreen()));
                        }
                      });



                    });

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [

                      Text('Reorder',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 18),),

                    ],
                  ),
                ),
              ),

            ),
          ):

              SizedBox(),

        ],
      ),
    );

  }
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

}
