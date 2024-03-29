import 'dart:io';

 import 'package:Doorstep/models/Cart.dart';
import 'package:Doorstep/models/Product.dart';
import 'package:Doorstep/models/Shops.dart';
import 'package:Doorstep/screens/auth/sign-in.dart';
import 'package:Doorstep/screens/first-screen.dart';
import 'package:Doorstep/styles/CustomDialogBox.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:Doorstep/utilts/UI/info_dialogue.dart';
import 'package:cache_image/cache_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:Doorstep/styles/styles.dart';
 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:Doorstep/screens/home/single_product.dart';

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

    carts = new List();


    getodercount();


  }
  void getodercount(){
    final locationDbRef = FirebaseDatabase.instance.reference().child("User Orders").child(DataStream.UserId).child("Order Count");

    locationDbRef.once().then((value) async {
      if(value.value!=null){

      print(value.value["no_of_orders"]);
      order_count = value.value['no_of_orders'];

    }

      setuplist();

    }
    );
  }
  int order_count=0;
  List<Cart> carts;
  String userid;
   DatabaseReference volunteerRef;

   bool hasPharmacy=false;
  Future<void> setuplist() async {

    hasPharmacy=false;
    carts.clear();
    FirebaseAuth.instance.currentUser().then((firebaseUser){
      if(firebaseUser == null)
      {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
      }
      else{

        try {
          userid = firebaseUser.uid;
          final FirebaseDatabase database = FirebaseDatabase.instance;
          volunteerRef =
              database.reference().child("Cart").child(firebaseUser.uid);
          volunteerRef.onChildAdded.listen(_onEntryAdded);
       //   volunteerRef.onChildChanged.listen(_onEntryChanged);
          volunteerRef.onChildRemoved.listen(_onEntryRemoved);
        }catch(e){

        }

       }
    });

  }
  int shopcount=0;
  String shopIDchk="";


  _onEntryChanged(Event event) {




    var old = carts.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });



    setState(() {
      carts[carts.indexOf(old)] = Cart.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {

    if(Cart.fromSnapshot(event.snapshot).shopid!=shopIDchk){
      shopIDchk=Cart.fromSnapshot(event.snapshot).shopid;
      shopcount++;

    }

    setState(() {
      carts.add(Cart.fromSnapshot(event.snapshot));
      if(Cart.fromSnapshot(event.snapshot).shopcatagory=="Pharmacy"){
        hasPharmacy=true;
        caltotal();

      }

    });
  }

  _onEntryRemoved(Event event) {
    carts.remove(Cart.fromSnapshot(event.snapshot));

    setState(() {
    });
  }


  int calSubtotal(){
    int Subtotal=0;

    for(int i=0;i<=carts.length-1;i++){
      Subtotal=Subtotal+(carts[i].no_of_items*carts[i].cardprice);
    }

        return Subtotal ;
  }

  int caltotal(){
    int total=0;

    for(int i=0;i<=carts.length-1;i++){
      total=total+(carts[i].no_of_items*carts[i].cardprice);
    }

    if(hasPharmacy){
    return (total + DataStream.DeliverChargesPharmacy)-DataStream.Discount;
    }else {
      return (total + DataStream.DeliverCharges) - DataStream.Discount;
    }
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


                    if(carts[index].no_of_items==0){
                      final FirebaseDatabase _databaseCustom = FirebaseDatabase.instance;
                      _databaseCustom.reference().child("Cart").child(DataStream.UserId).child( carts[index].cardid +carts[index].shopid).remove();
                    }


                 //   Subtotal=Subtotal+carts[index].cardprice;
                    return GestureDetector(
                      onTap: (){


                     //   Product product = new Product(carts[index].key, carts[index].cardid, carts[index].cardname, carts[index].cardimage, carts[index].cardprice, carts[index].carddiscription, carts[index].unit, "", "");
                   //     Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => SingleProduct(product,productsItemcount[index]),),);

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
                                  setState(() {
                                    shopcount=0;
                                    shopIDchk="";
                                    caltotal();
                                    setuplist();

                                  });
                                 });


                             //   ToastUtils.showCustomToast(context, "Removed", true);
                            // setuplist();
                              },
                              child: Padding(
                                  padding:EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Icon(Icons.clear,color: Colors.redAccent,size: 35,)),
                            ),

                            Container(
                              height: 80,
                              width: 80,

                              decoration: BoxDecoration(
                                color: Colors.grey[300],
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
                               //   image: CacheImage(carts[index].cardimage),
                                  image: NetworkImage(carts[index].cardimage.length>10?carts[index].cardimage:"https://firebasestorage.googleapis.com/v0/b/doorstep-fdb26.appspot.com/o/images%2Fimg_missing.png?alt=media&token=60b4508f-9d43-41db-a85d-5e16240a4466"),

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

                                  Container(
                                    width: screenWidth(context)/2,

                                    child: Text(
                                      '${carts[index].cardname}',
                                      maxLines: 3,
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
                                    ),
                                  ),
                                  Text(
                                    'Rs. ${carts[index].cardprice} / ${carts[index].unit}',
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

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                       width: screenWidth(context)-40,

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
                      child: Wrap(
                        children: [
                          Padding(
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
                                      'Discount ',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                    ),
                                    Text(
                                      'Rs. ${DataStream.Discount}',
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
                                    // hasPharmacy?
                                    // Text(
                                    //   'Rs. ${calDeliveryCharges()}',
                                    //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                    // ):
                                    Text(
                                      'Rs. ${calDeliveryCharges()}',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5,),

                                shopcount>1?
                                GestureDetector(
                                  onTap:() {
                                    showDialog(context: context,
                                        builder: (BuildContext context) {
                                          return InfoDialog(
                                            title: "Delivery Charges",
                                            description: "Base Delivery Charges are Rs.${DataStream.DeliverCharges}, Delivery Charges for Pharmacies are Rs.${DataStream.DeliverChargesPharmacy} and Delivery Charges for each addition shop are Rs.${DataStream.delivery_charges_per_shop}",
                                            // orderId: "# " ,
                                            buttonText: "Ok",

                                          );
                                        }
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,

                                    children: [
                                      Icon(Icons.warning_amber_outlined,color: Colors.amber,size: 15,),
                                      SizedBox(width: 10,),
                                      Column(
                                        children: [
                                          //
                                          Container(
                                            width: screenWidth(context)-120,
                                            child: Text(
                                              'Multiple shops orders have additional delivery charges',
                                              maxLines: 2,
                                              textAlign: TextAlign.center,

                                              style: TextStyle(fontSize: 12,

                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black),
                                            ),
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ):SizedBox(),
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
                                SizedBox(height: 5,),

                                GestureDetector(
                                  onTap:(){
                                    showDialog(context: context,
                                        builder: (BuildContext context) {
                                          return InfoDialog(
                                            title: "Prices Might Change",
                                            description: "Prices of the products might Change. In case of any changed Prices team Doorstep will contact you before confirming the order. You will be provided with an Updated receipt upon receiving your order",
                                            // orderId: "# " ,
                                            buttonText: "Ok",

                                          );
                                        }
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.info,size: 18,
                                        color: Colors.grey[500],),
                                      SizedBox(width: 10,),

                                      Container(
                                        width: screenWidth(context) / 2,
                                        child: Text(

                                          "All prices are subject to change",
                                          style: TextStyle(fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black),
                                          textAlign: TextAlign.left,
                                          maxLines: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                          child: Text('Clear Cart', style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.w500),),
                                        ),
                                        // SizedBox(height: 20,),


                                        Padding(
                                          padding:  EdgeInsets.all(20.0),
                                          child: Text('Are yoy sure you want to clear your Cart ?', style: TextStyle(color: Colors.black,fontSize: 14),),
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

                                            FlatButton(
                                                onPressed: (){


                                              FirebaseDatabase database = new FirebaseDatabase();

                                              DatabaseReference del = database.reference();


                                              del = database.reference()
                                                  .child("Cart").child(DataStream.UserId);
                                              del.remove().then((value) {
                                                carts.clear();
                                                Navigator.of(context).pop();

                                                setState(() {

                                                });
                                              });




                                            },
                                                child: Text('Clear', style: TextStyle(color: Colors.redAccent, fontSize: 14.0),)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );



                                showDialog(context: context,
                                    builder: (
                                        BuildContext context) => errorDialog);












                              },
                              child: Icon(Icons.delete,color: Colors.white,size: 30,)
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          height: 60,
                          width: screenWidth(context)-110,
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
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => CheckOutScreen())).then((value) {setupCart();});


                            },
                            child: Text('Checkout',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 18),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),

        ],
      ):
      Center(child: Text("Empty")),
    );

  }

  int calDeliveryCharges(){

    int baseCharges=0;
    if(hasPharmacy){
      baseCharges=DataStream.DeliverChargesPharmacy;
    }else{
      baseCharges=DataStream.DeliverCharges;

    }

    for(int i=1;i<=shopcount-1;i++){
      baseCharges=baseCharges+DataStream.delivery_charges_per_shop;

    }

    return baseCharges;
  }

  void setupCart(){

   // orders = new List();
    carts = new List();

    DatabaseReference volunteerRef;

    final FirebaseDatabase database = FirebaseDatabase.instance;
    volunteerRef = database.reference().child("Cart").child(DataStream.UserId);
    volunteerRef.onChildAdded.listen(_onEntryAdded);
    volunteerRef.onChildChanged.listen(_onEntryChanged);

  }
}
