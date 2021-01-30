import 'package:firebase_database/firebase_database.dart';

class Shops {
  String key;
  String shopid;
  String shopcategory;
  String shopdiscription;
  String shopimage;
  String shopname;
  String location;
   String openTime;
   String closeTime;
   int radius;
   double distanceInMeters;
   String ShopStatus;

  Shops(this.key,this.shopid,this.shopcategory,this.shopdiscription,this.shopimage,this.shopname,this.location ,this.openTime,this.closeTime,this.radius,this.distanceInMeters,this.ShopStatus);


  Shops.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        shopid = snapshot.value["shopid"],
        shopcategory = snapshot.value["shopcategory"],
        shopdiscription= snapshot.value["shopdiscription"],
        shopimage= snapshot.value["shopimage"],
        shopname= snapshot.value["shopname"],
        location= snapshot.value["location"],
        openTime= snapshot.value["openTime"],
        closeTime= snapshot.value["closeTime"],
        radius= snapshot.value["radius"],
        distanceInMeters= snapshot.value["distanceInMeters"],
        ShopStatus= snapshot.value["ShopStatus"];


  toJson() {
    return {
      "key": key,
      "shopid": shopid,
      "shopcategory": shopcategory,
      "shopdiscription": shopdiscription,
      "shopimage": shopimage,
      "shopname": shopname,
      "location": location,
      "openTime": openTime,
      "closeTime": closeTime,
      "radius": radius,
      "distanceInMeters": distanceInMeters,
      "ShopStatus": ShopStatus,
    };
  }


}