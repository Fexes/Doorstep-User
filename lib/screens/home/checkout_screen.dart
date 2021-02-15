import 'dart:io';
import 'dart:math';

 import 'package:Doorstep/models/AppUser.dart';
import 'package:Doorstep/models/Cart.dart';
import 'package:Doorstep/models/Shops.dart';
import 'package:Doorstep/screens/auth/sign-in.dart';
import 'package:Doorstep/screens/first-screen.dart';
import 'package:Doorstep/styles/CustomDialogBox.dart';
import 'package:Doorstep/styles/PrescriptionDialogBox.dart';
import 'package:Doorstep/styles/PrescriptionImageDialogBox.dart';
import 'package:Doorstep/styles/PromoDialogBox.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:Doorstep/utilts/UI/promo_dialogue.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:Doorstep/styles/styles.dart';
 
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

import 'product_catalog.dart';
import 'home_screen.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {

  bool isloadingDialogueShowing=false;
  bool hasPharmacy=false;

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
              Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/icons/logo.png",height: 23,width: 23, ),

                    SpinKitFadingCircle(
                      size: 70,
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
  FocusNode _focusNode,_focusNode2;


  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _focusNode2.dispose();

  }
  Dialog loadingdialog;

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  @override
    initState()   {
    super.initState();
    DataStream.prescriptionImage=null;
    carts = new List();
    cartsNacotic = new List();

    _focusNode = new FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
    _focusNode2 = new FocusNode();
    _focusNode2.addListener(_onOnFocusNodeEvent);
    _add();

    getodercount();
    DataStream.PromoCode=null;
    setuplist();
    DeliverCharges = DataStream.DeliverCharges ;
    DeliverChargesPharmacy = DataStream.DeliverChargesPharmacy ;
     getUserDetails();

    }

 int DeliverCharges;
 int DeliverChargesPharmacy;
 int Discount =0;

 bool userdetails=false;

 bool gotuserdata=false;
  void getUserDetails(){

    appuser= new AppUser("","","","","");

    final locationDbRef = FirebaseDatabase.instance.reference().child("Users").child(DataStream.UserId);

    locationDbRef.once().then((value) async {
      if(value.value!=null){
        appuser= new AppUser(value.value["first_name"], value.value["last_name"],value.value["phone"] , value.value["email"],value.value["userTokenID"]);


        DataStream.appuser=appuser;



        userdetails=true;
        setState(() {

        });
      }else{

      }



    });

    if(  DataStream.appuser.first_name==""||DataStream.appuser.last_name==""||DataStream.appuser.email==""||
        DataStream.appuser.first_name==null||DataStream.appuser.last_name==null||DataStream.appuser.email==null) {
      gotuserdata=false;

    }else{
      gotuserdata=true;


    }

  }

  void getodercount(){
    final locationDbRef = FirebaseDatabase.instance.reference().child("User Orders").child(DataStream.UserId).child("Order Count");

    locationDbRef.once().then((value) async {
      if(value.value!=null){

        print(value.value["no_of_orders"]);
        order_count = value.value['no_of_orders'];


      }



    }
    );
  }

  int order_count=0;
  List<Cart> carts;
  List<Cart> cartsNacotic;
  String userid;
   DatabaseReference volunteerRef;
  Future<void> setuplist() async {

     FirebaseAuth.instance.currentUser().then((firebaseUser){
      if(firebaseUser == null)
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
      }
      else{



        userid=firebaseUser.uid;
        final FirebaseDatabase database = FirebaseDatabase.instance;
        volunteerRef = database.reference().child("Cart").child(firebaseUser.uid);
        volunteerRef.onChildAdded.listen(_onEntryAdded);
       }
    });

  }
  bool profileedit =false;
  final firstname = TextEditingController();
  final lasename = TextEditingController();
  final email = TextEditingController();
  AppUser appuser=DataStream.appuser;

  String useraddress = "";




  _onEntryAdded(Event event) {
    setState(() {
      carts.add(Cart.fromSnapshot(event.snapshot));
      if(Cart.fromSnapshot(event.snapshot).shopcatagory=="Pharmacy"){
        hasPharmacy=true;
        caltotal();

      }
      if (Cart.fromSnapshot(event.snapshot).itemcatagory.contains("NARCOTIC")) {
        cartsNacotic.add(Cart.fromSnapshot(event.snapshot));
        hasNacotic = true;
      }

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
    if(hasPharmacy){
      return (total + DeliverChargesPharmacy)-Discount;
    }else {
      return (total + DeliverCharges) - Discount;
    }
   }
  bool hasNacotic=false;


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
                                          '${carts[index].no_of_items} x ',
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: screenWidth(context)/2,
                                            child: Text(
                                              '${carts[index].cardname}',
                                              maxLines: 3,
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color:carts[index].itemcatagory.contains("NARCOTIC")?Colors.red[900]: Colors.black),
                                            ),
                                          ),
                                          carts[index].itemcatagory.contains("NARCOTIC")?
                                          Text(
                                            '(${carts[index].itemcatagory})',
                                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w300,color: Colors.red[900]),
                                          ):SizedBox()
                                        ],
                                      ),
                                    ],
                                  ),

                                  Text(
                                    'Rs. ${carts[index].no_of_items*carts[index].cardprice}',
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
                                    '${carts[index].no_of_items} x ',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: screenWidth(context)/2,
                                      child: Text(
                                        '${carts[index].cardname}',
                                        maxLines: 3,
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color:carts[index].itemcatagory.contains("NARCOTIC")?Colors.red[900]: Colors.black),
                                      ),
                                    ),
                                    carts[index].itemcatagory.contains("NARCOTIC")?
                                    Text(
                                      '(${carts[index].itemcatagory})',
                                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.w300,color: Colors.red[900]),
                                    ):SizedBox()
                                  ],
                                ),
                              ],
                            ),

                            Text(
                              'Rs. ${carts[index].no_of_items*carts[index].cardprice}',
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

                              height: 185,
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Promo Code : ',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black,),
                                        ),
                                        GestureDetector(
                                          onTap: ()  {

                                            showDialog(context: context,
                                                builder: (BuildContext context){
                                                  return PromoDialogBox(
                                                    title: "Enter Promo Code",
                                                    descriptions: "Enter a valid Promo Code to Avail an ongoing Offer or get a Discount on the items you are about to purchase",
                                                    text: "Validate",

                                                  );
                                                }
                                            ).then((value) {

                                              if(DataStream.PromoCode!=null){


                                                Discount = DataStream.PromoCode.discount;
                                                DeliverCharges = DataStream.PromoCode.delivery;
                                                DeliverChargesPharmacy = DataStream.PromoCode.delivery;

                                                setState(() {

                                                });


                                              }

                                            });

                                          },
                                          child: DataStream.PromoCode==null? Container(
                                            height: 18.0,
                                            width: 18.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              color: Colors.green,

                                            ),
                                            child: InkWell(
                                              child: Icon(Icons.add, size: 16.0, color:  Colors.white

                                              ),
                                            )

                                          ):Text(
                                            DataStream.PromoCode.promoID,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.green,),
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 5,),

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
                                        hasPharmacy?
                                        Text(
                                          'Rs. ${DeliverChargesPharmacy}',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                        ): Text(
                                          'Rs. ${DeliverCharges}',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Discount ',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),
                                        Text(
                                          'Rs. ${Discount}',
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
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black),
                                        ),
                                      ],
                                    ),


                                  ],
                                ),
                              ),

                            ),
                          ),


                          hasNacotic?
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 7.5, 15, 7.5),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                color: Colors.white,

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
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        DataStream.prescriptionImage==null?
                                        Row(
                                          children: [
                                            Icon(Icons.warning,color: Colors.amber[900],),
                                            SizedBox(width: 10,),

                                            Container(
                                              width: screenWidth(context)/2,
                                              child: Text(

                                                "Medical Prescription Required",
                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,color: Colors.black),
                                                textAlign: TextAlign.left,
                                                maxLines: 4,
                                              ),
                                            ),
                                          ],
                                        ): Row(
                                          children: [
                                            Icon(Icons.done,color: Colors.green,),
                                            SizedBox(width: 10,),

                                            Container(
                                              width: screenWidth(context)/2,
                                              child: Text(

                                                "Medical Prescription Added",
                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,color: Colors.black),
                                                textAlign: TextAlign.left,
                                                maxLines: 4,
                                              ),
                                            ),
                                          ],
                                        ),

                                        DataStream.prescriptionImage==null?
                                        GestureDetector(
                                          onTap: ()  {

                                            showDialog(context: context,
                                                builder: (BuildContext context){
                                                  return PrescriptionDialogBox(
                                                    title: "Upload Prescription",
                                                    descriptions: "A Valid Medical Prescription is Required for any Purchase of Narcotic Medicine",

                                                  );
                                                }
                                            ).then((value) {
                                              setState(() {

                                              });
                                            });
                                          },

                                          child: Text(
                                            'Add',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.green),
                                          ),
                                        ):
                                        GestureDetector(
                                          onTap: ()  {

                                            showDialog(context: context,
                                                builder: (BuildContext context){
                                                  return PrescriptionImageDialogBox(
                                                    title: "Prescription Added",
                                                    descriptions: "A Valid Medical Prescription is Required for any Purchase of Narcotic Medicine",
                                                    buttonText: "Upload",
                                                    image: DataStream.prescriptionImage,

                                                  );
                                                }
                                            ).then((value) {

                                              setState(() {

                                              });
                                            });
                                          },

                                          child: Text(
                                            'View',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.green),
                                          ),
                                        ),

                                      ],
                                    ),
                                    //SizedBox(height: 20,),





                                  ],
                                ),
                              ),

                            ),
                          ):SizedBox(),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 7.5),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                color: Colors.white,

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
                                padding: EdgeInsets.all(15),
                                child:   Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [

                                    DataStream.appuser.first_name==""||DataStream.appuser.last_name==""||DataStream.appuser.email==""||
                                        DataStream.appuser.first_name==null||DataStream.appuser.last_name==null||DataStream.appuser.email==null?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(

                                          children: [
                                            Icon(Icons.warning,color: Colors.amber[900],),
                                            SizedBox(width: 5,),

                                            Text(
                                              'Contact Details Missing',
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,color: Colors.black),
                                            ),


                                          ],
                                        ),
                                        profileedit?
                                        Visibility(
                                          visible: profileedit,
                                          child: GestureDetector(
                                              onTap: (){
                                                if(profileedit) {
                                                  profileedit = false;
                                                }else{
                                                  profileedit = true;

                                                }
                                                setState(() {

                                                });
                                              },
                                              child: Icon(Icons.cancel,color: Colors.redAccent,)),
                                        ):
                                        GestureDetector(
                                          onTap: (){

                                            firstname.text=appuser.first_name;
                                            lasename.text=appuser.last_name;
                                            email.text=appuser.email;


                                            if(profileedit) {
                                              profileedit = false;
                                            }else{
                                              profileedit = true;

                                            }
                                            setState(() {

                                            });
                                          },
                                          child: Text(
                                            profileedit?'':'Add',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.green),
                                          ),
                                        ),

                                      ],
                                    ):SizedBox(),

                                    DataStream.appuser.first_name==""||DataStream.appuser.last_name==""||DataStream.appuser.email==""||
                                        DataStream.appuser.first_name==null||DataStream.appuser.last_name==null||DataStream.appuser.email==null?
                                    SizedBox(height: 20,):SizedBox(),

                                    profileedit?
                                    Column(children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [
                                          Container(
                                            width: (screenWidth(context)/2)-70,

                                            child: TextField(

                                              controller: firstname,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'First Name',

                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.green),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.green),
                                                ),

                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: (screenWidth(context)/2)-70,

                                            child: TextField(
                                              controller: lasename,

                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Last Name',
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.green),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.green),
                                                ),

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),


                                      SizedBox(height: 10,),

                                      TextField(
                                        controller: email,

                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'E-mail',

                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.green),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.green),
                                          ),

                                        ),
                                      ),
                                      SizedBox(height: 10,),

                                      TextField(

                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "(Phone)  "+DataStream.PhoneNumber,
                                          enabled: false,

                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.green),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.green),
                                          ),

                                        ),
                                      ),


                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(width: 20,),

                                          FlatButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8)),
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                                                child: Text("Save")),
                                            textColor: Colors.white,
                                            color: Colors.green,
                                            onPressed: () async {


                                              FirebaseDatabase database = new FirebaseDatabase();
                                              DatabaseReference db = database.reference()
                                                  .child('Users').child(DataStream.UserId);

                                              db.set(<dynamic, dynamic>{
                                                'first_name': firstname.text,
                                                'last_name': lasename.text,
                                                'phone':DataStream.PhoneNumber,
                                                'email': email.text,
                                                'userTokenID':DataStream.userTokenID,


                                              }).then((value) {


                                                if(profileedit) {
                                                  profileedit = false;
                                                }else{
                                                  profileedit = true;

                                                }
                                                setState(() {

                                                });
                                                DataStream.appuser.first_name=firstname.text;
                                                DataStream.appuser.last_name=lasename.text;
                                                DataStream.appuser.email=email.text;

                                                getUserDetails();

                                                setState(() {

                                                });
                                                ToastUtils.showCustomToast(
                                                    context, "Saved", true);

                                              });


                                            },
                                          ),
                                        ],
                                      )
                                    ],)

                                        :
                                    Column(
                                      children: [
                                        !profileedit?
                                        Column(
                                          children: [
                                            Text(
                                              'Contact Details',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black),
                                            ),
                                            SizedBox(height: 10,),
                                          ],
                                        ):SizedBox(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Username ',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                            ),
                                            Text(
                                              appuser.first_name+" "+appuser.last_name,
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                            ),

                                          ],
                                        ),

                                        SizedBox(height: 8,),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Phone ',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                            ),
                                            Text(
                                              DataStream.PhoneNumber+"",
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                            ),

                                          ],
                                        ),


                                        SizedBox(height: 8,),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'E-mail ',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                            ),
                                            Text(
                                              appuser.email+"",
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),



                                  ],
                                ),

                              ),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
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




                                    SizedBox(height: 15,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Delivery Time ',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),
                                        Column(
                                          children: [
                                            //
                                            Text(
                                              '30 - 60 min',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                            ),
                                            Text(
                                              'Depending on your location',
                                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200,color: Colors.black),
                                            ),
                                          ],
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
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 15,),
                                    Container(
                                      height: 1,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 15,),

                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:CrossAxisAlignment.center,

                                        children: [
                                          Text(
                                            'Delivery Location',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black),
                                          ),
                                          SizedBox(height: 15,),


                                          Container(
                                            height:150,
                                           // width:screenWidth(context)-0,
                                            decoration: BoxDecoration(
                                              color: Colors.white,

                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  spreadRadius: 3,
                                                  blurRadius: 5,
                                                ),
                                              ],
                                            ),
                                            child: GoogleMap(
                                            //  myLocationEnabled: false,

                                              //  compassEnabled: false,

                                            //  tiltGesturesEnabled: false,
                                              myLocationButtonEnabled: false,
                                               mapType: MapType.normal,

                                              initialCameraPosition:CameraPosition(target: DataStream.userlocation, zoom: 14),
                                              onMapCreated: (GoogleMapController controller) {
                                                onMapCreated(controller);
                                              },
                                               markers: Set<Marker>.of(markers.values),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 15,),

                                    Form(
                                      key: _formKey,

                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(bottom: 18.0),
                                            child: Row(

                                              children: <Widget>[
                                                Icon(Icons.home,size: 25,),
                                                //   Image.asset("assets/icons/user-grey.png", height: 16.0, width: 16.0,),
                                                Container(
                                                  width: screenWidth(context)*0.7,
                                                  child: TextFormField(
                                                    maxLength: 150,

                                                    cursorColor: primaryDark, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
                                                    keyboardType: TextInputType.text,
                                                     onSaved: (String value) => useraddress = value,
                                                    onChanged: (text) {

                                                      if(text.length>5){
                                                        isaddressaded=true;
                                                      }else{
                                                        isaddressaded=false;

                                                      }

                                                      useraddress = text.toString();

                                                      setState(() {

                                                      });
                                                     },
                                                    validator: (String value) {
                                                      if(value.isEmpty)
                                                        return 'Please Enter Your Address';
                                                      else
                                                        return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide.none
                                                      ),
                                                      labelText: "Delivery Address",
                                                    ),
                                                    focusNode: _focusNode,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            decoration: new BoxDecoration(
                                              border: new Border(
                                                bottom: BorderSide(color: _focusNode.hasFocus ? primaryDark : border, style: BorderStyle.solid, width: 2.0),
                                              ),
                                            ),
                                          ),



                                        ],
                                      ),

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
                                  crossAxisAlignment:CrossAxisAlignment.center,
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
          hasNacotic&&DataStream.prescriptionImage==null?
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20),
              child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey,
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
                    width: screenWidth(context)-40,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: Colors.grey,
                      onPressed: (){


                        ToastUtils.showCustomToast(context, "Add Medical Prescription", null);


                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white),
                            height: 27,
                            width: 27,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [


                                Text(carts.length.toString(),style: TextStyle(color: Colors.grey,fontSize: 14),),

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
          ):
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: isaddressaded&&gotuserdata?Colors.green:Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isaddressaded&&gotuserdata?Colors.green.withOpacity(0.5):Colors.grey.withOpacity(0.5),
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
                  color: isaddressaded&&gotuserdata?Colors.green:Colors.grey,
                  onPressed: (){



                    if (DataStream.PromoCode != null) {
                      if (DataStream.PromoCode.min_order <
                          calSubtotal()) {
                        placeOrder();
                      } else {
                        ToastUtils.showCustomToast(
                            context, "Minimum Order \n is Rs. " +
                            DataStream.PromoCode.min_order.toString() +
                            " \n for Promo Code", null);
                      }
                    } else {
                      placeOrder();
                    }


                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white),
                        height: 27,
                        width: 27,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [


                            Text(carts.length.toString(),style: TextStyle(color: isaddressaded&&gotuserdata?Colors.green:Colors.grey,fontSize: 14),),

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
          )
        ],
      ),
    );

  }
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  String Useraddress=DataStream.userAddress;
  bool isaddressaded=false;
  LatLng deliverylocation=DataStream.userlocation;
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
        isaddressaded=true;
        print(result.address);
        Useraddress=result.address;
        deliverylocation=result.latLng;
        setState(() {

        });
      }
  }
  Completer<GoogleMapController> _controller = Completer();

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);


  }
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _add() {
    var markerIdVal = "marker";
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: DataStream.userlocation,

    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void placeOrder() {

    if(hasNacotic) {
      if(DataStream.prescriptionImage!=null) {
        if (gotuserdata) {
          if (isaddressaded) {



            showLoadingDialogue("Uploading Prescription");
            String orderID = getRandomString(4) + "-" + getRandomString(3);

            addImageToFirebase(orderID,new File(DataStream.prescriptionImage)).then((value){

              hideLoadingDialogue();
              showLoadingDialogue("Placing Order");



              FirebaseDatabase database = new FirebaseDatabase();

            DatabaseReference ordercount = database.reference()
                .child('User Orders').child(DataStream.UserId).child(
                "Order Count");

            DatabaseReference _userRef = database.reference()
                .child('User Orders').child(DataStream.UserId)
                .child("Active")
                .child(orderID);

            DatabaseReference shoporder = database.reference()
                .child('Shops');

            DatabaseReference adminorder = database.reference()
                .child('Admin').child("Orders");

            var now = new DateTime.now();
            var date = new DateFormat('yyyy-MM-dd');
            var time = new DateFormat('hh:mm');


            ordercount.set(<dynamic, dynamic>{
              'no_of_orders': order_count + 1,

            }).then((value) {
              if (DataStream.PromoCode != null) {
                DatabaseReference promoref = database
                    .reference()
                    .child('Users').child(
                    DataStream.UserId)
                    .child("Promo")
                    .child(DataStream.PromoCode.promoID);

                promoref.set(<dynamic, dynamic>{
                  'status': "used",

                });
              }


              HomePage.getodercount();

              _userRef.set(<dynamic, dynamic>{
                'no_of_items': '${carts.length}',
                'userID': DataStream.UserId,
                'bill': '${caltotal()}',
                'status': 'pending',
                'orderDate': date.format(now),
                'orderTime': time.format(now),
                'phonenumber': DataStream.PhoneNumber,
                'orderID': orderID,
                'prescription':prescriptiondownloadUrl,
                'address': Useraddress + "\n" + useraddress,
                'location': "${deliverylocation.latitude},${deliverylocation
                    .longitude}",

              }).then((value) {

                adminorder
                    .child("Active")
                //.child(DataStream.UserId)
                    .child(orderID)
                    .set(<dynamic, dynamic>{
                  'no_of_items': '${carts.length}',
                  'userID': DataStream.UserId,
                  'bill': '${caltotal()}',
                  'status': 'pending',
                  'orderDate': date.format(now),
                  'orderTime': time.format(now),
                  'phonenumber': DataStream.PhoneNumber,
                  'orderID': orderID,
                  'prescription':prescriptiondownloadUrl,

                  'address': Useraddress + "\n" + useraddress,
                  'location': "${deliverylocation
                      .latitude},${deliverylocation.longitude}",

                });


                for (int i = 0; i <= carts.length - 1; i++) {


                  adminorder
                      .child("Active")
                  // .child(DataStream.UserId)
                      .child(orderID).child("items").push().set(
                      <dynamic, dynamic>{
                        'no_of_items': carts[i].no_of_items,
                        'cardid': carts[i].cardid.toString(),
                        'cardname': carts[i].cardname.toString(),
                        'unit': carts[i].unit,
                        'cardimage': carts[i].cardimage.toString(),
                        'itemcatagory': carts[i].itemcatagory.toString(),
                        'cardprice': carts[i].cardprice,
                        'shopcatagory': carts[i].shopcatagory,
                        'shopid': carts[i].shopid,

                      }
                  );


                  shoporder.child(
                      carts[i].shopcatagory).child(
                      carts[i].shopid).child("Orders")
                      .child("Active")
                      .child(orderID)
                      .set(<dynamic, dynamic>{
                    'no_of_items': '${carts.length}',
                    'userID': DataStream.UserId,
                    'bill': '${caltotal()}',
                    'status': 'pending',
                    'orderDate': date.format(now),
                    'orderTime': time.format(now),
                    'phonenumber': DataStream.PhoneNumber,
                    'orderID': orderID,
                    'prescription':prescriptiondownloadUrl,

                    'address': Useraddress + "\n" + useraddress,
                    'location': "${deliverylocation
                        .latitude},${deliverylocation.longitude}",

                  });
                  // print("shop Status Pending");
                  // FirebaseDatabase databasestatus = new FirebaseDatabase();
                  //
                  // DatabaseReference _shopRefstatus = databasestatus.reference()
                  //     .child('Shops').child(
                  //     carts[i].shopcatagory).child(
                  //     carts[i].shopid).child("Orders")
                  //     .child("Active")
                  //     .child(orderID);
                  // _shopRefstatus.child("orderStatus").set(<dynamic, dynamic>{
                  //
                  //   'status': 'pending',
                  //
                  //
                  // });


                }


                // FirebaseDatabase databasestatus = new FirebaseDatabase();
                // print("user Status Pending");
                //
                // DatabaseReference _userRefstatus = databasestatus.reference()
                //     .child('User Orders').child(DataStream.UserId)
                //     .child("Active")
                //     .child(orderID);
                // _userRefstatus.child("orderStatus").set(<dynamic, dynamic>{
                //
                //   'status': 'pending',
                //
                //
                // });
                // print("admin Status Pending");
                //
                // DatabaseReference _adminRefstatus = databasestatus.reference()
                //     .child('Admin').child("Orders").child("Active")
                //     .child(orderID);
                // _adminRefstatus.child("orderStatus").set(<dynamic, dynamic>{
                //
                //   'status': 'pending',
                //
                //
                // });







                FirebaseDatabase database = new FirebaseDatabase();
                DatabaseReference _userRef = database.reference()
                    .child('Cart').child(DataStream.UserId);
                _userRef.remove();

                final locationDbRef = FirebaseDatabase.instance.reference()
                    .child(
                    "Admin")
                    .child("Delivery");


                locationDbRef.once().then((value) async {
                  print(value.value["delivery_charges"]);

                  DataStream.DeliverCharges = value.value['delivery_charges'];
                  DataStream.DeliverChargesPharmacy = value.value['delivery_charges_pharmacy'];


                  hideLoadingDialogue();

                  showDialog(context: context,
                      builder: (BuildContext context) {
                        return CustomDialogBox(
                          title: "Order Placed",
                          descriptions: "Your Order has been placed track your order with the order ID",
                          orderId: "# " + orderID,
                          text: "Ok",

                        );
                      }
                  );
                  ToastUtils.showCustomToast(context, "Order Placed", true);


                  //  Navigator.of(context).pop();
                }
                );
              });
            });

          });

    }

          else {
            ToastUtils.showCustomToast(context, "Add Delivery Address", null);
            final FormState form = _formKey.currentState;
            if (!form.validate()) {
              return;
            }
          }
        } else {
          ToastUtils.showCustomToast(context, "Add Contact Details", null);
        }
      }else{
        ToastUtils.showCustomToast(context, "Add Medical Prescription", null);

      }
    }else{
      if (gotuserdata) {
        if (isaddressaded) {
          showLoadingDialogue("Placing Order");
          String orderID = getRandomString(4) + "-" + getRandomString(3);
          FirebaseDatabase database = new FirebaseDatabase();

          DatabaseReference ordercount = database.reference()
              .child('User Orders').child(DataStream.UserId).child(
              "Order Count");

          DatabaseReference _userRef = database.reference()
              .child('User Orders').child(DataStream.UserId)
              .child("Active")
              .child(orderID);

          DatabaseReference shoporder = database.reference()
              .child('Shops');

          DatabaseReference adminorder = database.reference()
              .child('Admin').child("Orders");

          var now = new DateTime.now();
          var date = new DateFormat('yyyy-MM-dd');
          var time = new DateFormat('hh:mm');


          ordercount.set(<dynamic, dynamic>{
            'no_of_orders': order_count + 1,

          }).then((value) {

            if (DataStream.PromoCode != null) {
              DatabaseReference promoref = database
                  .reference()
                  .child('Users').child(
                  DataStream.UserId)
                  .child("Promo")
                  .child(DataStream.PromoCode.promoID);

              promoref.set(<dynamic, dynamic>{
                'status': "used",

              });

              DatabaseReference promouser = database
                  .reference()
                  .child('Admin').child("Promo")
                  .child(DataStream.PromoCode.promoID).child("users");

              promoref.push().set(<dynamic, dynamic>{
                'userID': DataStream.UserId,
                'orderID': orderID,
                'userOrderNumber': order_count+ 1,

              });
            }


            HomePage.getodercount();

            _userRef.set(<dynamic, dynamic>{
              'no_of_items': '${carts.length}',
              'userID': DataStream.UserId,
              'bill': '${caltotal()}',
              'status': 'pending',
              'orderDate': date.format(now),
              'orderTime': time.format(now),
              'phonenumber': DataStream.PhoneNumber,
              'orderID': orderID,
              'userOrderNumber': order_count+ 1,
              'prescription':prescriptiondownloadUrl,
              'address': Useraddress + "\n" + useraddress,
              'location': "${deliverylocation.latitude},${deliverylocation
                  .longitude}",

            }).then((value) {

              adminorder
                  .child("Active")
              //.child(DataStream.UserId)
                  .child(orderID)
                  .set(<dynamic, dynamic>{
                'no_of_items': '${carts.length}',
                'userID': DataStream.UserId,
                'bill': '${caltotal()}',
                'status': 'pending',
                'orderDate': date.format(now),
                'orderTime': time.format(now),
                'phonenumber': DataStream.PhoneNumber,
                'orderID': orderID,
                'prescription':prescriptiondownloadUrl,
                'userOrderNumber': order_count+ 1,

                'address': Useraddress + "\n" + useraddress,
                'location': "${deliverylocation
                    .latitude},${deliverylocation.longitude}",

              });


              for (int i = 0; i <= carts.length - 1; i++) {


                adminorder
                    .child("Active")
                    .child(orderID).child("items").push().set(
                    <dynamic, dynamic>{
                      'no_of_items': carts[i].no_of_items,
                      'cardid': carts[i].cardid.toString(),
                      'cardname': carts[i].cardname.toString(),
                      'unit': carts[i].unit,
                      'cardimage': carts[i].cardimage.toString(),
                      'itemcatagory': carts[i].itemcatagory.toString(),
                      'cardprice': carts[i].cardprice,
                      'shopcatagory': carts[i].shopcatagory,
                      'shopid': carts[i].shopid,

                    }
                );

                shoporder.child(
                    carts[i].shopcatagory).child(
                    carts[i].shopid).child("Orders")
                    .child("Active")
                    .child(orderID)
                    .set(<dynamic, dynamic>{
                  'no_of_items': '${carts.length}',
                  'userID': DataStream.UserId,
                  'bill': '${caltotal()}',
                  'status': 'pending',
                  'orderDate': date.format(now),
                  'orderTime': time.format(now),
                  'phonenumber': DataStream.PhoneNumber,
                  'orderID': orderID,
                  'prescription':prescriptiondownloadUrl,
                  'userOrderNumber': order_count+ 1,
                  'address': Useraddress + "\n" + useraddress,
                  'location': "${deliverylocation
                      .latitude},${deliverylocation.longitude}",

                });


              }

              FirebaseDatabase database = new FirebaseDatabase();
              DatabaseReference _usercart = database.reference()
                  .child('Cart').child(DataStream.UserId);
              _usercart.remove();

              final locationDbRef = FirebaseDatabase.instance.reference().child(
                  "Admin").child("Delivery");

              locationDbRef.once().then((value) async {
                print(value.value["delivery_charges"]);

                DataStream.DeliverCharges = value.value['delivery_charges'];
                DataStream.DeliverChargesPharmacy = value.value['delivery_charges_pharmacy'];


                hideLoadingDialogue();

                showDialog(context: context,
                    builder: (BuildContext context) {
                      return CustomDialogBox(
                        title: "Order Placed",
                        descriptions: "Your Order has been placed track your order with the order ID",
                        orderId: "# " + orderID,
                        text: "Ok",

                      );
                    }
                );
                ToastUtils.showCustomToast(context, "Order Placed", true);


                //  Navigator.of(context).pop();
              }
              );
            });
          });
        }

        else {
          ToastUtils.showCustomToast(context, "Add Delivery Address", null);
          final FormState form = _formKey.currentState;
          if (!form.validate()) {
            return;
          }
        }
      } else {
        ToastUtils.showCustomToast(context, "Add Contact Details", null);
      }
    }

  }
  StorageReference storageReference = FirebaseStorage.instance.ref();

  String prescriptiondownloadUrl="";
  Future<void> addImageToFirebase(String orderid,File image) async {

    prescriptiondownloadUrl="";

    //CreateRefernce to path.
    StorageReference ref = storageReference.child("prescriptions/");

    //StorageUpload task is used to put the data you want in storage
    //Make sure to get the image first before calling this method otherwise _image will be null.

    StorageUploadTask storageUploadTask = ref.child(orderid+".jpg").putFile(image);

    if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
      final String url = await ref.getDownloadURL();
      print("The download URL is " + url);
    } else if (storageUploadTask.isInProgress) {

      storageUploadTask.events.listen((event) {
        double percentage = 100 *(event.snapshot.bytesTransferred.toDouble()
            / event.snapshot.totalByteCount.toDouble());
        print("THe percentage " + percentage.toString());
      });

      StorageTaskSnapshot storageTaskSnapshot =await storageUploadTask.onComplete;
      prescriptiondownloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      //Here you can get the download URL when the task has been completed.
      print("Download URL " + prescriptiondownloadUrl.toString());

    } else{
      //Catch any cases here that might come up like canceled, interrupted
    }

  }
}
