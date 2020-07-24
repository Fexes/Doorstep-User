import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Doorstep/screens/home/home_screen.dart';
import 'package:Doorstep/utilts/UI/DataStream.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:Doorstep/styles/styles.dart';
import 'package:Doorstep/screens/auth/sign-in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  String username;
  String email;
  String password;
  String password2;

  var errorText;

  final databaseReference = Firestore.instance;




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



    return Scaffold(
      backgroundColor: Colors.white,
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


                                SignUpUser();
                              //  phoneAuth(phoneNo);
                               },
                              child: Text( "SIGN UP",style: TextStyle(color: Colors.white),),
                            ),
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


                                    FirebaseDatabase database = new FirebaseDatabase();
                                    DatabaseReference _userRef=database.reference().child('users').child(userD.uid);

                                    _userRef.set(<String, String>{
                                      "name": "" + userD.displayName.toString(),
                                      "email": "" + userD.email.toString(),
                                      "image": "" + userD.photoUrl.toString(),
                                      "mobile": "" + userD.phoneNumber.toString(),
                                    }).then((_) {
                                      print('User Created.');
                                    });

                                  Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => Home()));
                                  }else{
                                    ToastUtils.showCustomToast(context, "Sign up Failed", false);
                                  }
                                });

                                //  phoneAuth(phoneNo);
                              },
                              child: Text( "SIGN UP with Google",style: TextStyle(color: Colors.white),),
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

  Future<void> SignUpUser() async {

    final FormState form = _formKey.currentState;
    form.save();

    if (!form.validate()) {
      return;
    }
    if(password!=password2){
      ToastUtils.showCustomToast(context, "Password Mismatch", false);
      return;
    }

    //  print(password);

     await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {



         FirebaseDatabase database = new FirebaseDatabase();
         DatabaseReference _userRef=database.reference().child('users').child(value.user.uid);

         _userRef.set(<String, String>{
           "name": "" + username,
           "email": "" + email,
           "image": "" + userD.photoUrl.toString(),
           "mobile": "" + userD.phoneNumber.toString(),
         }).then((_) {
           print('User Created.');
           DataStream.UserId=userD.uid;

           Navigator.of(context).pushReplacement(
               MaterialPageRoute(
                   builder: (context) => Home()));
         });

     });



  }
}
