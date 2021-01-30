
import 'package:firebase_database/firebase_database.dart';

class ShopCategory {
  String key;
  String CategoryImage;
  String CategoryName;
  String TagLine;
  int group;
  int index;



  ShopCategory(this.key,this.CategoryImage,this.CategoryName,this.TagLine,this.group,this.index);



  ShopCategory.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        CategoryImage = snapshot.value["CategoryImage"],
        CategoryName = snapshot.value["CategoryName"],
        TagLine = snapshot.value["TagLine"],
        group = snapshot.value["group"],
        index = snapshot.value["index"];



  toJson() {
    return {
      "key": key,
      "CategoryImage": CategoryImage,
      "CategoryName": CategoryName,
      "TagLine": TagLine,
      "group": group,
      "index": index,
    };
  }

}