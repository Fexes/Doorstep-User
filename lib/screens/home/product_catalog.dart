

import 'dart:collection';
import 'dart:io';

import 'package:Doorstep/models/Cart.dart';
import 'package:Doorstep/models/Product.dart';
import 'package:Doorstep/models/Shops.dart';
import 'package:Doorstep/screens/auth/sign-in.dart';
import 'package:Doorstep/screens/home/shops_screen.dart';
import 'package:Doorstep/screens/home/single_product.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
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

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'package:progress_dialog/progress_dialog.dart';



import 'package:http/http.dart' as http;

import 'cart_screen.dart';
import 'home_screen.dart';

class ProductCatalog extends StatefulWidget {
  String itemcategory;
  Shops shop;
  ProductCatalog(Shops s, String ic){
    itemcategory=ic;
    shop=s;
  }


  @override
  _ProductCatalogState createState() => _ProductCatalogState(shop,itemcategory);
}

class _ProductCatalogState extends State<ProductCatalog> {

  bool isloadingDialogueShowing=false;

  bool isLoadingError=false;
  Shops shop;

  String itemcategory;
  _ProductCatalogState(Shops s,String ic){
    itemcategory=ic;
    shop=s;

  }
  bool isLoaded=false;
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


  Dialog loadingdialog;

  List<Cart> carts;
  int cartsize=0;

  FirebaseUser user=null;

  String img;

  @override
  initState()   {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
    productscat = new List();
    products = new List();
    productsItemcount = new List();
    category = new List();
    tempcategory = new List();
    carts = new List();

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0) {
          _buttonShowing=true;
        } else {
          _buttonShowing=false;
        }
        setState(() {

        });
      }
    });

    img="https://firebasestorage.googleapis.com/v0/b/doorstep-fdb26.appspot.com/o/images%2Fimg_missing.png?alt=media&token=60b4508f-9d43-41db-a85d-5e16240a4466";


    if(itemcategory!=null) {
      selectfilter = itemcategory.toUpperCase();
      filterProductCatagory(selectfilter);

    }
    Future.delayed(const Duration(milliseconds: 500), () {

// Here you can write your code

      setupessentials();

    });



  }

  void setupessentials(){
    setuplist();




    FirebaseAuth.instance.currentUser().then((firebaseUser){
      user=firebaseUser;

    });

    //  filterProductCatagory("fruit");


    FirebaseAuth.instance.currentUser().then((firebaseUser){

      user=firebaseUser;

      if(firebaseUser != null) {

        try {
          final FirebaseDatabase database = FirebaseDatabase.instance;
          volunteerRef =
              database.reference().child("Cart").child(firebaseUser.uid);
          volunteerRef.onChildAdded.listen(_onEntryAddedcart);
          volunteerRef.onChildChanged.listen(_onEntryChangedcart);
        }catch(e){

        }


      }


    });
  }


  _onEntryChangedcart(Event event) {
    try {
      var old = carts.singleWhere((entry) {
        return entry.key == event.snapshot.key;
      });


      setState(() {
        carts[carts.indexOf(old)] = Cart.fromSnapshot(event.snapshot);
      });
    }catch(e){

    }
  }

  _onEntryAddedcart(Event event) {
    setState(() {
      carts.add(Cart.fromSnapshot(event.snapshot));

    });
  }


  filterProducts(String filter) {

    products.clear();
    productsItemcount.clear();
    for(int i=0;i<=productscat.length-1;i++){
      if(productscat[i].cardname.toLowerCase().contains(filter.toLowerCase())){
        products.add(productscat[i]);
        productsItemcount.add(0);
      }

    }
    setState(() {

    });

  }



  filterProductCatagory(String filter) {

    if(filter=="All"){
      products.clear();
      productsItemcount.clear();

      for (int i = 0; i <= productscat.length - 1; i++) {

        products.add(productscat[i]);
        productsItemcount.add(0);
      }
    }else {
      products.clear();
      productsItemcount.clear();

      for (int i = 0; i <= productscat.length - 1; i++) {
        if (productscat[i].category.toLowerCase().contains(
            filter.toLowerCase())) {
          products.add(productscat[i]);
          productsItemcount.add(0);
        }
      }
    }
    setState(() {

    });

  }
  Future<void> setuplist() async {

    products.clear();
    productsItemcount.clear();

    final FirebaseDatabase database = FirebaseDatabase.instance;
    volunteerRef = database.reference().child("Shops").child(DataStream.ShopCatagory).child(shop.shopid).child("Products");
    volunteerRef.onChildAdded.listen(_onEntryAdded);

  }

  bool checkTime(String open, String close){

    if(open==null||close==null){
      return true;
    }


    final currentTime = DateTime.now();


    final startTime = DateTime(currentTime.year, currentTime.month, currentTime.day,int.parse(open.split(":")[0]) , int.parse(open.split(":")[1]));
    final endTime = DateTime(currentTime.year, currentTime.month, currentTime.day,int.parse(close.split(":")[0]) , int.parse(close.split(":")[1]));



    if(startTime.isBefore(endTime)) {
      // print("day shop");

      if (currentTime.isBefore(startTime) || currentTime.isAfter(endTime)) {
        return false;
      } else {
        // if(currentTime.isBefore(startTime) && currentTime.isAfter(endTime)){
        return true;


      }
    }else{

      // print("night shop");

      if (currentTime.isAfter(startTime) || currentTime.isBefore(endTime)) {

        return true;
      } else {
        // if(currentTime.isBefore(startTime) && currentTime.isAfter(endTime)){
        return false;


      }
    }
  }


  _onEntryAdded(Event event) {

    isLoaded=true;
    products.add(Product.fromSnapshot(event.snapshot));
    productsItemcount.add(0);
    productscat.add(Product.fromSnapshot(event.snapshot));

    tempcategory.add("All");


    tempcategory.add(Product.fromSnapshot(event.snapshot).category.toUpperCase().trim());
    tempcategory = tempcategory.toSet().toList();

    setState(() {

    });

  }


  _onOnFocusNodeEvent() {

  }

  List<Product> products;

  List<Product> shopProducts;

  List<int> productsItemcount;

  List<Product> productscat;
  List<String> tempcategory;
  List<Product> Searchproducts;

  List<String> category;

  String selectfilter="All";

  DatabaseReference volunteerRef;


  bool _buttonShowing = true;

  final TextEditingController _searchTextController =
  TextEditingController();

  String search="";
  String catsearch="";

  bool searchVisiblity=false;
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {

    return

      Scaffold(

        body:  Column(
          children: [
            Flexible(
              flex: 10,

              child: NestedScrollView(
                physics: ClampingScrollPhysics(),

                //controller: _controller,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[

                    SliverAppBar(
                      expandedHeight: 230.0,

                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text( shop.shopname,
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        background:Container(
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

                                  DateFormat("h:mma").format(DateFormat("hh:mm").parse(shop.openTime)) == DateFormat("h:mma").format(DateFormat("hh:mm").parse(shop.closeTime))?
                                  Text(
                                    "24 / 7 Open",
                                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400,color: Colors.white),
                                  ):
                                  Text(
                                    DateFormat("h:mma").format(DateFormat("hh:mm").parse(shop.openTime))  +"  -  "+ DateFormat("h:mma").format(DateFormat("hh:mm").parse(shop.closeTime)),
                                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400,color: Colors.white),
                                  ),
                                  shop.distanceInKM!=null?
                                  Text(
                                    "Delivery "+ ((shop.distanceInKM*3)+20).toString().split(".")[0] +" - "+((shop.distanceInKM*3)+30).toString().split(".")[0]+" min",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300,color: Colors.white),
                                  ):SizedBox(),


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

                    //    SizedBox(height: 90,),
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


                                      // final FormState form = _formKey.currentState;
                                      //   form.save();
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
                                          filterProducts(search);
                                          _searchTextController.clear();

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
                    SizedBox(height: 10,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: tempcategory.map((String char){
                          return
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: FlatButton(
                                    onPressed: (){
                                      search="";
                                      filterProducts(search);
                                      _searchTextController.clear();


                                      selectfilter=char;
                                      filterProductCatagory(char);

                                    },
                                    shape: RoundedRectangleBorder(

                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.green[400])),
                                    color:selectfilter==char? Colors.green[100]: Colors.white ,


                                    textColor: Colors.green[600],
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      char.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            );


                        }).toList(),
                      ),
                    ),




                    Flexible(
                      flex: 1,
                      child:

                      Container(
                          child:

                          isLoaded?

                          GridView.builder(
                            //SliverGridDelegateWithFixedCrossAxisCount
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              // childAspectRatio: 0.570,
                              childAspectRatio: 0.500,
                              mainAxisSpacing: 1.0,
                              crossAxisSpacing: 1.0,
                            ),
                            itemCount: products.length,

                            padding: EdgeInsets.all(8.0),
                            itemBuilder: (BuildContext context, int index) {


                              for(int i=0;i<=carts.length-1;i++){

                                for(int j=0;j<=products.length-1;j++) {
                                  if (carts[i].cardid == products[j].cardid && carts[i].shopid == shop.shopid) {
                                    productsItemcount[j] = carts[i].no_of_items;
                                  }
                                }

                              }


                              return Stack(
                                children: [
                                  GestureDetector(

                                    onLongPress: (){
                                      products[index].stock!="out_of_stock"?

                                      // Navigator.of(context).pushReplacement(
                                      //     MaterialPageRoute(
                                      //         builder: (context) => SingleProduct(products[index],productsItemcount[index]))):
                                      Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => SingleProduct(products[index],productsItemcount[index]),),):
                                      ToastUtils.showCustomToast(context, "Item Out of Stock",null);


                                    },
                                    onTap: (){


                                      if(user==null){
                                        ToastUtils.showCustomToast(context, "Long Press to View Details", null);

                                      }else{

                                        if(products[index].stock=="out_of_stock") {
                                          ToastUtils.showCustomToast(context, "Item Out of Stock",null);


                                        }else{
                                          productsItemcount[index]++;


                                          FirebaseDatabase database = new FirebaseDatabase();
                                          DatabaseReference _userRef = database
                                              .reference()
                                              .child('Cart').child(DataStream.UserId).child(products[index].cardid+shop.shopid);

                                          _userRef.set(<dynamic, dynamic>{
                                            'no_of_items': productsItemcount[index],
                                            'cardid': products[index].cardid.toString(),
                                            'cardname': products[index].cardname
                                                .toString(),
                                            'cardimage': products[index].cardimage
                                                .toString(),
                                            'cardprice': products[index].cardprice,
                                            'unit': products[index].unit,
                                            'shopcatagory': DataStream.ShopCatagory,
                                            'itemcatagory': products[index].category,
                                            'shopid': DataStream.ShopId,


                                          }).then((value) {
                                            setState(() {

                                            });
                                          });
                                        }

                                      }

                                    },
                                    child:Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(


                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color:  Colors.grey.withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 4,
                                              ),
                                            ],
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            color: Colors.white
                                        ),

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 10,),

                                            Stack(
                                              children: [




                                                Container(
                                                  height: (screenWidth(context)/3)-20,
                                                  width:  (screenWidth(context)/3)-20,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[100],
                                                    shape: BoxShape.rectangle,
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(products[index].cardimage.length>10?products[index].cardimage:"https://firebasestorage.googleapis.com/v0/b/doorstep-fdb26.appspot.com/o/images%2Fimg_missing.png?alt=media&token=60b4508f-9d43-41db-a85d-5e16240a4466"),
                                                      //  image: CacheImage(products[index].cardimage.length>10?products[index].cardimage:"https://firebasestorage.googleapis.com/v0/b/doorstep-fdb26.appspot.com/o/images%2Fimg_missing.png?alt=media&token=60b4508f-9d43-41db-a85d-5e16240a4466"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                products[index].stock=="out_of_stock"||!checkTime(products[index].timeopen,products[index].timeclose)?


                                                Container(
                                                  height: (screenWidth(context)/3)-20,
                                                  width:  (screenWidth(context)/3)-20,
                                                  decoration: BoxDecoration(

                                                    shape: BoxShape.rectangle,
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),

                                                    color: Colors.black.withOpacity(0.7),
                                                  ),
                                                  child:  Center(
                                                    child: Text(
                                                      "Out of Stock",
                                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,color: Colors.white,),
                                                    ),
                                                  ),
                                                ):SizedBox(),




                                              ],
                                            ),

                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [

                                                      Text(
                                                        products[index].cardname,
                                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,color: Colors.black),
                                                      ),
                                                      Text('Rs. ${products[index].cardprice} / ${products[index].unit}'
                                                        ,
                                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400,color: Colors.black),
                                                      ),

                                                      SizedBox(height: 5,),

                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text('${products[index].category} '
                                                            ,
                                                            style: TextStyle(fontSize: 7, fontWeight: FontWeight.w300,color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),



                                  ),

                                  productsItemcount[index]>0?

                                  Positioned(
                                    // top: 10.5,
                                    child: InkWell(
                                      onTap: () {


                                        productsItemcount[index]--;

                                        FirebaseDatabase database = new FirebaseDatabase();
                                        DatabaseReference _userRef = database
                                            .reference()
                                            .child('Cart').child(
                                            DataStream.UserId).child(
                                            products[index].cardid + shop.shopid);

                                        _userRef.set(<dynamic, dynamic>{
                                          'no_of_items': productsItemcount[index],
                                          'cardid': products[index].cardid
                                              .toString(),
                                          'cardname': products[index].cardname
                                              .toString(),
                                          'cardimage': products[index].cardimage
                                              .toString(),
                                          'cardprice': products[index].cardprice,
                                          'unit': products[index].unit,
                                          'shopcatagory': DataStream.ShopCatagory,
                                          'shopid': DataStream.ShopId,


                                        }).then((value) {

                                        });

                                        setState(() {

                                        });

                                      },
                                      child: new Container(
                                        width: 27,
                                        height: 27,
                                        decoration: new BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: new BorderRadius.circular(20.0),
                                        ),
                                        child: new Center(child:
                                        Container(
                                          width: 10,
                                          height: 1.8,
                                          color: Colors.white,
                                        ),),
                                      ),
                                    ),
                                  )
                                      : SizedBox(),



                                  productsItemcount[index]>0?

                                  Positioned(
                                    //  top: 10.5,
                                    right:1,
                                    child: InkWell(

                                      child: new Container(
                                        width: 27,
                                        height: 27,
                                        decoration: new BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: new BorderRadius.circular(20.0),
                                        ),
                                        child: new Center(child:
                                        Text(productsItemcount[index].toString(),style: TextStyle(color: Colors.white,fontSize: 15),),


                                        ),
                                      ),
                                    ),
                                  )
                                      :


                                  SizedBox(),
                                ],
                              );


                            },

                          )


                              :Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset("assets/icons/logo.png",height: 23,width: 23, ),

                                  SpinKitFadingCircle(
                                    size: 60,
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
                              SizedBox(height: 2,),

                              Text("Loading", style: TextStyle(fontSize: 16,color: Colors.black),),
                              SizedBox(height: 2,),
                              Text("Please wait while we load all items", style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w300),),

                            ],
                          ))
                      ),


                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                height: 60,
                width: screenWidth(context)-40,
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
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  // color: Colors.green,
                  onPressed: (){
                    //   Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => CartScreen(),),);


                    if(user!=null) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => CartScreen()));
                    }else{
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => SignIn()));
                    }
                  },
                  //   child: Icon(Icons.shopping_cart,color: Colors.white,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      user!=null?Icon(Icons.shopping_cart,color: Colors.white,size: 20,):SizedBox(),
                      SizedBox(width: 10,),
                      Text(user!=null?'My Cart':'Sign In',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 16),),



                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

      );



  }

}
