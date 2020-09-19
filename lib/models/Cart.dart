
import 'package:firebase_database/firebase_database.dart';

class Cart {
  String key;
  int no_of_items;
  String cardid;
  String cardname;
  String cardimage;
  String unit;
  String shopcatagory;
  String shopid;
  int cardprice;

   Cart(this.key,this.no_of_items,this.cardid,this.cardname,this.cardimage,this.cardprice,this.shopcatagory,this.shopid,this.unit);


  Cart.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        cardid = snapshot.value["cardid"],
        cardname = snapshot.value["cardname"],
        cardimage = snapshot.value["cardimage"],
        cardprice = snapshot.value["cardprice"],
        no_of_items = snapshot.value["no_of_items"],
        shopcatagory = snapshot.value["shopcatagory"],
        shopid = snapshot.value["shopid"],
        unit = snapshot.value["unit"];


  toJson() {
    return {
      "key": key,
      "cardid": cardid,
      "cardname": cardname,
      "cardimage": cardimage,
      "cardprice": cardprice,
      "no_of_items": no_of_items,

      "shopcatagory": shopcatagory,
      "shopid": shopid,
      "unit": unit,

    };
  }

}