import 'dart:io';

import 'package:Doorstep/screens/home/home_screen.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:Doorstep/styles/styles.dart';
 
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'package:progress_dialog/progress_dialog.dart';



import 'package:http/http.dart' as http;

import '../first-screen.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

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
                      color: index==1 ? Colors.green[900] :index==2 ?Colors.green[800] : index==3 ?Colors.green[700] : index==4 ?
                      Colors.green[600] :index==5 ?Colors.green[500] : index==6 ?Colors.green[400]:
                      index==1 ?Colors.green[300] : index==1 ?Colors.green[200] : index==1 ?Colors.green[100] : index==1 ?
                      Colors.green[100] :index==1 ?Colors.green[100] :Colors.green[900]
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


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool checkRemember = true;
  bool showText = true;

  FocusNode _focusNode, _focusNode2;

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }
  Dialog loadingdialog;
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
  String mobilenumber;




  String message = 'Log in/out by pressing the buttons below.';

  @override
  Widget build(BuildContext context) {

    Widget mobile  = Container(
      margin: EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.phone_android),
          Text(" +92",style: TextStyle(fontSize: 15),),
          Container(
            width: screenWidth(context)*0.5,
            child: TextFormField(
              cursorColor: Colors.black, cursorRadius: Radius.circular(1.0), cursorWidth: 1.0,
              keyboardType: TextInputType.number,
              onSaved: (String value) {
                mobilenumber = value;
                mobilenumber = "+92"+ mobilenumber;
              },
              validator: (String value) {
                if(value.length != 10)
                  return 'Please enter correct Phone Number';
                else
                  return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none
                ),
                labelText: "Phone Number",
              ),
              focusNode: _focusNode,
            ),
          ),
        ],
      ),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: _focusNode.hasFocus ? BorderSide(color: Colors.black, style: BorderStyle.solid, width: 2.0) :
          BorderSide(color: Colors.black.withOpacity(0.7), style: BorderStyle.solid, width: 1.0),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,

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
                    child: Text("Welcome", style: TextStyle(fontSize: 32),),
                  ),
                  Container(
                    alignment: AlignmentDirectional.center,
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text("Lets get started with your Doorstep Account",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 50,),

                  Container(
                    alignment: AlignmentDirectional.topStart,
                    padding: EdgeInsets.only(left: 16.0, top: 28.0, bottom: 4.0, right: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20,),
                        mobile,
//                        Text("Password", ),
//                        SizedBox(height: 10,),
//                        passwordForm,
                      ],
                    ),
                  ),

//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      Row(
//                        children: <Widget>[
//                          Checkbox(
//                            activeColor: primaryDark,
//                            value: checkRemember,
//                            onChanged: (bool value) {
//                              setState(() {
//                                checkRemember = value;
//                              });
//                            },
//                          ),
//                          Text("Remember me",),
//                        ],
//                      ),
//                      FlatButton(
//                        onPressed: (){
//                          ToastUtils.showCustomToast(context, "Under Development \n Use existing account to login", null);
//
//                       //   Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ForgotPassword(), ),);
//                        },
//                        child: Text("Forgot password?"),
//                      )
//                    ],
//                  ),
                  SizedBox(height: 50,),

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
                      child: Text( " Sign In",style: TextStyle(color: Colors.white),),
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

  Future<void> signin() async {
    final FormState form = _formKey.currentState;
    form.save();
     if (!form.validate()) {
      return;
    }

    phoneAuth(mobilenumber);


  }


  FirebaseUser userD;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn googleSignIn = GoogleSignIn();
  //
  // Future<String> signInWithGoogle() async {
  //   final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //   await googleSignInAccount.authentication;
  //
  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: googleSignInAuthentication.accessToken,
  //     idToken: googleSignInAuthentication.idToken,
  //   );
  //
  //   final AuthResult authResult = await _auth.signInWithCredential(credential);
  //   final FirebaseUser user = authResult.user;
  //
  //   assert(!user.isAnonymous);
  //   assert(await user.getIdToken() != null);
  //
  //   final FirebaseUser currentUser = await _auth.currentUser();
  //   assert(user.uid == currentUser.uid);
  //   userD=user;
  //   return 'signInWithGoogle succeeded: $user';
  // }

  TextEditingController _controllerCode = TextEditingController();

  bool ids=false;
  phoneAuth(String phone) async {

  //  showLoadingDialogue("Loading");
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
         // hideLoadingDialogue();

          if(ids) {
            Navigator.of(context).pop();

          }
          final AuthResult authResult = await _auth.signInWithCredential(credential);
          final FirebaseUser user = authResult.user;

          DataStream.user=user;
          DataStream.UserId=user.uid;
          DataStream.PhoneNumber=user.phoneNumber;
         // hideLoadingDialogue();

          ToastUtils.showCustomToast(context, "Phone Verified",true);


          FirebaseDatabase database = new FirebaseDatabase();
          DatabaseReference db = database.reference()
              .child('Users').child(DataStream.UserId);

          db.set(<dynamic, dynamic>{
            'first_name': "",
            'last_name': "",
            'phone': user.phoneNumber,
            'email': "",
            'userTokenID':DataStream.userTokenID,

          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SplashScreen()));


        },
        verificationFailed: (AuthException exception) {

          print(exception.message);

          ToastUtils.showCustomToast(context, "Error! Try Again Later",false);

        //  hideLoadingDialogue();
        },
        codeSent: (String verification, [int forceResendingToken]) {
          ids=true;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  title: Text(

                    'We have sent an SMS to \n ${mobilenumber} \n\n To complete the phone verification, please enter the 6-digit activation code',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300 ),
                  ),

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
                              borderRadius: BorderRadius.circular(5.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                      )
                    ],
                  ),
                  actions: <Widget>[

                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                          child: Text("Confirm")),
                      textColor: Colors.white,
                      color: Colors.green,
                      onPressed: () async {

                        try {
                          final code = _controllerCode.text.trim();
                          AuthCredential credential =
                          PhoneAuthProvider.getCredential(
                              verificationId: verification, smsCode: code);
                          AuthResult result =
                          await _auth.signInWithCredential(credential).then((
                              value) {
                            FirebaseUser user = value.user;
                            if (user != null) {
                              ToastUtils.showCustomToast(
                                  context, "Code Confirmed", true);
                              Navigator.of(context).pop();

                              DataStream.user=user;
                              DataStream.UserId=user.uid;
                              DataStream.PhoneNumber=user.phoneNumber;

                              FirebaseDatabase database = new FirebaseDatabase();
                              DatabaseReference db = database.reference()
                                  .child('Users').child(DataStream.UserId);

                              db.set(<dynamic, dynamic>{
                                'first_name': "",
                                'last_name': "",
                                'phone': user.phoneNumber,
                                'email': "",


                              });
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SplashScreen()));


                            } else {
                              _controllerCode.clear();
                              ToastUtils.showCustomToast(
                                  context, "Code Mismatched", false);
                            }
                            return null;
                          });
                        }catch(e){
                          print(e);
                          _controllerCode.clear();

                          ToastUtils.showCustomToast(context, "Error! try again",false);
                          Navigator.of(context).pop();

                        }


                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }




}
