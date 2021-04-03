
import 'package:firebase_database/firebase_database.dart';

class Addresses {
  String key;
  String address;
  String location;


   Addresses(this.key,this.address,this.location);



  Addresses.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        address = snapshot.value["address"],
        location = snapshot.value["location"];


  toJson() {
    return {
      "key": key,
      "address": address,
      "location": location,

    };
  }

}