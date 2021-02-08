
import 'package:firebase_database/firebase_database.dart';

class Product {
  String key;
  String cardid;
  String cardname;
  String cardimage;
  int cardprice;
  String carddiscription;
  String unit;
  String category;
  String stock;
  String timeopen;
  String timeclose;


  Product(this.key,this.cardid,this.cardname,this.cardimage,this.cardprice,this.carddiscription,this.unit,this.category,this.stock,this.timeopen,this.timeclose);


  Product.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        cardid = snapshot.value["cardid"],
        cardname = snapshot.value["cardname"],
        cardimage = snapshot.value["cardimage"],
        cardprice = snapshot.value["cardprice"].round(),
        carddiscription = snapshot.value["carddiscription"],
        unit = snapshot.value["unit"],
        category = snapshot.value["category"],
        timeopen = snapshot.value["timeopen"],
        timeclose = snapshot.value["timeclose"],
        stock = snapshot.value["stock"];



  toJson() {
    return {
      "key": key,
      "cardid": cardid,
      "cardname": cardname,
      "cardimage": cardimage,
      "cardprice": cardprice,
      "carddiscription": carddiscription,
      "unit": unit,
      "category": category,
      "timeopen": timeopen,
      "timeclose": timeclose,
      "stock": stock,

    };
  }



}