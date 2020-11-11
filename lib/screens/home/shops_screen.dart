import 'dart:io';
import 'dart:math';

 import 'package:Doorstep/models/Shops.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:cache_image/cache_image.dart';
 import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:Doorstep/styles/styles.dart';
 
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'package:progress_dialog/progress_dialog.dart';



import 'package:http/http.dart' as http;

import 'product_catalog.dart';
import 'home_screen.dart';

class ShopsScreen extends StatefulWidget {
  @override
  _ShopsScreenState createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {

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

  List<Shops> _todoList;
  final FirebaseDatabase _database = FirebaseDatabase.instance;



  Query _todoQuery;
  @override
    initState()   {
    super.initState();

    _todoList = new List();




    dd();

  }

  List<Shops> shops;
  Shops shop;
  DatabaseReference volunteerRef;
  Future<void> dd() async {


    shops = new List();
    final FirebaseDatabase database = FirebaseDatabase.instance;
    volunteerRef = database.reference().child("Shops").child(DataStream.ShopCatagory);
//    volunteerRef.onChildAdded.listen(_onEntryAdded);
//    volunteerRef.onChildChanged.listen(_onEntryChanged);


  }


//  _onEntryAdded(Event event) {
//    setState(() {
//      shops.add(Shops.fromSnapshot(event.snapshot));
//    });
//  }
//
//  _onEntryChanged(Event event) {
//    var old = shops.singleWhere((entry) {
//      return entry.key == event.snapshot.key;
//    });
//    setState(() {
//      shops[shops.indexOf(old)] = Shops.fromSnapshot(event.snapshot);
//    });
//  }

  bool checkTime(String open, String close){

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

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
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
        title:  Text(DataStream.ShopCatagory),
        automaticallyImplyLeading: false,
      ),

      body: Column(
        children: <Widget>[
          Flexible(
            child:
//            FirebaseAnimatedList(
//              query: volunteerRef,
//              itemBuilder: (BuildContext context, DataSnapshot snapshot,
//                  Animation<double> animation, int index) {
//
//
//
//              },
//            ),
//      shops = new List();
//        final FirebaseDatabase database = FirebaseDatabase.instance;
//        volunteerRef = database.reference().child("Shops").child(DataStream.ShopCatagory);

            StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child("shopuser")
                    .onValue
                ,
                builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasData) {
                    Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

                     if(map!=null) {
                      shops.clear();

                      map.forEach((dynamic, v)  {

                        //  Shops(this.key,this.shopid,this.shopcategory,this.shopdiscription,this.shopimage,this.shopname,this.location);

                        double distanceInMeters = calculateDistance(DataStream.userlocation.latitude,DataStream.userlocation.longitude,double.parse(v["location"].toString().split(",")[0]),double.parse(v["location"].toString().split(",")[1]));

                    //    print(distanceInMeters.toString()+"-"+v["shopname"]);


                        if(distanceInMeters< DataStream.OrderRadius){
                         // print(distanceInMeters);

                          if(DataStream.ShopCatagory== v["shopcategory"]) {
                            shops.add(new Shops(
                                v["key"],
                                v["shopid"],
                                v["shopcategory"],
                                v["shopdiscription"],
                                v["shopimage"],
                                v["shopname"],
                                v["location"],
                                v["openTime"],
                                v["closeTime"],
                                v["ShopStatus"]));
                          }
                        }

                      }
                      );
                    }


                    return ListView.builder(


                      itemCount: shops.length,
                      padding: EdgeInsets.all(2.0),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: (){

                            if(shops[index].ShopStatus.contains("Closed")||!checkTime(shops[index].openTime,shops[index].closeTime)){

                               ToastUtils.showCustomToast(context, "Shop Closed", null);


                            }else {
                              DataStream.ShopName = shops[index].shopname;
                              DataStream.ShopId = shops[index].shopid;
                              DataStream.ShopCatagory =
                                  shops[index].shopcategory;
                              Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProductCatalog(
                                        shops[index], shops[index].shopid),),);
                            }


                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              height: 200,
                              width: double.infinity,

                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                image: DecorationImage(
                                  image: CacheImage(shops[index].shopimage),
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
                                          Colors.black,
                                          const Color(0x10000000),
                                        ],
                                        begin: const FractionalOffset(0.0, 0.0),
                                        end: const FractionalOffset(0.0, 1.0),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp),

                                  ),

                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          shops[index].shopname,
                                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500,color: Colors.white),
                                        ),
                                        Text(
                                          shops[index].shopdiscription,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200,color: Colors.white),
                                        ),




                                        !checkTime(shops[index].openTime,shops[index].closeTime)?
                                        Container(
                                           decoration: BoxDecoration(

                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                           color: Colors.redAccent[700]

                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                                            child: Text(
                                              "Closed",
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300,color:Colors.white),
                                            ),
                                          ),
                                        ):

                                        shops[index].ShopStatus.contains("Closed")?
                                        Container(
                                          decoration: BoxDecoration(

                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                              color: Colors.redAccent[700]

                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                                            child: Text(
                                              "Closed",
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300,color:Colors.white),
                                            ),
                                          ),
                                        ):
                                        SizedBox()


                                      ],
                                    ),
                                  ),
                                ),
                              ), /* add child content here */
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Column(
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
                                Text("Loading", style: TextStyle(fontSize: 12,color: Colors.white),),
                              ],
                            ));
                  }
                }),
          ),
        ],
      ),
    );

  }


}
