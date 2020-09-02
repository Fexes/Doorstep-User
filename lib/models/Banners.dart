
import 'package:firebase_database/firebase_database.dart';

class Banners {
  String key;
  String image;


   Banners(this.key,this.image);



  Banners.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        image = snapshot.value["image"];


  toJson() {
    return {
      "key": key,
      "image": image,


    };
  }

}