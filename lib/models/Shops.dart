import 'package:firebase_database/firebase_database.dart';

class Shops {
  String key;
  String shopid;
  String shopcategory;
  String shopdiscription;
  String shopimage;
  String shopname;
  String location;


  Shops(this.key,this.shopid,this.shopcategory,this.shopdiscription,this.shopimage,this.shopname,this.location);


  Shops.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        shopid = snapshot.value["shopid"],
        shopcategory = snapshot.value["shopcategory"],
        shopdiscription= snapshot.value["shopdiscription"],
        shopimage= snapshot.value["shopimage"],
        shopname= snapshot.value["shopname"],
        location= snapshot.value["location"];


  toJson() {
    return {
      "key": key,
      "shopid": shopid,
      "shopcategory": shopcategory,
      "shopdiscription": shopdiscription,
      "shopimage": shopimage,
      "shopname": shopname,
      "location": location,

    };
  }


}