import 'dart:io';
import 'dart:ui';

import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'PrescriptionDialogBox.dart';

class PrescriptionImageDialogBox extends StatefulWidget {
  final String title, descriptions, buttonText,image;

  const PrescriptionImageDialogBox({Key key, this.title, this.descriptions, this.buttonText, this.image}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<PrescriptionImageDialogBox> {

 
 

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
              SizedBox(height: 25,),

             
              Image.file(new File(widget.image),height: 200,),


              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        onPressed: (){
                          DataStream.prescriptionImage=null;
                           Navigator.of(context).pop();


                        },
                        child: Text("Remove",style: TextStyle(fontSize: 18,color: Colors.red),)),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        onPressed: (){

                          DataStream.prescriptionImage=widget.image;
                          Navigator.of(context).pop();
                        },
                        child: Text("Done",style: TextStyle(fontSize: 18),)),
                  ),
                ],
              ),




            ],
          ),

        ),
        Positioned(
          left: 30,
          right: 0,
          top: -10,
          child: Container(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child:  Lottie.asset('assets/prescription.json',repeat: true,fit: BoxFit.scaleDown,),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
