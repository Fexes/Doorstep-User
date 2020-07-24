import 'dart:io';

import 'package:Doorstep/screens/home/home_screen.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:Doorstep/styles/styles.dart';
import 'package:Doorstep/screens/auth/sign-up.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'package:progress_dialog/progress_dialog.dart';



import 'package:http/http.dart' as http;

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




  String message = 'Log in/out by pressing the buttons below.';

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
                  return 'Please Enter Your Username or Phone Number';
                else
                  return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0, bottom: 12.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none
                ),
                labelText: "Username or Phone Number",
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
                    child: Text("Sign In", style: TextStyle(fontSize: 32),),
                  ),
                  Container(
                    alignment: AlignmentDirectional.center,
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text("Sign In to your Doorstep Account",
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
                          ToastUtils.showCustomToast(context, "Under Development \n Use existing account to login", null);

                       //   Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ForgotPassword(), ),);
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

                  Text( "OR",style: TextStyle(color: Colors.black),),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 12.0),
                    child: SizedBox(
                      width: 200,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),

                        ),

                        color: primaryDark,
                        onPressed: () async {
                          //     await registerUser();
                          signInWithGoogle().whenComplete(() {


                            if(userD!=null) {

                              print(userD.email);
                              print(userD.displayName);
                              print(userD.uid);

                          //    Navigator.of(context).pop();

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => Home()));
                            }else{
                              ToastUtils.showCustomToast(context, "Sign In Failed", false);
                            }
                          });

                          //  phoneAuth(phoneNo);
                        },
                        child: Text( "SIGN IN with Google",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),


                  RawMaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    onPressed: (){

                     //  ToastUtils.showCustomToast(context, "Under Development \n Use existing account to login", null);

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

  Future<void> signin() async {
    final FormState form = _formKey.currentState;
    form.save();
   // showLoadingDialogue("Signing In");

  //  print(password);
    final firebaseUser = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password).then((value){

         if(value.user.uid!=null) {
           DataStream.UserId=value.user.uid;
            print(value.user.uid);
            Navigator.of(context).pop();

         //   Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => Home(), ),);
           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));

         }
    });

  }


  FirebaseUser userD;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    userD=user;
    return 'signInWithGoogle succeeded: $user';
  }


}
