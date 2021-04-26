import 'package:Doorstep/models/Addresses.dart';
import 'package:Doorstep/models/AppUser.dart';
import 'package:Doorstep/models/Cart.dart';
import 'package:Doorstep/models/Promo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DataStream{

  static bool once=true;
  static bool once2=true;

  static String UserId;
  static String Username;
  static String Email;
  static String PhoneNumber;
  static String userTokenID;
  static FirebaseUser user;
  static String googleAPIKey ="AIzaSyBoLgH-s1XnyhCQ2PZEUbIaH_Jj2RKhMSU";

   static LatLng userlocation;
  static String userAddress="Current Location";

  static AppUser appuser;

  static String ShopId;
  static String savedAddresskey;
  static String ShopCatagory;
  static String ShopName;
  static int DeliverCharges;
  static int DeliverChargesPharmacy;
  static int delivery_charges_per_shop;
  static int OrderRadius;
  static int Discount=0;
  static int MinOrder=0;
  static List<Addresses> addresses;

  static int order_count=0;

  static Promo PromoCode;

  static String prescriptionImage;


  List<Cart> carts;


}