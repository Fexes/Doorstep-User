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
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'package:progress_dialog/progress_dialog.dart';



import 'package:http/http.dart' as http;

import 'checkout_screen.dart';
import 'product_catalog.dart';
import 'home_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

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
        volunteerRef = database.reference().child("Cart").child(firebaseUser.uid);
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
        title:  Text("Cart"),
        automaticallyImplyLeading: false,
      ),

      body:
      carts.length>0?
      Stack(
        children: [
          Column(
            children: <Widget>[

              Flexible(
                flex: 10,
                child: FirebaseAnimatedList(
                  query: volunteerRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {

                 //   Subtotal=Subtotal+carts[index].cardprice;
                    return GestureDetector(
                      onTap: (){


                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [

                            GestureDetector(
                              onTap : (){




                                print(userid);
                                final FirebaseDatabase _databaseCustom = FirebaseDatabase.instance;
                                _databaseCustom.reference().child("Cart").child(userid).child(snapshot.key).remove().then((value) {
                                  setuplist();
                                  setState(() {

                                  });
                                 });


                             //   ToastUtils.showCustomToast(context, "Removed", true);
                            // setuplist();
                              },
                              child: Padding(
                                  padding:EdgeInsets.fromLTRB(10, 0, 20, 0),
                                  child: Icon(Icons.clear,color: Colors.redAccent,size: 35,)),
                            ),

                            Container(
                              height: 100,
                              width: 100,

                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                image: DecorationImage(
                                  image: NetworkImage(carts[index].cardimage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                             ),

                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${carts[index].cardname}',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
                                  ),
                                  Text(
                                    'Rs. ${carts[index].cardprice}  each',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
                                  ),
                                  Text(
                                    'Items: ${carts[index].no_of_items}',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
                                  ),
                                  Text(
                                    'Rs. ${carts[index].no_of_items*carts[index].cardprice}',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ),
                    );


                  },
                )
              ),

              Flexible(
                flex: 4,
                child: SizedBox(height: 90,),

              )
            ],
          ),
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 20),
              child: Column(
                children: [
                  Container(
                    height: 125,
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
                    width: screenWidth(context)-60,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [

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
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                         child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.redAccent,
                          onPressed: (){
                            FirebaseDatabase database = new FirebaseDatabase();

                            DatabaseReference del = database.reference();


                            del = database.reference()
                                .child("Cart").child(DataStream.UserId);
                            del.remove().then((value) {
                              carts.clear();
                              setState(() {

                              });
                            });


                          },
                          child: Icon(Icons.delete,color: Colors.white,size: 30,)
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        height: 60,
                        width: screenWidth(context)-130,
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
                         child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.green,
                          onPressed: (){

                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CheckOutScreen()));


                          },
                          child: Text('Checkout',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 18),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ):
      Center(child: Text("Empty")),
    );

  }


}
