import 'dart:io';

import 'package:Doorstep/models/Product.dart';
import 'package:Doorstep/models/Shops.dart';
import 'package:Doorstep/screens/home/shops_screen.dart';
import 'package:Doorstep/screens/home/single_product.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
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



import 'package:http/http.dart' as http;

import 'home_screen.dart';

class ProductCatalog extends StatefulWidget {
  String SHOP_KEY;
  Shops shop;
  ProductCatalog(Shops s, String key){
    SHOP_KEY=key;
    shop=s;
  }


  @override
  _ProductCatalogState createState() => _ProductCatalogState(shop,SHOP_KEY);
}

class _ProductCatalogState extends State<ProductCatalog> {

  bool isloadingDialogueShowing=false;

  bool isLoadingError=false;
  Shops shop;

  String SHOP_KEY;
  _ProductCatalogState(Shops s,String key){
    SHOP_KEY=key;
    shop=s;

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

    products = new List();

  }

  List<Product> products;
   DatabaseReference volunteerRef;






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
        title:  Text(DataStream.ShopName),
        automaticallyImplyLeading: false,
      ),

      body:
      Column(
        children: [
          Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              height: 250,
              width: double.infinity,

              decoration: BoxDecoration(

                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(0)),
                image: DecorationImage(
                  image: NetworkImage(shop.shopimage),
                  fit: BoxFit.cover,
                ),
              ),
              child:  Padding(
                padding: EdgeInsets.all(0),
                child: Container(

                  height: 100,
                  decoration: BoxDecoration(

                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    gradient: new LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),

                  ),

                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          shop.shopname,
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500,color: Colors.white),
                        ),
                        Text(
                         "Delivery 45 min",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: Colors.white),
                        ),

                      ],
                    ),

                ),
              ), /* add child content here */
            ),
          ),
          Flexible(
            flex: 1,
            child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child("Shops").child("Bahria Town Phase 4").child("Super Market").child(SHOP_KEY).child("Products")
                    .onValue,
                builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasData) {
                    Map<dynamic, dynamic> map = snapshot.data.snapshot.value;


                    products.clear();

                   map.forEach((dynamic, v) =>
                       products.add( new Product(v["key"],v["cardid"] , v["cardname"],v["cardimage"] ,v["cardprice"] , v["carddiscription"]))
                   );

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: products.length,
                      padding: EdgeInsets.all(2.0),
                      itemBuilder: (BuildContext context, int index) {
                        return     GestureDetector(
                          onTap: (){
                            Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => SingleProduct(products[index]),),);

                           },
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Container(

                              width: (screenWidth(context)/2)-15,
                              height: 150,
                              decoration: BoxDecoration(

                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                image: DecorationImage(
                                  image: NetworkImage(products[index].cardimage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child:  Padding(
                                padding: EdgeInsets.all(0),
                                child: Container(

                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                    gradient: new LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.7),
                                          const Color(0x19000000),
                                        ],
                                        begin: const FractionalOffset(0.0, 1.0),
                                        end: const FractionalOffset(0.0, 0.0),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          products[index].cardname,
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
                                        ),
                                        Text('Rs. ${products[index].cardprice}'
                                          ,
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200,color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ), /* add child content here */
                            ),
                          ),
                        );


//
//                    Container(
//                    child: Image.network(
//                      map.values.toList()[index]["cardimage"],
//                      fit: BoxFit.cover,
//                    ),
//                    padding: EdgeInsets.all(2.0),
//                  );
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ),
        ],
      ),

//      FirebaseAnimatedList(
//        query: volunteerRef,
//
//        itemBuilder: (BuildContext context, DataSnapshot snapshot,
//            Animation<double> animation, int index ) {
//
//          return Padding(
//            padding: const EdgeInsets.all(5.0),
//            child: Row(
//              children: [
//                GestureDetector(
//                  onTap: (){
//
//                  },
//                  child: Padding(
//                    padding: EdgeInsets.all(5),
//                    child: Container(
//
//                      width: (screenWidth(context)/2)-15,
//                      height: 150,
//                      decoration: BoxDecoration(
//
//                        shape: BoxShape.rectangle,
//                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                        image: DecorationImage(
//                          image: NetworkImage(products[index].cardimage),
//                          fit: BoxFit.cover,
//                        ),
//                      ),
//                      child:  Padding(
//                        padding: EdgeInsets.all(0),
//                        child: Container(
//
//                          decoration: BoxDecoration(
//                            shape: BoxShape.rectangle,
//                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                            gradient: new LinearGradient(
//                                colors: [
//                                  Colors.black,
//                                  const Color(0x19000000),
//                                ],
//                                begin: const FractionalOffset(0.0, 1.0),
//                                end: const FractionalOffset(0.0, 0.0),
//                                stops: [0.0, 1.0],
//                                tileMode: TileMode.clamp),
//                          ),
//                          child: Padding(
//                            padding: EdgeInsets.all(10),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              mainAxisAlignment: MainAxisAlignment.end,
//                              children: [
//                                Text(
//                                  products[index].cardname,
//                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
//                                ),
//                                Text('Rs. ${products[index].cardprice}'
//                                  ,
//                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200,color: Colors.white),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ), /* add child content here */
//                    ),
//                  ),
//                ),
//                GestureDetector(
//                  onTap: (){
//
//                  },
//                  child: Padding(
//                    padding: EdgeInsets.all(5),
//                    child: Container(
//                      width: (screenWidth(context)/2)-15,
//
//                      height: 150,
//                      decoration: BoxDecoration(
//
//                        shape: BoxShape.rectangle,
//                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                        image: DecorationImage(
//                          image: NetworkImage(products[index].cardimage),
//                          fit: BoxFit.cover,
//                        ),
//                      ),
//                      child:  Padding(
//                        padding: EdgeInsets.all(0),
//                        child: Container(
//
//                          decoration: BoxDecoration(
//                            shape: BoxShape.rectangle,
//                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                            gradient: new LinearGradient(
//                                colors: [
//                                  Colors.black,
//                                  const Color(0x19000000),
//                                ],
//                                begin: const FractionalOffset(0.0, 1.0),
//                                end: const FractionalOffset(0.0, 0.0),
//                                stops: [0.0, 1.0],
//                                tileMode: TileMode.clamp),
//                          ),
//                          child: Padding(
//                            padding: EdgeInsets.all(10),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              mainAxisAlignment: MainAxisAlignment.end,
//                              children: [
//                                Text(
//                                  products[index].cardname,
//                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
//                                ),
//                                Text('Rs. ${products[index].cardprice}'
//                                  ,
//                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200,color: Colors.white),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ), /* add child content here */
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          );
//
//        },
//      ),



    );

  }


}
/*

 return ;
 */