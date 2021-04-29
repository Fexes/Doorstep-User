import 'dart:io';

import 'package:Doorstep/models/Cart.dart';
import 'package:Doorstep/models/Product.dart';
import 'package:Doorstep/models/Shops.dart';
import 'package:Doorstep/screens/auth/sign-in.dart';
import 'package:Doorstep/screens/home/cart_screen.dart';
import 'package:Doorstep/screens/home/shops_screen.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:badges/badges.dart';
import 'package:cache_image/cache_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firestore_ui/animated_firestore_grid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:Doorstep/styles/styles.dart';
 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stepper_counter_swipe/stepper_counter_swipe.dart';



import 'package:http/http.dart' as http;

import 'home_screen.dart';

class SingleProduct extends StatefulWidget {
  Product product;
   int count;
  SingleProduct(Product key,int cot){
    product=key;
    count=cot;
  }


  @override
  _SingleProductState createState() => _SingleProductState(product,count);
}

class _SingleProductState extends State<SingleProduct> {

  bool isloadingDialogueShowing=false;

  bool isLoadingError=false;

  Product product;
  int count;

  _SingleProductState(Product p,int c){
    product=p;
    count=c;
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


  List<Cart> carts;
  FirebaseUser user=null;
   @override
  initState()   {
    super.initState();



    FirebaseAuth.instance.currentUser().then((firebaseUser){


      user=firebaseUser;

      if(firebaseUser != null){
        carts = new List();

        DatabaseReference volunteerRef;

        final FirebaseDatabase database = FirebaseDatabase.instance;
        volunteerRef = database.reference().child("Cart").child(DataStream.UserId);
        volunteerRef.onChildAdded.listen(_onEntryAdded);
        volunteerRef.onChildChanged.listen(_onEntryChanged);

        setState(() {

        });
      }


    });






   }

  _onEntryChanged(Event event) {
    var old = carts.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      carts[carts.indexOf(old)] = Cart.fromSnapshot(event.snapshot);
    });
  }


  _onEntryAdded(Event event) {
    setState(() {
      carts.add(Cart.fromSnapshot(event.snapshot));
    });
  }





  int val=0;

   String UserId;

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
        title:  Text(product.cardname),

        automaticallyImplyLeading: false,
      ),

      body:Stack(
        children: [



          ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Padding(
                    padding: EdgeInsets.all(14),
                    child: Container(
                      height: 250,
                      width: double.infinity,

                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:  Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                          ),
                        ],
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        image: DecorationImage(
                          image: NetworkImage(product.cardimage),
                       //   image: CacheImage(product.cardimage.length>10?product.cardimage:"https://firebasestorage.googleapis.com/v0/b/doorstep-fdb26.appspot.com/o/images%2Fimg_missing.png?alt=media&token=60b4508f-9d43-41db-a85d-5e16240a4466"),

                          fit: BoxFit.cover,
                        ),
                      ),
                      child:  Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(

                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),

                          ),

                        ),
                      ), /* add child content here */
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.cardname,
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500,color: Colors.black),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [
                            Text(
                              'Rs. ${product.cardprice} /',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color: Colors.green[800]),
                            ),
                            Text(
                              ' ${product.unit}',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,color: Colors.black),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 20,),



                  Padding(
                    padding: EdgeInsets.fromLTRB(30,0,30,0),
                    child: Container(
                      height: 0.4,
                      width: double.infinity,
                      color: Colors.black,

                    ),
                  ),
                  SizedBox(height: 10,),

                  Stack(

                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(15,30,0,0),

                        child: Text(
                          'Quantity',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color: Colors.black),
                        ),
                      ),
                      Container(
                        height: 80,
                        child: Center(
                          child: StepperSwipe(
                            initialValue:count,


                            speedTransitionLimitCount: 1,
                            firstIncrementDuration: Duration(milliseconds: 450), //Unit time before fast counting
                            secondIncrementDuration: Duration(milliseconds: 200),
                            direction: Axis.horizontal,
                            dragButtonColor: Colors.green,
                            iconsColor: Colors.black,
                            withSpring: false,
                            maxValue:50,
                            stepperValue:count,
                            withNaturalNumbers: true,
                            withPlusMinus: true,
                            withFastCount: true,

                            onChanged: (int val) {

                              count=val;
                                setState(() {

                                });

                            }
                            ),
                          ),
                        ),

                    ],
                  ),

                  Center(
                    child: Text(
                      'slide to add or remove',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 10,),

                  Padding(
                    padding: EdgeInsets.fromLTRB(30,0,30,0),
                    child: Container(
                      height: 0.4,
                      width: double.infinity,
                      color: Colors.black,

                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 10,),
                        Text(
                          'Description',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color: Colors.black),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          product.carddiscription,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
                        ),

                        SizedBox(height: 70,),

                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            bottom: 0,
            child:
            user!=null?

            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 25),
              child: Row(
                children: [

                  Container(
                    height: 60,

                    decoration: BoxDecoration(
                      color: count==0?Colors.grey[600]: Colors.white,
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
                    width: (screenWidth(context)/2)-50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      color: count==0?Colors.grey[600]: Colors.white,
                      onPressed: () async {

                        if(count>0) {
                          setState(() {

                          });
                          FirebaseDatabase database = new FirebaseDatabase();
                          DatabaseReference _userRef = database.reference()
                              .child('Cart').child(DataStream.UserId).child(product.cardid+DataStream.ShopId);

                          _userRef.set(<dynamic, dynamic>{
                            'no_of_items': count,
                            'cardid': product.cardid.toString(),
                            'cardname': product.cardname.toString(),
                            'cardimage': product.cardimage.toString(),
                            'cardprice': product.cardprice,
                            'unit':product.unit,
                            'shopcatagory': DataStream.ShopCatagory,
                            'shopid': DataStream.ShopId,


                          }).then((_) {
                            setState(() {
                             // count=0;

                            });
                            ToastUtils.showCustomToast(
                                context, "Added to Cart", true);
                          });



                        }else{
                          ToastUtils.showCustomToast(context, "Select Quantity", null);
                        }
                      },
                      child: Text('Add to Cart',style: TextStyle(color: count==0?Colors.grey[400]: Colors.black,fontWeight: FontWeight.w500, fontSize: 16),),
                    ),
                  ),
                  SizedBox(width: 20,),

                  Badge(
                    badgeColor: Colors.redAccent,
                    badgeContent: Container(

                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text(carts.length.toString(),style: TextStyle(color: Colors.white,fontSize: 20),),
                          ],
                        ),
                      ),
                    ),
                    child: Container(
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
                            color: Colors.green.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      width: (screenWidth(context)/2)-50,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        color: Colors.green,
                        onPressed: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CartScreen()));

                        },
                        child: Text('Buy Now',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 16),),
                      ),
                    ),
                  ),
                ],
              ),
            ):
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10),
              child: SizedBox(
                width: screenWidth(context)-80,

                 child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),

                  ),

                  color: primaryDark,
                  onPressed: () async {
                    //   await loginUser();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => SignIn()));
                  },
                  child: Text( " Sign In",style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          ),


        ],
      )

    );

  }


}
/*

 return ;
 */