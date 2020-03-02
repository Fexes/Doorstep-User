
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naqelapp/session/Permit.dart';
import 'package:naqelapp/session/Userprofile.dart';
import 'package:naqelapp/styles/app_theme.dart';
import 'package:naqelapp/styles/styles.dart';
import 'package:naqelapp/utilts/custom_dialogue.dart';

class PermitPage extends StatefulWidget  {


  const PermitPage({Key key}) : super(key: key);



  @override
  _PermitPageState createState() => _PermitPageState();
}

class _PermitPageState extends State<PermitPage>  {

  List<Permit>  permits;

  FocusNode _focusNodepermitnumber,_focusNodepermitCode,_focusNodepermitPlace;
  @override
  void initState() {
    super.initState();

    loadData();

    _focusNodepermitnumber = new FocusNode();
    _focusNodepermitnumber.addListener(_onOnFocusNodeEvent);


    _focusNodepermitCode = new FocusNode();
    _focusNodepermitCode.addListener(_onOnFocusNodeEvent);


    _focusNodepermitPlace = new FocusNode();
    _focusNodepermitPlace.addListener(_onOnFocusNodeEvent);
  }
  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  void loadData() {

    permits = Userprofile.getPermit();
  }



  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image.path);
    setState(() {
      _image = image;
      _displayDialog(context);
    });
  }
  DateTime selectedDate = DateTime.now();

  String dateSel = "Select Expiry Date";
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1920, 1),
        lastDate: DateTime(2070, 1));
    if (picked != null && picked != selectedDate)
      setState(() {



        selectedDate = new DateTime(picked.year, picked.month, picked.day);
        String day = selectedDate.day.toString();
        String month ;
        String year = selectedDate.year.toString();

        switch (selectedDate.month) {
          case 1:
            month = "Jan";
            break;
          case 2:
            month = "Feb";
            break;
          case 3:
            month = "Mar";
            break;
          case 4:
            month = "Apr";
            break;
          case 5:
            month = "May";
            break;
          case 6:
            month = "Jun";
            break;
          case 7:
            month = "Jul";
            break;
          case 8:
            month = "Aug";
            break;
          case 9:
            month = "Sep";
            break;
          case 10:
            month = "Oct";
            break;
          case 11:
            month = "Nov";
            break;
          case 12:
            month = "Dec";
            break;
        }


        dateSel=day+' - '+month+' - '+year;
     //   date_of_birth=dateSel;
        _displayDialog(context);
      });
  }

   _displayDialog(BuildContext context) {
     Dialog dialog= Dialog(
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(60),
       ),
       elevation: 0.0,
       backgroundColor: Colors.transparent,
       child: dialogContent(context),
     );

     showDialog(context: context, builder: (BuildContext context) => dialog);

}

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 90.0+ 16.0,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          margin: EdgeInsets.only(top: 90.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),

            child: Column(

              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                SizedBox(height: 26.0),

                Text(
                  "Add new Permit",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                margin: EdgeInsets.only(bottom: 18.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.confirmation_number),
                    Container(
                      width: screenWidth(context)*0.5,
                      child: TextFormField(
                        cursorColor: Colors.black, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
                        keyboardType: TextInputType.number,

                        validator: (String value) {
                          if(value.length == null)
                            return 'Enter Permit Number';
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none
                          ),

                          labelText: "Permit Number",

                        ),
                         focusNode: _focusNodepermitnumber,
                      ),
                    ),
                  ],
                ),
                decoration: new BoxDecoration(
                  border: new Border(
                    bottom: _focusNodepermitnumber.hasFocus ? BorderSide(color: Colors.black, style: BorderStyle.solid, width: 2.0) :
                    BorderSide(color: Colors.black.withOpacity(0.7), style: BorderStyle.solid, width: 1.0),
                  ),
                ),
              ),
              //  SizedBox(height: 16.0),
                Container(
                  margin: EdgeInsets.only(bottom: 18.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.code),
                      Container(
                        width: screenWidth(context)*0.5,
                        child: TextFormField(
                          cursorColor: Colors.black, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
                          keyboardType: TextInputType.number,

                          validator: (String value) {
                            if(value.length == null)
                              return 'Enter Permit Code';
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),

                            labelText: "Permit Code",

                          ),
                          focusNode: _focusNodepermitCode,
                        ),
                      ),
                    ],
                  ),
                  decoration: new BoxDecoration(
                    border: new Border(
                      bottom: _focusNodepermitCode.hasFocus ? BorderSide(color: Colors.black, style: BorderStyle.solid, width: 2.0) :
                      BorderSide(color: Colors.black.withOpacity(0.7), style: BorderStyle.solid, width: 1.0),
                    ),
                  ),
                ),
               // SizedBox(height: 16.0),
                Container(
                  margin: EdgeInsets.only(bottom: 18.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.place),
                      Container(
                        width: screenWidth(context)*0.5,
                        child: TextFormField(
                          cursorColor: Colors.black, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
                          keyboardType: TextInputType.text,

                          validator: (String value) {
                            if(value.length == null)
                              return 'Enter Permit Place';
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none
                            ),

                            labelText: "Permit Place",

                          ),
                          focusNode: _focusNodepermitPlace,
                        ),
                      ),
                    ],
                  ),
                  decoration: new BoxDecoration(
                    border: new Border(
                      bottom: _focusNodepermitPlace.hasFocus ? BorderSide(color: Colors.black, style: BorderStyle.solid, width: 2.0) :
                      BorderSide(color: Colors.black.withOpacity(0.7), style: BorderStyle.solid, width: 1.0),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(bottom: 18.0),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      Container(
                        child: FlatButton(

                          child: Text(dateSel,textAlign: TextAlign.start,),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _selectDate(context);
                             // To close the dialog

                          },
                        ),
                      ),
                    ],
                  ),

                ),
               // SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          dateSel="Select Expiry Date";
                          _image=null;
                          Navigator.of(context).pop(); // To close the dialog
                        },
                        child: Text("Cancel"),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {

                          Navigator.of(context).pop(); // To close the dialog
                        },
                        child: Text("Add"),
                      ),
                    ),
                  ],

                ),
              ],
            ),
          ),
        ),

        Positioned(
          left: 76.0,
          right: 76.0,
          child:  GestureDetector(
            onTap: (){
              getImage();
              Navigator.of(context).pop();
            },
            child: new Stack(
              alignment:new Alignment(1, 1),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,0),
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(

                      shape: BoxShape.rectangle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey,
                            offset: const Offset(2.0, 4.0),
                            blurRadius: 12),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(15)),
                      child: _image == null
                          ?    Icon(Icons.add,color: Colors.white,size: 130,)

                          : Image.file(_image,fit: BoxFit.cover),

                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ],
    );


  }

  @override
  Widget build(BuildContext context) {

    return Align(

      child: SafeArea(

        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,

            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  Text('Permits',style: TextStyle(color: Colors.black),),
                ]
            ),
          ),
          backgroundColor: Color(0xffF7F7F7),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[

              const SizedBox(
                height: 30,
              ),
              permits!=null? Container(
                  height:(MediaQuery.of(context).size.height)-110,
                  width: MediaQuery.of(context).size.width,
                  child:
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: permits.length,

                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          key: ValueKey(permits[index]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,


                            children: <Widget>[

                              Row(

                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,


                                children: <Widget>[

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                    child: Container(
                                      height: 95,
                                      width: 95,
                                      decoration: BoxDecoration(

                                        shape: BoxShape.rectangle,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: AppTheme.grey.withOpacity(0.6),
                                              offset: const Offset(2.0, 4.0),
                                              blurRadius: 8),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular(8)),
                                        child: Image.network(permits[index].PhotoURL,fit: BoxFit.cover),
                                      ),

                                    ),
                                  ),
                                  SizedBox(width: 20),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: <Widget>[
                                          Padding(

                                            padding: const EdgeInsets.only(top: 0, left: 0),
                                            child: Text("Permit Number: ",
                                              style: TextStyle(
                                                color: AppTheme.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 0, left: 0),
                                            child: Text("Permit Code: ",
                                              style: TextStyle(
                                                color: AppTheme.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 0, left: 0),
                                            child: Text("Permit Place: ",
                                              style: TextStyle(
                                                color: AppTheme.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 5),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 0, left: 0),
                                            child: Text("Expiry Date: ",
                                              style: TextStyle(
                                                color: AppTheme.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],),

                                      SizedBox(width: 10),

                                      Column(

                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 0, left: 0),
                                            child: Text('${permits[index].PermitNumber}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: AppTheme.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 0, left: 0),
                                            child: Text('${permits[index].Code}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: AppTheme.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 0, left: 0),
                                            child: Text('${permits[index].Place}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: AppTheme.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 0, left: 0),
                                            child: Text('${permits[index].ExpiryDate}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: AppTheme.grey,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                 child :FloatingActionButton(

                                  onPressed: (){

                                    _displayDialog(context);
                                  },
                                  backgroundColor: Colors.black,
                                  child: Icon(Icons.add),
                                )

                              ),

                            ],
                          ),

                        );
                      }
                  )


              )  :Container(
                  child: FloatingActionButton(

                    onPressed: (){
                      _displayDialog(context);
                    },
                    backgroundColor: Colors.black,
                    child: Icon(Icons.add),
                  )
              ),



            ],
          )

        ),
      ),
    );
  }




}
