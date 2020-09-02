import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DataStream{

  static String UserId;
  static String Username;
  static String Email;
  static String PhoneNumber;
  static FirebaseUser user;
  static String googleAPIKey ="AIzaSyBoLgH-s1XnyhCQ2PZEUbIaH_Jj2RKhMSU";


   static LatLng userlocation;


  static String ShopId;
  static String ShopCatagory;
  static String ShopName;
  static int DeliverCharges;
  static int OrderRadius;
  static int Discount=0;



}