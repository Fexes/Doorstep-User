import 'dart:io';

import 'package:naqelapp/screens/navigation_home_screen.dart';
import 'package:naqelapp/session/Trailer.dart';
import 'package:naqelapp/session/Trucks.dart';
import 'package:naqelapp/utilts/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:naqelapp/styles/styles.dart';
import 'package:naqelapp/screens/auth/sign-up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show base64Url, json, utf8;
import 'package:http/http.dart' as http;
import '../../utilts/URLs.dart';
import '../../session/Userprofile.dart';
import 'forgot-password.dart';
import 'package:progress_dialog/progress_dialog.dart';




class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {




  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool checkRemember = true;
  bool showText = true;

  FocusNode _focusNode, _focusNode2;

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Future<void> initState()  {
    super.initState();


    _focusNode = new FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
    _focusNode2 = new FocusNode();
    _focusNode2.addListener(_onOnFocusNodeEvent);
  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  Color _getBorderColor() {
    return _focusNode.hasFocus ? primaryDark : border;
  }

  Color _getBorderColor2() {
    return _focusNode2.hasFocus ? primaryDark : border;
  }

  void showPassword() {
    setState(() {
      showText =! showText;
    });
  }

  String email;
  String password;
  var errorText;

  bool loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser() async {

    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      return;
    } else {
      form.save();

      try {
        FirebaseUser user = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        setState(() {
          loading = false;
        });


        print('onval $user');

     //   Navigator.pushAndRemoveUntil(
     //       context,
       //     MaterialPageRoute(
       //       builder: (BuildContext context) => Chat(user: user, userData: user,),
       //     ),
       //         (Route<dynamic> route) => false);

        //User Loged In

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
      } catch (onError) {
        setState(() {
          loading = false;
        });
        print('onnnnnn $onError');
        errorText = onError.toString().split(',')[1];
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Container(
              width: 270.0,
              child: new AlertDialog(
                title: new Text('Please check!!'),
                content: new SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      new Text('$errorText'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      }
    }
  }
  ProgressDialog pr;
  int DriverID=0;
  String Username="";
  String Password="";
  String PhoneNumber="";
  String FirstName="";
  String LastName="";
  String Nationality="";
  String Email="";
  String Gender="";
  String DateOfBirth="";
  String Address="";
  String ProfilePhotoURL="";
  int Active=0;



  int TruckID ;
  int TransportCompanyID;
  String PlateNumber="";
  String Owner="";
  int ProductionYear=0;
  String Brand="";
  String Model="";
  String Type="";
  int MaximumWeight=0;
  String TruckPhotoURL="";
  void signin() async {


    final FormState form = _formKey.currentState;
       if (!form.validate()) {
      return;
    }


    pr = new ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: false);

    pr.style(
        message: '     Signing In',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    pr.show();
    form.save();
    print(email);
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse(URLs.loginUrl()));
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");

    request.write('{"EmailOrUsername": "'+email+'", "Password": "'+password+'", "LoginInAs": "Driver"}');

    final response = await request.close();

    response.transform(utf8.decoder).listen((contents) async {

    //  print(contents);
      pr.hide();
      //  parseJwt(contents);


      //Missing credentials
      if(contents.contains("Missing credentials")){
        print("Missing credentials");
        ToastUtils.showCustomToast(context, "Missing credentials",false);

      }
     if(contents.contains("Invalid password")){
       print("Invalid password");
       ToastUtils.showCustomToast(context, "Invalid password",false);


     }
      if(contents.contains("Username not found")){
        print("Username not found");
        ToastUtils.showCustomToast(context, "Username not found",false);


      }

      if(!contents.contains("Username not found")&&!contents.contains("Invalid password")&&!contents.contains("Missing credentials")){

        Map<String,dynamic> attributeMap = new Map<String,dynamic>();
        attributeMap=parseJwt(contents);

       // print(attributeMap);

         DriverID = attributeMap['DriverID'] ;
         ProfilePhotoURL =  attributeMap["ProfilePhotoURL"] ;
         Username = attributeMap["Username"] ;
         Password = attributeMap["Password"] ;
         PhoneNumber = attributeMap["PhoneNumber"] ;
         FirstName = attributeMap["FirstName"] ;
         LastName = attributeMap["LastName"] ;
         Nationality = attributeMap["Nationality"] ;
         Email = attributeMap["Email"] ;
         Gender = attributeMap["Gender"] ;
         DateOfBirth = attributeMap["DateOfBirth"] ;
         Address = attributeMap["Address"] ;
         Active = attributeMap['Active'] ;



         if(attributeMap["Truck"]!=null) {

          print(attributeMap["Truck"]);




           Map<String, dynamic> TrucksMap = new Map<String, dynamic>.from(attributeMap["Truck"]);

           TruckID = TrucksMap['TruckID'];
           TransportCompanyID = TrucksMap['TransportCompanyID'];
           PlateNumber = TrucksMap["PlateNumber"];
           Owner = TrucksMap["Owner"];
           ProductionYear = TrucksMap['ProductionYear'];
           Brand = TrucksMap["Brand"];
           Model = TrucksMap["Model"];
           Type = TrucksMap["Type"];
           MaximumWeight = TrucksMap['MaximumWeight'];
           TruckPhotoURL = TrucksMap["PhotoURL"];



           Trucks truck = new Trucks.fromJson(attributeMap["Truck"]);

            print(truck.Trailers[0].TrailerPhotoURL);


//           Trailers

         //  print(TrucksMap["Trailers"]);

         //  Map<String, dynamic> TrailersMap = new Map<String, dynamic>.from(TrucksMap["Trailers"]);


         }


    //   saveDate(await SharedPreferences.getInstance());


      }



    });
  }

  void saveDate(SharedPreferences prefs) {
    prefs.setInt('DriverID',DriverID);
    prefs.setString('Username', Username);
    prefs.setString('ProfilePhotoURL', ProfilePhotoURL);
    prefs.setString('Password', Password);
    prefs.setString('PhoneNumber', PhoneNumber);
    prefs.setString('FirstName', FirstName);
    prefs.setString('LastName',LastName);
    prefs.setString('Nationality', Nationality);
    prefs.setString('Email', Email);
    prefs.setString('Gender', Gender);
    prefs.setString('DateOfBirth', DateOfBirth);
    prefs.setString('Address',Address);
    prefs.setInt('Active', Active);



/*
    prefs.setInt('TransportCompanyID', TransportCompanyID);
    prefs.setString('PlateNumber', PlateNumber);
    prefs.setString('Owner', Owner);
    prefs.setInt('ProductionYear', ProductionYear);
    prefs.setString('Brand', Brand);
    prefs.setString('Model',Model);
    prefs.setString('Type', Type);
    prefs.setInt('MaximumWeight', MaximumWeight);
    prefs.setString('TruckPhotoURL', TruckPhotoURL);
*/


  //  print(TruckPhotoURL);


    Userprofile.setDriverID(DriverID);
    Userprofile.setProfileImage(ProfilePhotoURL);
    Userprofile.setUsername(Username);
    Userprofile.setPassword(Password);
    Userprofile.setPhoneNumber(PhoneNumber);
    Userprofile.setFirstName(FirstName);
    Userprofile.setLastName(LastName);
    Userprofile.setNationality(Nationality);
    Userprofile.setEmail(Email);
    Userprofile.setGender(Gender);
    Userprofile.setDateOfBirth(DateOfBirth);
    Userprofile.setAddress(Address);
    Userprofile.setActive(Active);

    if(FirstName==""||LastName==""||Nationality==""||Address==""||Gender=="") {
      Userprofile.setComplete(true);
    }else{
      Userprofile.setComplete(false);
    }


  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NavigationHomeScreen()));


  }
  Map<String, dynamic> parseJwt(String token) {

    final parts = token.split('.');
    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }


  String message = 'Log in/out by pressing the buttons below.';



  final FirebaseAuth auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {




    Widget emailForm = Container(
      margin: EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.account_circle),
       //   Image.asset("assets/icons/user-grey.png", height: 16.0, width: 16.0,),
          Container(
            width: screenWidth(context)*0.7,
            child: TextFormField(
              cursorColor: primaryDark, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
              keyboardType: TextInputType.emailAddress,
              onSaved: (String value) => email = value,
              validator: (String value) {
                if(value.isEmpty)
                  return 'Please Enter Your Username or Email Id';
                else
                  return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none
                ),
                labelText: "Username or Email Id",
              ),
              focusNode: _focusNode,
            ),
          ),
        ],
      ),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: BorderSide(color: _getBorderColor(), style: BorderStyle.solid, width: 2.0),
        ),
      ),
    );

    Widget passwordForm = Container(
      margin: EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.lock),

         // Image.asset("assets/icons/lock-grey.png", height: 16.0, width: 16.0,),
          Container(
            width: screenWidth(context)*0.72,
            child: TextFormField(
              cursorColor: primaryDark, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
                onSaved: (String value) => password = value,
              validator: (String value) {
                if(value.isEmpty)
                  return 'Please Enter Your Password';
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
              focusNode: _focusNode2,
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
          bottom: BorderSide(color: _getBorderColor2(), style: BorderStyle.solid, width: 2.0),
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

          child: Form(
            key: _formKey,
            child: Container(
              alignment: AlignmentDirectional.center,
              margin: EdgeInsets.only(top: 50.0),
              padding: const EdgeInsets.all(16.0),
              child: Column(
             //   padding: const EdgeInsets.all(16.0),

              //  physics: ScrollPhysics(),
                children: <Widget>[
                  Image.asset("assets/icons/logo.png", width: 200.0, height: 180.0, fit: BoxFit.contain,),
                  Container(
                    alignment: AlignmentDirectional.center,
                    padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
                    child: Text("Sign In", style: TextStyle(fontSize: 32),),
                  ),
                  Container(
                    alignment: AlignmentDirectional.center,
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text("Sign In to your naqelapp Account",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.topStart,
                    padding: EdgeInsets.only(left: 16.0, top: 28.0, bottom: 4.0, right: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Email"),
                        SizedBox(height: 10,),
                        emailForm,
                        Text("Password", ),
                        SizedBox(height: 10,),
                        passwordForm,
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Checkbox(
                            activeColor: primaryDark,
                            value: checkRemember,
                            onChanged: (bool value) {
                              setState(() {
                                checkRemember = value;
                              });
                            },
                          ),
                          Text("Remember me",),
                        ],
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => ForgotPassword(),
                            ),);
                        },
                        child: Text("Forgot password?"),
                      )
                    ],
                  ),
                  SizedBox(
                    width:200,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),

                      ),

                      color: primaryDark,
                      onPressed: () async {
                     //   await loginUser();
                        signin();
                      },
                      child: Text( "SIGN IN",style: TextStyle(color: Colors.white),),
                    ),
                  ),

                  RawMaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    onPressed: (){
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUp()));

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Dont't have an Account? ",),
                        Text("Sign up here",style: TextStyle(decoration: TextDecoration.underline,),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
