import 'package:firebase_database/firebase_database.dart';

class Shops {
  String key;
  String shopid;
  String shopcategory;
  String shopdiscription;
  String shopimage;
  String shopname;
  String shoptown;


  Shops(this.key,this.shopid,this.shopcategory,this.shopdiscription,this.shopimage,this.shopname,this.shoptown);


  Shops.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        shopid = snapshot.value["shopid"],
        shopcategory = snapshot.value["shopcategory"],
        shopdiscription= snapshot.value["shopdiscription"],
        shopimage= snapshot.value["shopimage"],
        shoptown= snapshot.value["shoptown"],
        shopname= snapshot.value["shopname"];


  toJson() {
    return {
      "key": key,
      "shopid": shopid,
      "shopcategory": shopcategory,
      "shopdiscription": shopdiscription,
      "shopimage": shopimage,
      "shoptown": shoptown,
      "shopname": shopname,
    };
  }


}