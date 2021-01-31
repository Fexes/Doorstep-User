import 'package:firebase_database/firebase_database.dart';

class Shops {
  String key;
  String address;
  String shopid;
  String shopcategory;
  String shopdiscription;
  String shopimage;
  String shopname;
  String location;
   String openTime;
   String closeTime;
   int radius;
   double distanceInKM;
   String ShopStatus;

  Shops(this.key,this.address,this.shopid,this.shopcategory,this.shopdiscription,this.shopimage,this.shopname,this.location ,this.openTime,this.closeTime,this.radius,this.distanceInKM,this.ShopStatus);


  Shops.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        address = snapshot.value["address"],
        shopid = snapshot.value["shopid"],
        shopcategory = snapshot.value["shopcategory"],
        shopdiscription= snapshot.value["shopdiscription"],
        shopimage= snapshot.value["shopimage"],
        shopname= snapshot.value["shopname"],
        location= snapshot.value["location"],
        openTime= snapshot.value["openTime"],
        closeTime= snapshot.value["closeTime"],
        radius= snapshot.value["radius"],
        distanceInKM= snapshot.value["distanceInKM"],
        ShopStatus= snapshot.value["ShopStatus"];


  toJson() {
    return {
      "key": key,
      "address": address,
      "shopid": shopid,
      "shopcategory": shopcategory,
      "shopdiscription": shopdiscription,
      "shopimage": shopimage,
      "shopname": shopname,
      "location": location,
      "openTime": openTime,
      "closeTime": closeTime,
      "radius": radius,
      "distanceInKM": distanceInKM,
      "ShopStatus": ShopStatus,
    };
  }


}