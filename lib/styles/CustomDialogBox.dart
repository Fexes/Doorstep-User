import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text , orderId;
  final Image img;

  const CustomDialogBox({Key key, this.title, this.descriptions, this.text,this.orderId, this.img}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
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
              Text(widget.descriptions,style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
              SizedBox(height: 15,),
              Text(widget.orderId,style: TextStyle(fontSize: 22,color: Colors.redAccent),textAlign: TextAlign.center,),
              SizedBox(height: 25,),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text(widget.text,style: TextStyle(fontSize: 18),)),
              ),
            ],
          ),
        ),
        Positioned(
          left: 30,
          right: 0,
          top: -40,
          child: Container(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 120,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child:  Lottie.asset('assets/done.json',repeat: true,fit: BoxFit.scaleDown),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
