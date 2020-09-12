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
  FocusNode _focusNode;

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();

  }
  Dialog loadingdialog;



   @override
  initState()   {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
    productscat = new List();
    products = new List();
    category = new List();
    tempcategory = new List();

    setuplist();
  //  filterProductCatagory("fruit");


  }

  filterProducts(String filter) {

     products.clear();
     for(int i=0;i<=productscat.length-1;i++){
       if(productscat[i].cardname.toLowerCase().contains(filter.toLowerCase())){
         products.add(productscat[i]);
       }

     }
     setState(() {

     });
  }



  filterProductCatagory(String filter) {

     if(filter=="All"){
       products.clear();
       for (int i = 0; i <= productscat.length - 1; i++) {

           products.add(productscat[i]);

       }
      }else {
       products.clear();
       for (int i = 0; i <= productscat.length - 1; i++) {
         if (productscat[i].category.toLowerCase().contains(
             filter.toLowerCase())) {
           products.add(productscat[i]);
         }
       }
     }
     setState(() {

    });
  }
  Future<void> setuplist() async {

    products.clear();


        final FirebaseDatabase database = FirebaseDatabase.instance;
        volunteerRef = database.reference().child("Shops").child(DataStream.ShopCatagory).child(SHOP_KEY).child("Products");
        volunteerRef.onChildAdded.listen(_onEntryAdded);

  }




  _onEntryAdded(Event event) {
    setState(() {
      products.add(Product.fromSnapshot(event.snapshot));
      productscat.add(Product.fromSnapshot(event.snapshot));

      tempcategory.add("All");
      tempcategory.add(Product.fromSnapshot(event.snapshot).category);
      tempcategory = tempcategory.toSet().toList();

      //   print(products.length);
    });
  }


  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  List<Product> products;
  List<Product> productscat;
  List<String> tempcategory;
  List<Product> Searchproducts;

  List<String> category;

  DatabaseReference volunteerRef;



  final TextEditingController _searchTextController =
  TextEditingController();

   String search="";
  String catsearch="";

  bool searchVisiblity=false;

  @override
  Widget build(BuildContext context) {




    return
      Scaffold(

        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[

              SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text( shop.shopname,
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    background:Container(
                      height: 100,
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

                          height: 150,
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
                                shop.openTime +" a.m  -  "+ shop.closeTime +" p.m",
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400,color: Colors.white),
                              ),
                              Text(
                                "Delivery 30 - 60 min",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300,color: Colors.white),
                              ),
                              Text(
                                "Depending on your location",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200,color: Colors.white),
                              ),



                            ],
                          ),

                        ),
                      ), /* add child content here */
                    ),

                ),
              ),
            ];
          },
          body:
            Column(
              children: [

                SizedBox(height: 90,),
                 Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: Container(

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                              flex: 1,
                              child: Icon(Icons.search)),
                          SizedBox(width: 10,),
                          Flexible(
                            flex: 18,
                            child: Container(
                              child: TextFormField(
                                cursorColor: Colors.black, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
                                keyboardType: TextInputType.text,

                                controller: _searchTextController,
                                onChanged: (String value){

                                  search = value;

                                  filterProducts(search);

                                  setState(() {

                                  });
                                  // final FormState form = _formKey.currentState;
                                  //   form.save();
                                },
                                validator: (String value) {
                                  if(value.length != 10)
                                    return 'Please enter correct Phone Number';
                                  else
                                    return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none
                                  ),
                                  hintText: "Search",
                                ),
                                focusNode: _focusNode,
                              ),
                            ),
                          ),

                          Flexible(
                            flex: 1,
                            child: Visibility(
                              //         visible: true,
                                visible: search.length>0?true:false,
                                child: GestureDetector(
                                    onTap: (){
                                       search="";
                                      _searchTextController.clear();
                                      setState(() {

                                      });
                                    },
                                    child: Icon(Icons.cancel,color: Colors.redAccent,))),
                          ),
                          SizedBox(width: 5,),

                        ],
                      ),
                    ),
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
                          color:  Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: tempcategory.map((String char){
                    return RaisedButton(
                        onPressed: (){

                           filterProductCatagory(char);
                           setState(() {

                          });
                        },
                        child: Text(char)

                    );
                  }).toList(),
                ),



                Flexible(
                  flex: 1,
                  child: Container(
                    child:

                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
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
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.white),
                                        ),
                                        Text('Rs. ${products[index].cardprice} / ${products[index].unit}'
                                          ,
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300,color: Colors.white),
                                        ),

                                        Text(' ${products[index].category} '
                                          ,
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300,color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ), /* add child content here */
                            ),
                          ),
                        );
                      },
                    ),
                  ),


//                  child: StreamBuilder(
//                      stream: FirebaseDatabase.instance
//                          .reference()
//                          .child("Shops").child(DataStream.ShopCatagory).child(SHOP_KEY).child("Products")
//                          .onValue,
//                      builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
//                        if (snapshot.hasData) {
//                          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
//
//
//                          products.clear();
//
//                          List<String> tempcategory;
//                          tempcategory= new List();
//                          if(map!=null) {
//                            map.forEach((dynamic, v) {
//                              if (v["cardname"].toString().toLowerCase().contains(
//                                  search.toLowerCase())
////                                  &&
////                                  v["category"].toString().toLowerCase() ==
////                                      catsearch.toLowerCase()
//
//                              ){
//
//
//
//                                  products.add(new Product(
//                                      v["key"], v["cardid"], v["cardname"],
//                                      v["cardimage"],
//                                      v["cardprice"], v["carddiscription"], v["unit"],v["category"]));
//
//                                  tempcategory.add("All");
//
//                                  tempcategory.add(v["category"]);
//
//
//
//
//
//                              }
//                            }
//
//
//
//
//                        );
//                          }
//
//
//
//                          category = tempcategory.toSet().toList();
//
//
//
//
//                          return Container(
//                            child:
//
//                                GridView.builder(
//                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                                      crossAxisCount: 3),
//                                  itemCount: products.length,
//                                  padding: EdgeInsets.all(2.0),
//                                  itemBuilder: (BuildContext context, int index) {
//                                    return     GestureDetector(
//                                      onTap: (){
//                                        Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => SingleProduct(products[index]),),);
//
//                                      },
//                                      child: Padding(
//                                        padding: EdgeInsets.all(5),
//                                        child: Container(
//
//                                          width: (screenWidth(context)/2)-15,
//                                          height: 150,
//                                          decoration: BoxDecoration(
//
//                                            shape: BoxShape.rectangle,
//                                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                            image: DecorationImage(
//                                              image: NetworkImage(products[index].cardimage),
//                                              fit: BoxFit.cover,
//                                            ),
//                                          ),
//                                          child:  Padding(
//                                            padding: EdgeInsets.all(0),
//                                            child: Container(
//
//                                              decoration: BoxDecoration(
//                                                shape: BoxShape.rectangle,
//                                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                                gradient: new LinearGradient(
//
//                                                    colors: [
//                                                      Colors.black.withOpacity(0.7),
//                                                      const Color(0x19000000),
//                                                    ],
//
//                                                    begin: const FractionalOffset(0.0, 1.0),
//                                                    end: const FractionalOffset(0.0, 0.0),
//                                                    stops: [0.0, 1.0],
//                                                    tileMode: TileMode.clamp),
//                                              ),
//                                              child: Padding(
//                                                padding: EdgeInsets.all(10),
//                                                child: Column(
//                                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                                  mainAxisAlignment: MainAxisAlignment.end,
//                                                  children: [
//                                                    Text(
//                                                      products[index].cardname,
//                                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.white),
//                                                    ),
//                                                    Text('Rs. ${products[index].cardprice} / ${products[index].unit}'
//                                                      ,
//                                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300,color: Colors.white),
//                                                    ),
//
//                                                    Text(' ${products[index].category} '
//                                                      ,
//                                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300,color: Colors.white),
//                                                    ),
//                                                  ],
//                                                ),
//                                              ),
//                                            ),
//                                          ), /* add child content here */
//                                        ),
//                                      ),
//                                    );
//                                  },
//                                ),
//                          );
//                        } else {
//                          return CircularProgressIndicator();
//                        }
//                      }),
                ),
              ],
            ),
        ),
      );
  }

}
/*

 return ;
 */