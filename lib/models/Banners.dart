
import 'package:firebase_database/firebase_database.dart';

class Banners {
  String key;
  String image;
  String shopid;
  String itemcategory;
  String productid;
  String shopcatacgry;
  String location;
  int radius;


   Banners(this.key,this.image,this.shopid,this.itemcategory,this.productid,this.shopcatacgry,this.location,this.radius);



  Banners.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        image = snapshot.value["image"],
        shopid = snapshot.value["shopid"],
        itemcategory = snapshot.value["itemcategory"],
        productid = snapshot.value["productid"],
        shopcatacgry = snapshot.value["shopcatacgry"],
        location = snapshot.value["location"],
        radius = snapshot.value["radius"];


  toJson() {
    return {
      "key": key,
      "image": image,
      "shopid": shopid,
      "itemcategory": itemcategory,
      "productid": productid,
      "shopcatacgry": shopcatacgry,
      "location": location,
      "radius": radius,
    };
  }

}