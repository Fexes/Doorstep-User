import 'dart:io';

import 'package:Doorstep/models/Product.dart';
import 'package:Doorstep/models/Shops.dart';
import 'package:Doorstep/screens/home/shops_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firestore_ui/animated_firestore_grid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:Doorstep/styles/styles.dart';
import 'package:Doorstep/screens/auth/sign-up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stepper_counter_swipe/stepper_counter_swipe.dart';



import 'package:http/http.dart' as http;

import 'home_screen.dart';

class SingleProduct extends StatefulWidget {
  Product product;

  SingleProduct(Product key){
    product=key;
  }
  
  @override
  _SingleProductState createState() => _SingleProductState(product);
}

class _SingleProductState extends State<SingleProduct> {

  bool isloadingDialogueShowing=false;

  bool isLoadingError=false;

  Product product;
  _SingleProductState(Product p){
    product=p;
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
                      color: index==1 ? Colors.orange[900] :index==2 ?Colors.orange[800] : index==3 ?Colors.orange[700] : index==4 ?
                      Colors.orange[600] :index==5 ?Colors.orange[500] : index==6 ?Colors.orange[400]:
                      index==1 ?Colors.orange[300] : index==1 ?Colors.orange[200] : index==1 ?Colors.orange[100] : index==1 ?
                      Colors.orange[100] :index==1 ?Colors.orange[100] :Colors.orange[900]
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


  }


  int val=0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),

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
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 250,
                      width: double.infinity,

                      decoration: BoxDecoration(

                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        image: DecorationImage(
                          image: NetworkImage(product.cardimage),
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
                        Text(
                          'Rs. ${product.cardprice}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color: Colors.green[800]),
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
                        padding: EdgeInsets.all(15),

                        child: Text(
                          'Quantity',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,color: Colors.black),
                        ),
                      ),
                      Container(
                        height: 60,
                        child: Center(
                          child: StepperSwipe(
                            initialValue:0,

                            speedTransitionLimitCount: 1,
                            firstIncrementDuration: Duration(milliseconds: 450), //Unit time before fast counting
                            secondIncrementDuration: Duration(milliseconds: 200),
                            direction: Axis.horizontal,
                            dragButtonColor: Colors.green,
                            iconsColor: Colors.black,
                            withSpring: false,
                            maxValue:50,
                            stepperValue:val,
                            withNaturalNumbers: true,
                            withPlusMinus: true,
                            withFastCount: true,
                            onChanged: (int val) => print('New value : $val'),
                          ),
                        ),
                      ),
                    ],
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
            child: Row(
              children: [
                Align(
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
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 70,
                    width: screenWidth(context)/2,
                    child: FlatButton(
                      color: Colors.grey[200],
                      onPressed: (){
                      },
                      child: Text('Add to Cart',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500, fontSize: 20),),
                    ),
                  ),
                ),
                Align(
                  child: Container(
                    height: 70,
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
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    width: screenWidth(context)/2,
                    child: FlatButton(
                      color: Colors.green,
                      onPressed: (){
                      },
                      child: Text('Buy Now',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 20),),
                    ),
                  ),
                ),
              ],
            )
          )
        ],
      )







    );

  }


}
/*

 return ;
 */