import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:Doorstep/styles/styles.dart';
import 'package:Doorstep/screens/auth/sign-in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool checkEmails = true;
  bool checkTerms = true;
  bool showText = true;

  FocusNode _focusNodeEmail,_focusNodeAddress, _focusNodePass, _focusNodeConPass,_focusNodeMobile,_focusNodeUsername,_focusNodeFirstName,_focusNodeLastName,_focusNodeNationality,_focusNodeCode;

  bool isloadingDialogueShowing=false;

  bool isLoadingError=false;
  hideLoadingDialogue(){

    if(isloadingDialogueShowing) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      isloadingDialogueShowing=false;
      isLoadingError=false;
    }
  }
  Dialog loadingdialog;
  showLoadingDialogue(String message){

    if(!isloadingDialogueShowing) {
      loadingdialog= Dialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child:   Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SpinKitFadingCircle(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index==1 ? Colors.orange[900] :index==2 ?Colors.orange[800] : index==3 ?Colors.orange[700] : index==4 ?
                      Colors.orange[600] :index==5 ?Colors.orange[500] : index==6 ?Colors.orange[400]:
                      index==1 ?Colors.orange[300] : index==1 ?Colors.orange[200] : index==1 ?Colors.orange[100] : index==1 ?
                      Colors.orange[100] :index==1 ?Colors.orange[100] :Colors.orange[900]
                      ,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  );
                },
              ),
              Text(""+message, style: TextStyle(fontSize: 12,color: Colors.white),),
            ],
          )
      );
      showDialog(
          context: context, builder: (BuildContext context) => loadingdialog);
      showDialog(
          context: context, builder: (BuildContext context) => loadingdialog);
      isloadingDialogueShowing = true;
    }
    isLoadingError=true;


  }

  @override
  void dispose() {
    super.dispose();
    _focusNodeEmail.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNodeEmail = new FocusNode();
    _focusNodeEmail.addListener(_onOnFocusNodeEvent);

    _focusNodePass = new FocusNode();
    _focusNodePass.addListener(_onOnFocusNodeEvent);

    _focusNodeConPass = new FocusNode();
    _focusNodeConPass.addListener(_onOnFocusNodeEvent);

    _focusNodeMobile = new FocusNode();
    _focusNodeMobile.addListener(_onOnFocusNodeEvent);

    _focusNodeUsername = new FocusNode();
    _focusNodeUsername.addListener(_onOnFocusNodeEvent);

    _focusNodeFirstName = new FocusNode();
    _focusNodeFirstName.addListener(_onOnFocusNodeEvent);

    _focusNodeLastName = new FocusNode();
    _focusNodeLastName.addListener(_onOnFocusNodeEvent);



    _focusNodeCode = new FocusNode();
    _focusNodeCode.addListener(_onOnFocusNodeEvent);

    _focusNodeNationality = new FocusNode();
    _focusNodeNationality.addListener(_onOnFocusNodeEvent);

    _focusNodeAddress = new FocusNode();
    _focusNodeAddress.addListener(_onOnFocusNodeEvent);


  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  void showPassword() {
    setState(() {
      showText =! showText;
    });
  }
  String date;
  String username;
  String email;
  String password;
  String password2;
  String mobilenumber;
  String address;
  String nationality = "Saudi Arabia";
  String first_name,last_name;
  var errorText;

  bool loading = false;

  Firestore store;


  CollectionReference get users => store.collection('users');

  final databaseReference = Firestore.instance;
   String dateSel = "Select Date of Birth";
  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1920, 1),
        lastDate: DateTime.now());
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


        dateSel=day+'-'+month+'-'+year;

      });
  }
  TextEditingController _codeController = TextEditingController();
  String entered_code;

  confirmationCode(BuildContext context,String code) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation code'),

            content:Container(
              height: 120,
              child: Column(
                children: <Widget>[
                  Text('A Verification code has been sent to '+mobilenumber+' . Please enter that code to Signup'),
                  SizedBox(height:10),
                  TextFormField(
                    controller: _codeController,
                    cursorColor: Colors.black, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
                    keyboardType: TextInputType.text,

                    validator: (String value) {
                      if(value.isEmpty)
                        return 'Please Enter Confirmation code ';
                      else
                        return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none
                      ),

                      labelText: "Code",
                    ),
                    focusNode: _focusNodeCode,
                  ),

                ],
              ),
              decoration: new BoxDecoration(
                border: new Border(
                  bottom: _focusNodeCode.hasFocus ? BorderSide(color: Colors.black, style: BorderStyle.solid, width: 2.0) :
                  BorderSide(color: Colors.black.withOpacity(0.7), style: BorderStyle.solid, width: 1.0),
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {

                  final FormState form = _formKey.currentState;
                  if (!form.validate()) {
                    return;
                  }

                  form.save();

                  print(_codeController.text);
                  if(_codeController.text==code){
                    Navigator.of(context).pop();

                  }else{
                    ToastUtils.showCustomToast(context, "Invalid code",false);

                  }


                },
              ),
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {

                  Navigator.of(context).pop();



                },
              ),
            ],
          );
        });
  }


  String loginas = 'Driver';

  List <String> spinnerItems = [
    'Driver',
    'Trader',
    'Broker',
  ] ;


  TextEditingController _controllerCode = TextEditingController();

  phoneAuth(String phone) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {

          ToastUtils.showCustomToast(context, "Phone Verified",true);


        },
        verificationFailed: (AuthException exception) {


          ToastUtils.showCustomToast(context, "Error! Try Again Later",false);

        },
        codeSent: (String verification, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  title: Text('Enter 6-Digit Code sent to ${mobilenumber}'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _controllerCode,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                       //   errorText: validateCode(_controllerCode.text),
                          hintText: 'Enter Code',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                      )
                    ],
                  ),
                  actions: <Widget>[

                    FlatButton(
                       shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.lightBlue,
                      onPressed: () async {

                        final code = _controllerCode.text.trim();
                        AuthCredential credential =
                        PhoneAuthProvider.getCredential(
                            verificationId: verification, smsCode: code);
                        AuthResult result =
                        await _auth.signInWithCredential(credential);
                        FirebaseUser user = result.user;
                        if (user != null) {
                          ToastUtils.showCustomToast(context, "Code Confirmed",true);
                          Navigator.of(context).pop();
                        } else {
                          _controllerCode.clear();

                          ToastUtils.showCustomToast(context, "Code Mismatched",false);

                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }

  String _chars = '1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  String phoneNo;
  String smsCode;
  String verificationId;




  int selectedRadio;

  String gender=null;
  String uid = '';

  getUid() {}
// Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
      switch (val){
        case 1:
          gender="Male";
          break;
        case 2:
          gender="Female";
          break;

      }
    });
  }

  @override
  Widget build(BuildContext context) {



    Widget userForm = Container(
      margin: EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.account_circle),
          Container(
            width: screenWidth(context)*0.7,
            child: TextFormField(
              cursorColor: Colors.black, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
              keyboardType: TextInputType.emailAddress,
              onSaved: (String value) {
                username = value;
              },
              validator: (String value) {
                if(value.isEmpty)
                  return 'Please Enter Username';
                else
                  return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none
                ),
                labelText: "Username",
              ),
              focusNode: _focusNodeUsername,
            ),
          ),
        ],
      ),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: _focusNodeUsername.hasFocus ? BorderSide(color: Colors.black, style: BorderStyle.solid, width: 2.0) :
          BorderSide(color: Colors.black.withOpacity(0.7), style: BorderStyle.solid, width: 1.0),
        ),
      ),
    );

    Widget emailForm = Container(
      margin: EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.mail),
           Container(
            width: screenWidth(context)*0.7,
            child: TextFormField(
              cursorColor: Colors.black, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
              keyboardType: TextInputType.emailAddress,
              onSaved: (String value) {
                 email = value;
              },
              validator: (String value) {
                bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);

                if(value.isEmpty)
                  return 'Please Enter Email Id';


                else if(!emailValid){
                  return "Please enter a valid Email";
                }else{
                  return null;
                  }
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none
                ),
                labelText: "Email Id",
              ),
              focusNode: _focusNodeEmail,
            ),
          ),
        ],
      ),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: _focusNodeEmail.hasFocus ? BorderSide(color: Colors.black, style: BorderStyle.solid, width: 2.0) :
              BorderSide(color: Colors.black.withOpacity(0.7), style: BorderStyle.solid, width: 1.0),
        ),
      ),
    );

    Widget passwordForm = Container(
      margin: EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.lock),
          Container(
            width: screenWidth(context)*0.72,
            child: TextFormField(
              cursorColor: Colors.black, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
              onSaved: (value) => password = value,
              validator: (String value) {
                if(value.length < 6)
                  return 'Password should be 6 or more digits';
                else
                  return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none
                ),
                labelText: "Password",
              ),
              focusNode: _focusNodePass,
              obscureText: showText,
            ),
          ),
          InkWell(
              onTap: showPassword,
              child: showText ?  Icon(Icons.visibility_off,color: Colors.grey[500],) :
              Icon(Icons.visibility,color: primaryDark,)
          ),
        ],
      ),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: _focusNodePass.hasFocus ? BorderSide(color: Colors.black, style: BorderStyle.solid, width: 2.0) :
          BorderSide(color: Colors.black.withOpacity(0.7), style: BorderStyle.solid, width: 1.0),
        ),
      ),
    );

    Widget confirmPassword = Container(
      margin: EdgeInsets.only(bottom: 18.0),

      child: Row(
        children: <Widget>[
          Icon(Icons.lock),
          Container(
            width: screenWidth(context)*0.72,
            child: TextFormField(
              cursorColor: Colors.black, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
              onSaved: (value) => password2 = value,
              validator: (String value) {
                if(value.length < 6)
                  return 'Password should be 6 or more digits';
                else
                  return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none
                ),
                labelText: "Confirm Password",
              ),
              focusNode: _focusNodeConPass,
              obscureText: showText,
            ),
          ),
          InkWell(
              onTap: showPassword,
              child: showText ?  Icon(Icons.visibility_off,color: Colors.grey[500],) :
              Icon(Icons.visibility,color: primaryDark,)
          ),
        ],
      ),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: _focusNodeConPass.hasFocus ? BorderSide(color: Colors.black, style: BorderStyle.solid, width: 2.0) :
          BorderSide(color: Colors.black.withOpacity(0.7), style: BorderStyle.solid, width: 1.0),
        ),
      ),
    );

    Widget mobile  = Container(
      margin: EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.phone_android),
          Container(
            width: screenWidth(context)*0.7,
            child: TextFormField(
              cursorColor: Colors.black, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
              keyboardType: TextInputType.number,
              onSaved: (String value) {
                mobilenumber = value;
              },
              validator: (String value) {
                if(value.length > 13 || value.length < 10)
                  return 'Mobile Number should be 10 or more digits and less than 13';
                else
                  return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none
                ),
                labelText: "Mobile Number",
              ),
              focusNode: _focusNodeMobile,
            ),
          ),
        ],
      ),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: _focusNodeMobile.hasFocus ? BorderSide(color: Colors.black, style: BorderStyle.solid, width: 2.0) :
          BorderSide(color: Colors.black.withOpacity(0.7), style: BorderStyle.solid, width: 1.0),
        ),
      ),
    );



    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[

                Form(
                  key: _formKey,
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    margin: EdgeInsets.only(top: 80.0),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("assets/icons/logo.png", width: 200.0, height: 180.0, fit: BoxFit.contain,),
                        SizedBox(height: 20,),
                        Text("Sign Up",style: TextStyle(fontSize: 32) ),
                        Container(
                          margin: EdgeInsets.only(top: 24.0,bottom: 30.0),
                          alignment: AlignmentDirectional.center,
                          width: screenWidth(context)*0.8,
                          child: Text("Sign Up for a new Doorstep Account Now",
                           textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          alignment: AlignmentDirectional.topStart,
                          padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 4.0, right: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Name",),
                              userForm,


                              Text("Email", ),
                              emailForm,

                              Text("Password",),
                              mobile,
                              passwordForm,
                              confirmPassword,
                              Text("Detailes",),




                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              activeColor: primaryDark,
                              value: checkTerms,
                              onChanged: (bool value) {
                                setState(() {
                                  checkTerms = value;
                                });
                              },
                            ),
                            Container(

                              width: screenWidth(context)*0.74,
                              child: RichText(

                                text: new TextSpan(
                                  children: <TextSpan>[
                                    new TextSpan(text: 'I agree with the',style: TextStyle(color: Colors.black)),
                                    new TextSpan(text: ' Terms and Condition ',style: TextStyle(color: Colors.black)),
                                    new TextSpan(text: 'and the',style: TextStyle(color: Colors.black)),
                                    new TextSpan(text: ' Privacy Policy ', style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, bottom: 12.0),
                          child: SizedBox(
                            width: 200,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),

                              ),

                              color: primaryDark,
                              onPressed: () async {
                           //     await registerUser();
                               },
                              child: Text( "SIGN UP",style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                        RawMaterialButton(
                            onPressed: (){

                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));

                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("Already have an account? ",),
                                Text("Sign in here",style: TextStyle(decoration: TextDecoration.underline,), )
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );




  }
}
