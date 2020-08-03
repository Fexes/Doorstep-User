
import 'package:firebase_database/firebase_database.dart';

class Order {
  String key;
  String no_of_items;
  String address;
  String bill;
  String location;
  String orderDate;
  String orderID;
  String orderTime;
  String phonenumber;
  String status;
  String userID;

   Order(this.key,this.no_of_items,this.bill,this.location,this.orderDate,this.address,this.orderTime,this.phonenumber,this.orderID,this.status,this.userID);


  Order.fromSnapshot(DataSnapshot snapshot):
        key = snapshot.key,
        no_of_items = snapshot.value["no_of_items"],
        bill = snapshot.value["bill"],
        location = snapshot.value["location"],
        orderDate = snapshot.value["orderDate"],
        address = snapshot.value["address"],
        orderTime = snapshot.value["orderTime"],
        phonenumber = snapshot.value["phonenumber"],
        orderID = snapshot.value["orderID"],
        status = snapshot.value["status"],
        userID = snapshot.value["userID"];

  toJson() {
    return {
      "key": key,
      "no_of_items": no_of_items,
      "bill": bill,
      "location": location,
      "orderDate": orderDate,
      "address": address,
      "orderTime": orderTime,
      "phonenumber": phonenumber,
      "orderID": orderID,
      "status": status,
      "userID": userID,

    };
  }

}