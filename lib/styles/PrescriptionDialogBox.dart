import 'dart:io';
import 'dart:ui';

import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import 'PrescriptionImageDialogBox.dart';

class PrescriptionDialogBox extends StatefulWidget {
  final String title, descriptions;

  const PrescriptionDialogBox({Key key, this.title, this.descriptions}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<PrescriptionDialogBox> {


  String _image;
  final picker = ImagePicker();

  Future getImagegallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,  imageQuality: 30,);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImagecamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 30);

    setState(() {
      if (pickedFile != null) {
        _image = pickedFile.path;
      } else {
        print('No image selected.');
      }
    });
  }

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


              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        onPressed: (){
                         // Navigator.of(context).pop();

                          getImagecamera().then((value) {
                         if(_image!=null) {
                            showDialog(context: context,
                                builder: (BuildContext context){
                                  return PrescriptionImageDialogBox(
                                    title: "Prescription Added",
                                    descriptions: "A Valid Medical Prescription is Required for any Purchase of Narcotic Medicine",
                                    buttonText: "Upload",
                                    image: _image,

                                  );
                                }
                            ).then((value) {


                              Navigator.of(context).pop();
                            });
                         }else{
                           ToastUtils.showCustomToast(context, "No Image Selected",false);

                         }
                          });

                          //Navigator.of(context).pop();
                        },
                        child: Text("Camera",style: TextStyle(fontSize: 18),)),
                  ),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        onPressed: (){
                          // Navigator.of(context).pop();

                          getImagegallery().then((value) {

                            if(_image!=null) {
                              showDialog(context: context,
                                  builder: (BuildContext context) {
                                    return PrescriptionImageDialogBox(
                                      title: "Upload Prescription",
                                      descriptions: "A Valid Medical Prescription is Required for any Purchase of Narcotic Medicine",
                                      buttonText: "Upload",
                                      image: _image,

                                    );
                                  }
                              ).then((value) {

                                Navigator.of(context).pop();

                              });
                            }else{
                              ToastUtils.showCustomToast(context, "No Image Selected",false);

                            }


                          });

                          //Navigator.of(context).pop();
                        },
                        child: Text("Gallery",style: TextStyle(fontSize: 18),)),
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
