import 'dart:ui';
import 'package:Doorstep/models/Promo.dart';
import 'package:Doorstep/screens/home/checkout_screen.dart';
import 'package:Doorstep/styles/styles.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PromoDialogBox extends StatefulWidget {
  final String title, descriptions, text ;
  final Image img;

  const PromoDialogBox({Key key, this.title, this.descriptions, this.text, this.img}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<PromoDialogBox> {

  String code;

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    FocusNode  _focusNode = new FocusNode();
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10,top: 90
              , right: 10,bottom: 10
          ),
          margin: EdgeInsets.only(top: 90),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(widget.descriptions,style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
              ),
              SizedBox(height: 15,),

              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  margin: EdgeInsets.only(bottom: 18.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.card_giftcard),
                      //   Image.asset("assets/icons/user-grey.png", height: 16.0, width: 16.0,),
                      Container(
                        width: screenWidth(context)*0.55,
                        child: TextFormField(
                          cursorColor: primaryDark, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
                          keyboardType: TextInputType.text,
                          onChanged: (text) {
                             code = text.toString();


                          },
                          validator: (String value) {
                            if(value.isEmpty)
                              return 'Please Enter Your Address';
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),
                            labelText: "Promo Code",
                          ),
                          focusNode: _focusNode,
                        ),
                      ),
                    ],
                  ),
                  decoration: new BoxDecoration(
                    border: new Border(
                      bottom: BorderSide(color: _focusNode.hasFocus ? primaryDark : border, style: BorderStyle.solid, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25,),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: (){


                      final locationDbRef = FirebaseDatabase.instance.reference().child(
                          "Admin").child("Promo").child(code);

                      locationDbRef.once().then((value) async {


                        if(value.value!=null) {

                          DatabaseReference promoref = FirebaseDatabase.instance
                              .reference()
                              .child('Users').child(
                              DataStream.UserId)
                              .child("Promo")
                              .child(code);


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

                          active = value.value["active"];
                          delivery = value.value["delivery"];
                          discount = value.value["discount"];
                          location = value.value["location"];
                          locationradius = value.value["locationradius"];
                          message = value.value["message"];
                          min_order = value.value["min_order"];
                          promoID = value.value["promoID"];
                          valid_till = value.value["valid_till"];




                          promoref.once().then((value) async {


                            if(value.value==null) {
                              ToastUtils.showCustomToast(
                                  context, "Promo Verified", true);

                              DataStream.PromoCode = new Promo(key, active, delivery, discount,  location, locationradius, message, min_order, promoID, valid_till);

                               Navigator.of(context).pop();

                            }else{

                              ToastUtils.showCustomToast(
                                  context, "Promo Already Used", false);

                              Navigator.of(context).pop();

                            }

                          }

                          );



                        }else{

                          ToastUtils.showCustomToast(
                              context, "Invalid Promo", false);
                          Navigator.of(context).pop();
                        }

                      }

                      );


                      //Navigator.of(context).pop();
                    },
                    child: Text(widget.text,style: TextStyle(fontSize: 18),)),
              ),

            ],
          ),

        ),
        Positioned(
          left: 30,
          right: 0,
          top: -22,
          child: Container(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child:  Lottie.asset('assets/coupon.json',repeat: true,fit: BoxFit.scaleDown,),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
