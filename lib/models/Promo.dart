
import 'package:firebase_database/firebase_database.dart';

class Promo {
  String key;
  String active;
  int delivery;
  int discount;
  String location;
  int locationradius;
  String message;
  int min_order;
  String promoID;
  String valid_till;

  Promo(this.key,this.active,this.delivery,this.discount,this.location,this.locationradius,this.message,this.min_order,this.promoID,this.valid_till);

  Promo.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        active = snapshot.value["active"],
        delivery = snapshot.value["delivery"],
        discount = snapshot.value["discount"],
        location = snapshot.value["location"],
        locationradius = snapshot.value["locationradius"],
        message = snapshot.value["message"],
        min_order = snapshot.value["min_order"],
        promoID = snapshot.value["promoID"],
        valid_till = snapshot.value["valid_till"];


  toJson() {
    return {
      "key": key,
      "active": active,
      "delivery": delivery,
      "discount": discount,
      "location": location,
      "locationradius": locationradius,
      "message": message,
      "min_order": min_order,
      "promoID": promoID,
      "valid_till": valid_till,
    };
  }

}