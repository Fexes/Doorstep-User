import 'dart:io';
import 'dart:math';

import 'package:Doorstep/models/Banners.dart';
import 'package:Doorstep/models/Cart.dart';
import 'package:Doorstep/models/Order.dart';
import 'package:Doorstep/models/Product.dart';
import 'package:Doorstep/models/ShopCategory.dart';
import 'package:Doorstep/models/Shops.dart';
import 'package:Doorstep/models/AppUser.dart';
import 'package:Doorstep/screens/auth/sign-in.dart';
import 'package:Doorstep/screens/home/product_catalog.dart';
import 'package:Doorstep/screens/home/shops_screen.dart';
import 'package:Doorstep/screens/home/single_product.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:Doorstep/styles/styles.dart';
 
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';



import 'package:http/http.dart' as http;
import 'package:spannable_grid/spannable_grid.dart';
 import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'cart_screen.dart';
import 'order_items_screen.dart';

class Home extends StatefulWidget {
  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<Home> {

  bool isloadingDialogueShowing=false;
  bool isLoadingError=false;
  hideLoadingDialogue(){

    if(isloadingDialogueShowing) {
      Navigator.of(context).pop();
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

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  @override
  void dispose() {
    super.dispose();

  }

  bool profileedit =false;
  List<Cart> carts;

  Dialog loadingdialog;
  FirebaseUser user=null;

  final firstname = TextEditingController();
  final lasename = TextEditingController();
   final email = TextEditingController();

  @override
  Future<void> initState()  {
    super.initState();



    haswhatsapp();

    FirebaseAuth.instance.currentUser().then((firebaseUser){



      user=firebaseUser;

       if(firebaseUser != null){
         print(user.uid);

        setupCart();
        setupBanner();
        getodercount();

         getUserDetails();

      }else{
         setupBanner();
       }


    });

  }

  haswhatsapp() async {
 //   whatsapp = await FlutterLaunch.hasApp(name: "whatsapp");
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
    whatsapp=true;
    setState(() {

    });
  }

   static void getodercount(){
    final locationDbRef = FirebaseDatabase.instance.reference().child("User Orders").child(DataStream.UserId).child("Order Count");

    locationDbRef.once().then((value) async {
      if(value.value!=null){

        print(value.value["no_of_orders"]);
        DataStream.order_count = value.value['no_of_orders'];

      }

    }
    );
  }
  int catlistcount;
  List<ShopCategory> shopcat;
  List<ShopCategory> shopcat2;
  List<ShopCategory> shopcat3;
   List<Order> orders;
  List<Banners> banners;
  bool whatsapp=false;
  DatabaseReference volunteerRef;
  List<String> imgList;

  bool bannerloaded=false;
  void setupBanner(){

    shopcat = new List();
    shopcat2 = new List();
    shopcat3 = new List();
    banners = new List();
    imgList = new List();


    DatabaseReference volunteerRef;

    final FirebaseDatabase database = FirebaseDatabase.instance;
    volunteerRef = database.reference().child("Admin").child("Banners");
    volunteerRef.onChildAdded.listen((event) {
      setState(() {

        bannerloaded=true;

        if(Banners.fromSnapshot(event.snapshot).radius!=null) {
          double distanceInKM = calculateDistance(
              DataStream.userlocation.latitude,
              DataStream.userlocation.longitude, double.parse(Banners
              .fromSnapshot(event.snapshot)
              .location
              .toString()
              .split(",")[0]), double.parse(Banners
              .fromSnapshot(event.snapshot)
              .location
              .toString()
              .split(",")[1]));

          if (distanceInKM < Banners
              .fromSnapshot(event.snapshot)
              .radius) {
            banners.add(Banners.fromSnapshot(event.snapshot));
            imgList.add(Banners
                .fromSnapshot(event.snapshot)
                .image);
          }
        }else{
          banners.add(Banners.fromSnapshot(event.snapshot));
          imgList.add(Banners
              .fromSnapshot(event.snapshot)
              .image);
        }
      });

    });

  }

  AppUser appuser=DataStream.appuser;
  void getUserDetails(){

    appuser= new AppUser("","","","","");

    final locationDbRef = FirebaseDatabase.instance.reference().child("Users").child(DataStream.UserId);

    locationDbRef.once().then((value) async {
      if(value.value!=null){
        appuser= new AppUser(value.value["first_name"], value.value["last_name"],value.value["phone"] , value.value["email"],value.value["userTokenID"]);
        setState(() {

        });
      }else{

      }



    }
    );

  }

  void setupCart(){

    orders = new List();
    carts = new List();

    DatabaseReference volunteerRef;

    final FirebaseDatabase database = FirebaseDatabase.instance;
    volunteerRef = database.reference().child("Cart").child(DataStream.UserId);
    volunteerRef.onChildAdded.listen(_onEntryAdded);
    volunteerRef.onChildChanged.listen(_onEntryChanged);

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


  int _selectedIndex = 0;
  int _current = 0;

  @override
  Widget build(BuildContext context) {
   // imgList = new List();

    List<Widget> imageSliders;
    List<SpannableGridCellData> cells = List();




      if (bannerloaded) {
        imageSliders = banners.map((item) =>
            Container(
              child: Container(
                //  margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(

                              boxShadow: [
                                BoxShadow(
                                  color:  Colors.grey.withOpacity(0.9),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                ),
                              ],
                            ),
                                child: GestureDetector(
                                  onTap:() {

                                    DataStream.ShopId=item.shopid;
                                   // print(item.shopid);





                                    if(item.shopid!=null) {
                                      if (item.productid != null) {
                                        final productDbRef = FirebaseDatabase
                                            .instance.reference().child("Shops")
                                            .child(item.shopcatacgry).child(
                                            item.shopid).child("Products")
                                            .child(item.productid);

                                        productDbRef.once().then((value) async {
                                          if (value.value != null) {
                                            Product bannerproduct = new Product
                                                .fromSnapshot(value);


                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (
                                                  BuildContext context) =>
                                                  SingleProduct(
                                                      bannerproduct, 0),),);
                                          }
                                        });
                                      }

                                      if (item.productid == null) {
                                        final shopDbRef = FirebaseDatabase
                                            .instance.reference().child(
                                            "shopuser").child(item.shopid);

                                        shopDbRef.once().then((value) async {
                                          if (value.value != null) {
                                            Shops bannershop = new Shops
                                                .fromSnapshot(value);
                                            DataStream.ShopCatagory =
                                                bannershop.shopcategory;

                                            Navigator.push(
                                              context, MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ProductCatalog(
                                                      bannershop,
                                                      item.itemcategory),),);
                                          }
                                        });
                                      }
                                    }
                                    },
                                  child: Image.network(
                                    item.image, fit: BoxFit.cover, width: 1000.0),
                                ),

                          ),
                        ),


                      ],
                    )
                ),
              ),
            )).toList();
      }

     Widget HomeScreen  = Scaffold(
       appBar: AppBar(
         title:  Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             user!=null?
             GestureDetector(
               onTap: () async {

              //   FlutterOpenWhatsapp.sendSingleMessage("+923125212919", "");

                 UrlLauncher.launch('whatsapp://send/?phone=+923125212919&text=');


              //   print("asdasd");

               },
                child:   Image.asset("assets/icons/whatsapp.png",height: 33,width: 33, ),


             )
                 :SizedBox(height: 1,),

             Text('Doorstep'),
           //  Image.asset("assets/icons/logo.png",height: 40,width: 40, ),

             user!=null?
               GestureDetector(
                 onTap: (){
                   Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => CartScreen(),),).then((value) {setupCart();});

                 },
                 child: Badge(
                   badgeColor: Colors.redAccent,
                   badgeContent: Container(
                     height: 17,
                     width: 17,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [

                            Text(carts.length.toString(),style: TextStyle(color: Colors.white,fontSize: 11),),
                       ],
                     ),
                   ),



                     child: Icon(Icons.shopping_cart,size: 34,),
                 ),
               )
              :SizedBox(height: 1,)


           ],
         ),
         automaticallyImplyLeading: false,
       ),
        body: Center(
         child: Column(
          children: [
            SizedBox(height: 5,),
             Flexible(
              flex: 1,
              child: Stack(
                children: [


                  Padding(
                    padding:  EdgeInsets.fromLTRB(0,0, 0, 0),
                    child: StreamBuilder(
                        stream: FirebaseDatabase.instance
                            .reference()
                            .child("Admin").child("AppVersion").child("ShopCategory")
                            .onValue
                        ,
                        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                          if (snapshot.hasData) {

                            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

                            if(map!=null) {
                              // shops.clear();
                              shopcat.clear();
                              shopcat2.clear();
                              shopcat3.clear();
                              catlistcount=0;
                              int x=0;

                              map.forEach((dynamic, v)  {

                               // print(v["CategoryName"]);

                                if( v["group"]==1) {
                                  catlistcount++;
                                 shopcat.add(new ShopCategory(
                                   v["key"],
                                   v["CategoryImage"],
                                   v["CategoryName"],
                                   v["TagLine"],
                                   v["group"],
                                   v["index"],
                                 ));

                               }

                                if( v["group"]==2) {
                                      shopcat2.add(new ShopCategory(
                                        v["key"],
                                        v["CategoryImage"],
                                        v["CategoryName"],
                                        v["TagLine"],
                                        v["group"],
                                        v["index"],

                                      ));

                                    }
                                if( v["group"]==3) {

                                  shopcat3.add(new ShopCategory(
                                    v["key"],
                                    v["CategoryImage"],
                                    v["CategoryName"],
                                    v["TagLine"],
                                    v["group"],
                                    v["index"],

                                  ));



                                }


                                x++;
                              });
                              shopcat.sort((a, b) => a.index.compareTo(b.index));
                              shopcat2.sort((a, b) => a.index.compareTo(b.index));
                              shopcat3.sort((a, b) => a.index.compareTo(b.index));

                              print("length "+shopcat.length.toString());
                              print("length "+shopcat2.length.toString());

                              print("length "+shopcat3.length.toString());

                              print("length $catlistcount ");



                            }



                            return  ListView.builder(


                              itemCount: (catlistcount)+1,
                              itemBuilder: (BuildContext context, int index) {
                                return
                                  index==0?
                                  Column(
                                    children: [
                                      bannerloaded?
                                      Column(
                                          children: [


                                            CarouselSlider(
                                              items: imageSliders,
                                              options: CarouselOptions(
                                                  autoPlay: true,
                                                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                                                  enlargeCenterPage: true,
                                                  aspectRatio: 2.0,
                                                  onPageChanged: (index, reason) {
                                                    setState(() {
                                                      _current = index;
                                                    });
                                                  }
                                              ),
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: imgList.map((url) {
                                                int index = imgList.indexOf(url);
                                                return Container(
                                                  width: 8.0,
                                                  height: 8.0,
                                                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: _current == index
                                                        ? Color.fromRGBO(0, 0, 0, 0.9)
                                                        : Color.fromRGBO(0, 0, 0, 0.4),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ]
                                      ):
                                      SizedBox(height: 5,),


                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            color: Colors.white,

                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.75),
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

                                                    Row(
                                                      children: [
                                                        Icon(Icons.location_on),
                                                        SizedBox(width: 10,),

                                                        Container(
                                                          width: screenWidth(context)/2,
                                                          child: Text(

                                                            PickedAddress,
                                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,color: Colors.black),
                                                            textAlign: TextAlign.left,
                                                            maxLines: 4,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){

                                                        Dialog errorDialog = Dialog(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                                                          child: Container(
                                                            height: 180.0,
                                                            width: screenWidth(context),

                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: <Widget>[
                                                                SizedBox(height: 20,),

                                                                Padding(
                                                                  padding:  EdgeInsets.all(1.0),
                                                                  child: Text('Change Location', style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.w500),),
                                                                ),
                                                                // SizedBox(height: 20,),


                                                                Padding(
                                                                  padding:  EdgeInsets.all(20.0),
                                                                  child: Text('Changing your location will clear your Cart are you sure you want to change your Location ?', style: TextStyle(color: Colors.black,fontSize: 14),),
                                                                ),



                                                                SizedBox(height: 10,),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: [
                                                                    FlatButton(

                                                                        onPressed: (){
                                                                          Navigator.of(context).pop();

                                                                        },
                                                                        child: Text('Dismiss', style: TextStyle(color: Colors.grey, fontSize: 14.0),)),

                                                                    FlatButton(onPressed: (){

                                                                      FirebaseDatabase database = new FirebaseDatabase();

                                                                      DatabaseReference del = database
                                                                          .reference();


                                                                      del =
                                                                          database.reference()
                                                                              .child("Cart")
                                                                              .child(
                                                                              DataStream
                                                                                  .UserId);
                                                                      del.remove().then((
                                                                          value) {
                                                                        carts.clear();
                                                                        Navigator.of(context)
                                                                            .pop();

                                                                        addLocation().then((value) {setupBanner();});

                                                                        setState(() {

                                                                        });
                                                                      });


                                                                    },
                                                                        child: Text('Change Location', style: TextStyle(color: Colors.redAccent, fontSize: 14.0),)),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );


                                                        if(carts.length>0) {
                                                          showDialog(context: context,
                                                              builder: (
                                                                  BuildContext context) => errorDialog);
                                                        }else{
                                                          addLocation().then((value) {setupBanner();});

                                                        }


                                                        setState(() {

                                                        });
                                                      },


                                                      child: Text(
                                                        'Change',
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
                                      ),


//
//
//                       GestureDetector(
//                         onTap: (){
//                           DataStream.ShopCatagory="Supermarkets";
//                           Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),).then((value) {setupCart();});
//
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.all(5),
//                           child: Container(
//                             height: 170,
//                             decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                   color:  Colors.grey.withOpacity(0.9),
//                                   spreadRadius: 2,
//                                   blurRadius: 3,
//                                 ),
//                               ],
//                               shape: BoxShape.rectangle,
//                               borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                               image: DecorationImage(
//                                 image: AssetImage("assets/imgs/super_market.jpg"),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             child:  Padding(
//                               padding: EdgeInsets.all(0),
//                               child: Container(
//
//                                 height: 100,
//                                 decoration: BoxDecoration(
//
//                                   shape: BoxShape.rectangle,
//                                   borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                   gradient: new LinearGradient(
//                                       colors: [
//                                         Colors.black.withOpacity(0.75)
// ,
//                                             const Color(0x10000000),
//
//                                       ],
//                                       begin: const FractionalOffset(0.0, 0.0),
//                                       end: const FractionalOffset(0.0, 1.0),
//                                       stops: [0.0, 1.0],
//                                       tileMode: TileMode.clamp),
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.all(12),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Supermarkets',
//                                         style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
//                                       ),
//                                       Text(
//                                         'Groceries made easy',
//                                         style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300,color: Colors.white),
//                                       ),
//
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ), /* add child content here */
//                           ),
//                         ),
//                       ),
//
//                         Row(
//                           children: [
//
//
//                             GestureDetector(
//                               onTap: (){
//                                 DataStream.ShopCatagory="Bakery";
//
//                                 Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),).then((value) {setupCart();});
//
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.all(5),
//                                 child: Container(
//                                   height: 170,
//                                   width: ((screenWidth(context)/2))-15,
//
//                                   decoration: BoxDecoration(
//                                     boxShadow: [
//                                   BoxShadow(
//                                     color:  Colors.grey.withOpacity(0.9),
//                                     spreadRadius: 2,
//                                     blurRadius: 3,
//                                   ),
//                                 ],
//                                     shape: BoxShape.rectangle,
//                                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                     image: DecorationImage(
//                                       image: AssetImage("assets/imgs/bk.jpg"),
//
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   child:  Padding(
//                                     padding: EdgeInsets.all(0),
//                                     child: Container(
//
//                                       height: 100,
//                                       decoration: BoxDecoration(
//
//                                         shape: BoxShape.rectangle,
//                                         borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                         gradient: new LinearGradient(
//                                             colors: [
//                                               Colors.black.withOpacity(0.75),
//                                               const Color(0x10000000),
//                                             ],
//                                             begin: const FractionalOffset(0.0, 0.0),
//                                             end: const FractionalOffset(0.0, 1.0),
//                                             stops: [0.0, 1.0],
//                                             tileMode: TileMode.clamp),
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsets.all(12),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           children: [
//
//                                             Text(
//                                               'Bakery',
//                                               style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
//                                             ),
//                                             Text(
//                                               'Freshly Baked',
//                                               style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300,color: Colors.white),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ), /* add child content here */
//                                 ),
//                               ),
//                             ),
//
//
//
//                             GestureDetector(
//                               onTap: (){
//                                 DataStream.ShopCatagory="Butchery & BBQ";
//                                 Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),).then((value) {setupCart();});
//
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.all(5),
//                                 child: Container(
//                                   height: 170,
//                                   width: ((screenWidth(context)/2))-5,
//
//
//                                   decoration: BoxDecoration(
//                                     boxShadow: [
//                                   BoxShadow(
//                                     color:  Colors.grey.withOpacity(0.9),
//                                     spreadRadius: 2,
//                                     blurRadius: 3,
//                                   ),
//                                 ],
//                                     shape: BoxShape.rectangle,
//                                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                     image: DecorationImage(
//                                       image: AssetImage("assets/imgs/bbq.jpg"),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   child:  Padding(
//                                     padding: EdgeInsets.all(0),
//                                     child: Container(
//
//                                       height: 100,
//                                       decoration: BoxDecoration(
//
//                                         shape: BoxShape.rectangle,
//                                         borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                         gradient: new LinearGradient(
//                                             colors: [
//                                               Colors.black.withOpacity(0.75)
// ,
//                                               const Color(0x10000000),
//                                             ],
//                                             begin: const FractionalOffset(0.0, 0.0),
//                                             end: const FractionalOffset(0.0, 1.0),
//                                             stops: [0.0, 1.0],
//                                             tileMode: TileMode.clamp),
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsets.all(12),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Butchery & BBQ',
//                                               style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
//                                             ),
//                                             Text(
//                                               'The place to meat',
//                                               style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300,color: Colors.white),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ), /* add child content here */
//                                 ),
//                               ),
//                             ),
//
//                           ],
//                         ),
//                         GestureDetector(
//                           onTap: (){
//                             DataStream.ShopCatagory="Fruits & Vegetables";
//                             Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),).then((value) {setupCart();});
//
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.all(5),
//                             child: Container(
//                               height: 170,
//                               decoration: BoxDecoration(
//                                   boxShadow: [
//                                   BoxShadow(
//                                     color:  Colors.grey.withOpacity(0.9),
//                                     spreadRadius: 2,
//                                     blurRadius: 3,
//                                   ),
//                                 ],
//                                 shape: BoxShape.rectangle,
//                                 borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                 image: DecorationImage(
//                                   image: AssetImage("assets/imgs/grocery_store.jpg"),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               child:  Padding(
//                                 padding: EdgeInsets.all(0),
//                                 child: Container(
//
//                                   height: 100,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.rectangle,
//                                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                     gradient: new LinearGradient(
//                                         colors: [
//                                           Colors.black.withOpacity(0.75)
// ,
//                                               const Color(0x10000000),
//                                         ],
//                                         begin: const FractionalOffset(0.0, 0.0),
//                                         end: const FractionalOffset(0.0, 1.0),
//                                         stops: [0.0, 1.0],
//                                         tileMode: TileMode.clamp),
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsets.all(12),
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Fruits & Vegetables',
//                                           style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
//                                         ),
//                                         Text(
//                                           'Fresher and better',
//                                           style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300,color: Colors.white),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ), /* add child content here */
//                             ),
//                           ),
//                         ),
//
//                         Row(
//
//                           children: [
//                             GestureDetector(
//                               onTap: (){
//                                 DataStream.ShopCatagory="Tandoor";
//                                 Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),).then((value) {setupCart();});
//
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.all(5),
//                                 child: Container(
//                                   height: 170,
//                                   width: ((screenWidth(context)/2))-15,
//
//
//
//                                   decoration: BoxDecoration(
//                                     boxShadow: [
//                                   BoxShadow(
//                                     color:  Colors.grey.withOpacity(0.9),
//                                     spreadRadius: 2,
//                                     blurRadius: 3,
//                                   ),
//                                 ],
//                                     shape: BoxShape.rectangle,
//                                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                     image: DecorationImage(
//                                       image: AssetImage("assets/imgs/naan.jpg"),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   child:  Padding(
//                                     padding: EdgeInsets.all(0),
//                                     child: Container(
//
//                                       height: 100,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.rectangle,
//                                         borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                         gradient: new LinearGradient(
//                                             colors: [
//                                               Colors.black.withOpacity(0.75)
// ,
//                                               const Color(0x10000000),
//                                             ],
//                                             begin: const FractionalOffset(0.0, 0.0),
//                                             end: const FractionalOffset(0.0, 1.0),
//                                             stops: [0.0, 1.0],
//                                             tileMode: TileMode.clamp),
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsets.all(12),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Tandoor',
//                                               style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
//                                             ),
//                                             Text(
//                                               'Fresh Naan',
//                                               style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300,color: Colors.white),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ), /* add child content here */
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: (){
//                                 DataStream.ShopCatagory="Dairy";
//                                 Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),).then((value) {setupCart();});
//
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.all(5),
//                                 child: Container(
//                                   height: 170,
//                                   width: ((screenWidth(context)/2))-5,
//
//
//                                   decoration: BoxDecoration(
//                                     boxShadow: [
//                                   BoxShadow(
//                                     color:  Colors.grey.withOpacity(0.9),
//                                     spreadRadius: 2,
//                                     blurRadius: 3,
//                                   ),
//                                 ],
//                                     shape: BoxShape.rectangle,
//                                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                     image: DecorationImage(
//                                       image: AssetImage("assets/imgs/dairy.jpg"),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   child:  Padding(
//                                     padding: EdgeInsets.all(0),
//                                     child: Container(
//
//                                       height: 100,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.rectangle,
//                                         borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                                         gradient: new LinearGradient(
//                                             colors: [
//                                               Colors.black.withOpacity(0.75)
// ,
//                                               const Color(0x10000000),
//                                             ],
//                                             begin: const FractionalOffset(0.0, 0.0),
//                                             end: const FractionalOffset(0.0, 1.0),
//                                             stops: [0.0, 1.0],
//                                             tileMode: TileMode.clamp),
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsets.all(12),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Dairy',
//                                               style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
//                                             ),
//                                             Text(
//                                               'Fresh Dairy Products',
//                                               style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300,color: Colors.white),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ), /* add child content here */
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

                                    ],
                                  ):

                                      Column(
                                        children: [
                                           Container(
                                             width:screenHeight(context),
                                             child: GestureDetector(

                                                onTap: (){
                                                  DataStream.ShopCatagory=shopcat[index-1].CategoryName;
                                                  Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),).then((value) {setupCart();});

                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Container(
                                                    height: 170,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:  Colors.grey.withOpacity(0.9),
                                                          spreadRadius: 2,
                                                          blurRadius: 3,
                                                        ),
                                                      ],
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                      image: DecorationImage(
                                                        image: NetworkImage(shopcat[index-1].CategoryImage),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child:  Padding(
                                                      padding: EdgeInsets.all(0),
                                                      child: Container(

                                                        height: 100,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.rectangle,
                                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                          gradient: new LinearGradient(
                                                              colors: [
                                                                Colors.black.withOpacity(0.75)
                                                                ,
                                                                const Color(0x10000000),
                                                              ],
                                                              begin: const FractionalOffset(0.0, 0.0),
                                                              end: const FractionalOffset(0.0, 1.0),
                                                              stops: [0.0, 1.0],
                                                              tileMode: TileMode.clamp),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(12),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                shopcat[index-1].CategoryName,
                                                                style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
                                                              ),
                                                              Text(
                                                                shopcat[index-1].TagLine,
                                                                style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300,color: Colors.white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ), /* add child content here */
                                                  ),
                                                ),
                                              ),
                                           ),


                                           Row(

                                            children: [

                                              index<=shopcat2.length?
                                              GestureDetector(
                                                onTap: (){
                                                  DataStream.ShopCatagory=shopcat2[index-1].CategoryName;

                                                  Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),).then((value) {setupCart();});

                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Container(
                                                    height: 170,
                                                    width: ((screenWidth(context)/2))-15,

                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:  Colors.grey.withOpacity(0.9),
                                                          spreadRadius: 2,
                                                          blurRadius: 3,
                                                        ),
                                                      ],
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                      image: DecorationImage(
                                                        image: NetworkImage(shopcat2[index-1].CategoryImage),

                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child:  Padding(
                                                      padding: EdgeInsets.all(0),
                                                      child: Container(

                                                        height: 100,
                                                        decoration: BoxDecoration(

                                                          shape: BoxShape.rectangle,
                                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                          gradient: new LinearGradient(
                                                              colors: [
                                                                Colors.black.withOpacity(0.75),
                                                                const Color(0x10000000),
                                                              ],
                                                              begin: const FractionalOffset(0.0, 0.0),
                                                              end: const FractionalOffset(0.0, 1.0),
                                                              stops: [0.0, 1.0],
                                                              tileMode: TileMode.clamp),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(12),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [

                                                              Text(
                                                                shopcat2[index-1].CategoryName,
                                                                style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
                                                              ),
                                                              Text(
                                                                shopcat2[index-1].TagLine,
                                                                style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300,color: Colors.white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ), /* add child content here */
                                                  ),
                                                ),
                                              ):SizedBox(),


                                              index<=shopcat3.length?
                                              GestureDetector(
                                                onTap: (){
                                                  DataStream.ShopCatagory=shopcat3[index-1].CategoryName;
                                                  Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),).then((value) {setupCart();});

                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Container(
                                                    height: 170,
                                                    width: ((screenWidth(context)/2))-5,


                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:  Colors.grey.withOpacity(0.9),
                                                          spreadRadius: 2,
                                                          blurRadius: 3,
                                                        ),
                                                      ],
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                      image: DecorationImage(
                                                        image: NetworkImage(shopcat3[index-1].CategoryImage),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    child:  Padding(
                                                      padding: EdgeInsets.all(0),
                                                      child: Container(

                                                        height: 100,
                                                        decoration: BoxDecoration(

                                                          shape: BoxShape.rectangle,
                                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                          gradient: new LinearGradient(
                                                              colors: [
                                                                Colors.black.withOpacity(0.75)
                                                                ,
                                                                const Color(0x10000000),
                                                              ],
                                                              begin: const FractionalOffset(0.0, 0.0),
                                                              end: const FractionalOffset(0.0, 1.0),
                                                              stops: [0.0, 1.0],
                                                              tileMode: TileMode.clamp),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(12),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                shopcat3[index-1].CategoryName,
                                                                style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
                                                              ),
                                                              Text(
                                                                shopcat3[index-1].TagLine,
                                                                style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300,color: Colors.white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ), /* add child content here */
                                                  ),
                                                ),
                                              ):SizedBox(),



                                            ],
                                          )

                                        ],
                                      );

                              },
                            );






                          } else {
                            return Center(child: Column(
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
                                Text("Loading", style: TextStyle(fontSize: 12,color: Colors.white),),
                              ],
                            ));
                          }
                        }),
                  ),
                ],
              ),

            ),
          ],
        ),
       ),
     );

    Widget OngoingOrders  =Center(
      child:
      user!=null?
      StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child("User Orders").child(DataStream.UserId).child("Active")
              .onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            Map<dynamic, dynamic> map ;
            try {
              map = snapshot.data.snapshot.value;
            }catch(e){

            }
            if (map!=null) {

              orders.clear();
              map.forEach((dynamic, v) {

                if(v["status"]=="ready"||v["status"]=="pending") {

                  orders.add(new Order(
                      v["key"],
                      v['no_of_items'],
                      v['bill'],
                      v["location"],
                      v["orderDate"],
                      v["address"],
                      v["orderTime"],
                      v["phonenumber"],
                      v["orderID"],
                      v["status"],
                      v["userID"]));
                }

              }
              );

              orders.sort((a, b){

                final birthday =DateTime.parse(a.orderDate+" "+a.orderTime+":00");
                final date2 =DateTime.parse(b.orderDate+" "+b.orderTime+":00");
                final difference = date2.difference(birthday).inMinutes;
                return difference;
              });

              //   orders= orders.sort()

              return ListView.builder(


                itemCount: orders.length,
                padding: EdgeInsets.all(2.0),
                itemBuilder: (BuildContext context, int index) {
                  return  Padding(
                    padding: const EdgeInsets.all(12.0),

                    child: GestureDetector(
                      onTap: (){
                        //OrderItemsScreen
                        Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => OrderItemsScreen("Active",orders[index]),),);

                      },
                      child: Container(
                         width: screenWidth(context)-60,
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
                              color: Colors.grey.withOpacity(0.75),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),

                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                '# ${orders[index].orderID}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.black),
                              ),
                              SizedBox(height: 10,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Items ',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black),
                                  ),
                                  Container(
                                    width: screenWidth(context)/1.9,
                                    child: Text(
                                      '${orders[index].no_of_items}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 5,),

                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order Date ',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black),
                                  ),
                                  Container(
                                    width: screenWidth(context)/2,
                                    child: Text(
                                      '${orders[index].orderDate}   ${orders[index].orderTime}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Address ',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black),
                                  ),
                                  Container(
                                    width: screenWidth(context)/1.7,
                                    child: Text(
                                      '${orders[index].address}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                    ),
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
                                    'Rs. ${orders[index].bill}',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              orders[index].status=="pending"?
                              Column(
                                children: [

                                  Text(
                                    'Your order is being prepared',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.yellow[800]),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    height: 40,
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
                                          color: Colors.redAccent[100],
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
                                      color: Colors.redAccent,
                                      onPressed: (){






                                        Dialog errorDialog = Dialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                                          child: Container(
                                            height: 200.0,
                                            width: screenWidth(context),

                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(height: 20,),

                                                Padding(
                                                  padding:  EdgeInsets.all(1.0),
                                                  child: Text('Cancel Order  #${orders[index].orderID}', style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.w500),),
                                                ),
                                                SizedBox(height: 20,),


                                                Padding(
                                                  padding:  EdgeInsets.all(1.0),
                                                  child: Text('Are you sure you want to cancel this order', style: TextStyle(color: Colors.black,fontSize: 14),),
                                                ),



                                                 SizedBox(height: 40,),
                                                 Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    FlatButton(

                                                        onPressed: (){
                                                        Navigator.of(context).pop();

                                                        },
                                                        child: Text('Dismiss', style: TextStyle(color: Colors.grey, fontSize: 14.0),)),

                                                    FlatButton(

                                                        onPressed: (){


                                                          showLoadingDialogue("Cancelling Order");



                                                      FirebaseDatabase database = new FirebaseDatabase();
                                                      DatabaseReference _userRef = database.reference()
                                                          .child("User Orders").child(DataStream.UserId).child("Active").child(orders[index].orderID);
                                                      _userRef.update(<String, String>{
                                                        'status': 'cancelled',
                                                      });



                                                      DatabaseReference _adminRef = database.reference()
                                                          .child("Admin").child("Orders").child("Active").child(orders[index].orderID);
                                                      _adminRef.update(<String, String>{
                                                        'status': 'cancelled',
                                                      });


                                                      DatabaseReference  _sref = database.reference().child("User Orders").child(DataStream.UserId).child("Active").child(orders[index].orderID).child("items");
                                                      _sref.onChildAdded.listen((event) {

                                                            DatabaseReference _shopRef = database.reference()
                                                                .child("Shops").child(Cart.fromSnapshot(event.snapshot).shopcatagory)
                                                                .child(Cart.fromSnapshot(event.snapshot).shopid)
                                                                .child("Orders").child(
                                                                "Active")
                                                                .child(orders[index].orderID);

                                                            _shopRef.update(<String, String>{
                                                              'status': 'cancelled',
                                                            }).then((value) {
                                                              hideLoadingDialogue();
                                                            });

                                                          });







                                                    },
                                                        child: Text('Cancel Order', style: TextStyle(color: Colors.redAccent, fontSize: 14.0),)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );

                                        showDialog(context: context, builder: (BuildContext context) => errorDialog);


                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('Cancel Order',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ):
                              SizedBox(height: 1,),

                              orders[index].status=="ready"?

                              Text(
                                'Your order ready and is on the way',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.green),
                              ):SizedBox(height: 1,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Text("No Orders");
            }
          }):
      SizedBox(
        width:200,
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
    );

     Widget HistoryOrders  =Center(
      child:
      user!=null?

      StreamBuilder(
          stream: FirebaseDatabase.instance
              .reference()
              .child("User Orders").child(DataStream.UserId).child("Active")
            //  .limitToFirst(3)
              .onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            Map<dynamic, dynamic> map ;
            try {
              map = snapshot.data.snapshot.value;
            }catch(e){

            }
            if (map!=null) {

              orders.clear();
              map.forEach((dynamic, v) {

                if(v["status"]=="completed"||v["status"]=="cancelled") {
                  orders.add(new Order(
                      v["key"],
                      v['no_of_items'],
                      v['bill'],
                      v["location"],
                      v["orderDate"],
                      v["address"],
                      v["orderTime"],
                      v["phonenumber"],
                      v["orderID"],
                      v["status"],
                      v["userID"]));
                }
              }
              );

              orders.sort((a, b){

                final birthday =DateTime.parse(a.orderDate+" "+a.orderTime+":00");
                final date2 =DateTime.parse(b.orderDate+" "+b.orderTime+":00");
                final difference = date2.difference(birthday).inMinutes;
                return difference;
              });

              //   orders= orders.sort()

              return ListView.builder(


                itemCount: orders.length,
                padding: EdgeInsets.all(2.0),
                itemBuilder: (BuildContext context, int index) {
                  return

                  Padding(
                    padding: const EdgeInsets.all(12.0),

                    child: GestureDetector(
                      onTap: (){
                        //OrderItemsScreen
                        Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => OrderItemsScreen("Active",orders[index]),),);

                      },
                      child: Container(
                        width: screenWidth(context)-60,
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
                              color: Colors.grey.withOpacity(0.75),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),

                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                '# ${orders[index].orderID}',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400,color: Colors.black),
                              ),
                              SizedBox(height: 10,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Items ',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                  ),
                                  Container(
                                    width: screenWidth(context)/1.9,
                                    child: Text(
                                      '${orders[index].no_of_items}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 5,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order Date ',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                  ),
                                  Container(
                                    width: screenWidth(context)/2,
                                    child: Text(
                                      '${orders[index].orderDate}   ${orders[index].orderTime}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Address ',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                  ),
                                  Container(
                                    width: screenWidth(context)/1.7,
                                    child: Text(
                                      '${orders[index].address}',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                    ),
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
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Rs. ${orders[index].bill}',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),

                              orders[index].status=="cancelled"?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 30,),
                                  Text(
                                    'Cancelled',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Colors.redAccent),
                                  ),

                                  Icon(Icons.clear,color: Colors.redAccent,size: 30,)
                                ],
                              ):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 30,),
                                  Text(
                                    'Completed',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Colors.green),
                                  ),

                                  Icon(Icons.done,color: Colors.green,size: 30,)
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  );

                },
              );
            } else {
              return Text("No Orders");
            }
          }):
       SizedBox(
       width:200,
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
    );

    Widget OrdersScreen  =Center(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Orders'),
            bottom: TabBar(
              tabs: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Active')),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('History')),
              ],
            ),
          ),
          body:

          TabBarView(
            children: [
              OngoingOrders,
              HistoryOrders,
            ],
          )
        ),
      ),
    );



     Widget ProfileScreen  =Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),

        ),
        body:
        user!=null?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [




               Column(
                  children: [
                    appuser==null?
                    SizedBox(height: 10,):


                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
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
                              color: Colors.grey.withOpacity(0.75),
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
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.account_box),
                                      SizedBox(width: 5,),

                                      Text(
                                        'Contact Details ',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black),
                                      ),
                                    ],
                                  ),
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
                                      profileedit?'':'Edit',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.green),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 20,),
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

                                    SizedBox(height: 20,),


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


                                            }).then((value) {

                                              getUserDetails();

                                              if(profileedit) {
                                                profileedit = false;
                                              }else{
                                                profileedit = true;

                                              }
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
                    Container(
                      height: 40,
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
                            color: Colors.redAccent[100],
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
                        color: Colors.redAccent,
                        onPressed: (){


                          FirebaseAuth.instance.currentUser().then((firebaseUser) async {
                            if(firebaseUser != null){
                              await FirebaseAuth.instance.signOut();

                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));

                            }

                          });

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                          children: [

                            Text('Logout',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 18),),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),



               Column(
                 children: [

                   // Padding(
                   //   padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                   //   child: Text('Terms and Conditions',
                   //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black,),),
                   // ),

                   SizedBox(height: 20,),
                   GestureDetector(
                     onTap: (){
                       _launchCaller();

                     },
                     child: Padding(
                       padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                       child: Text('Contact Us',
                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.blue[500], decoration: TextDecoration.underline,
                         ),),
                     ),
                   ),
                   GestureDetector(
                     onTap: (){
                       //https://doorsteppolicy.web.app/

                       UrlLauncher.launch('https://doorsteppolicy.web.app');

                     },

                     child: Padding(
                       padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                       child: Text('Privacy Policy',
                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.blue[500], decoration: TextDecoration.underline,
                         ),
                       ),
                     ),
                   ),
                   // GestureDetector(
                   //   onTap: (){
                   //     //https://doorsteppolicy.web.app/
                   //
                   //     UrlLauncher.launch('https://doorsteppolicy.web.app');
                   //   },
                   //   child: Padding(
                   //     padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                   //     child: Text('Terms & Conditions',
                   //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.blue[500], decoration: TextDecoration.underline,
                   //       ),
                   //     ),
                   //   ),
                   // ),
                 //  SizedBox(height: 5,),


                   SizedBox(height: 10,),
                 ],
               )
            ],
          ),
        ):
        Center(
          child: SizedBox(
            width:200,
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


    );

    return Scaffold(


      body:Stack(
        children: [
          Visibility(
              visible: _selectedIndex==0?true:false,
              child: HomeScreen),
          Visibility(
              visible: _selectedIndex==1?true:false,
              child: OrdersScreen),
          Visibility(
              visible: _selectedIndex==2?true:false,
              child: ProfileScreen)
        ],
      ),
//      _selectedIndex==0? HomeScreen:
//      _selectedIndex==1?OrdersScreen:ProfileScreen,

      bottomNavigationBar:

      MotionTabBar(
        tabOneName: "Market",
        tabTwoName: "Orders",
        tabThreeName: "Profile",
        tabOneIcon: Icons.shopping_basket,
        tabTwoIcon: Icons.airport_shuttle,
        tabThreeIcon: Icons.account_circle,
        tabIconColor: Colors.grey,
        tabSelectedColor: Colors.green,
        textStyle: TextStyle(color: Colors.green),
        onTabItemSelected: onItemTapped,
      )
      // Container(
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(10),
      //         topRight: Radius.circular(10),
      //         bottomLeft: Radius.circular(10),
      //         bottomRight: Radius.circular(10)
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.withOpacity(0.75),
      //         spreadRadius: 5,
      //         blurRadius: 7,
      //         offset: Offset(0, 3), // changes position of shadow
      //       ),
      //     ],
      //   ),
      //   child: BottomNavigationBar(
      //
      //     items: const <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.shopping_basket),
      //         title: Text('Market'),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.airport_shuttle),
      //         title: Text('Orders'),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.account_circle),
      //         title: Text('Profile'),
      //       ),
      //     ],
      //     currentIndex: _selectedIndex,
      //     selectedItemColor: Colors.amber[800],
      //     onTap: onItemTapped,
      //   ),
      // ),
    );
  }

  String PickedAddress="Current Location";
  LatLng PickedLocation;

  Dialog errorDialog;
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

    //  Navigator.of(context).pop();

      //   errorDialog.p

      PickedAddress=result.address;
      PickedLocation=result.latLng;

      DataStream.userlocation=PickedLocation;
      DataStream.userAddress=PickedAddress;

      print(result.address);

      setState(() {

      });
    }
  }
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  _launchCaller() async {
    print("call");
    UrlLauncher.launch('tel://0512714414');
   }
}

