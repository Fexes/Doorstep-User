
import 'package:firebase_database/firebase_database.dart';

class CategoryName {
  String key;
  String category_name;
 


   CategoryName(this.key,this.category_name);



  CategoryName.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        category_name = snapshot.value["category_name"];


  toJson() {
    return {
      "key": key,
      "category_name": category_name,
    };
  }

}