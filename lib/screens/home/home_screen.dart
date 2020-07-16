import 'dart:io';

import 'package:Doorstep/models/Shops.dart';
import 'package:Doorstep/screens/home/shops_screen.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Doorstep/utilts/UI/toast_utility.dart';
import 'package:flutter/material.dart';
import 'package:Doorstep/styles/styles.dart';
import 'package:Doorstep/screens/auth/sign-up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode, utf8;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';



import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<Home> {

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



  @override
  void dispose() {
    super.dispose();

  }
  Dialog loadingdialog;
  @override
  Future<void> initState()  {
    super.initState();


  }
  static String catagory = "";


  int _selectedIndex = 0;

  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList.map((item) => Container(
      child: Container(
      //  margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Stack(
              children: <Widget>[
                Image.network(item, fit: BoxFit.cover, width: 1000.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),

                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//                    child: Text(
//                      'No. ${imgList.indexOf(item)} image',
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 20.0,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    )).toList();
     Widget HomeScreen  = Center(

      child:
      Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Column(
                children: [
                  CarouselSlider(
                    items: imageSliders,
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.map((url) {
                      int index = imgList.indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ]
            ),
            Flexible(
              flex: 1,
              child: ListView(
                children: [

                  Row(
                    children: [


                      GestureDetector(
                        onTap: (){
                          catagory="Supermarkets";
                          Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),);

                        },
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            height: 170,
                            width: ((screenWidth(context)/2))-15,

                            decoration: BoxDecoration(

                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/imgs/super_market.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child:  Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(

                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  gradient: new LinearGradient(
                                      colors: [
                                        Colors.black,
                                        const Color(0x10000000),
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(0.0, 1.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Supermarkets',
                                        style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
                                      ),
                                      Text(
                                        'Groceries made easy',
                                        style: TextStyle( fontSize: 16, fontWeight: FontWeight.w200,color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ), /* add child content here */
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          catagory="Butchery & BBQ";
                          Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),);

                        },
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            height: 170,
                            width: ((screenWidth(context)/2))-15,


                            decoration: BoxDecoration(

                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/imgs/bbq.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child:  Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(

                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  gradient: new LinearGradient(
                                      colors: [
                                        Colors.black,
                                        const Color(0x10000000),
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(0.0, 1.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Butchery & BBQ',
                                        style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
                                      ),
                                      Text(
                                        'The place to meet',
                                        style: TextStyle( fontSize: 16, fontWeight: FontWeight.w200,color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ), /* add child content here */
                          ),
                        ),
                      ),

                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      catagory="Fruits & Vegetables";
                      Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),);

                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        height: 170,


                        decoration: BoxDecoration(

                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          image: DecorationImage(
                            image: AssetImage("assets/imgs/grocery_store.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child:  Padding(
                          padding: EdgeInsets.all(0),
                          child: Container(

                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              gradient: new LinearGradient(
                                  colors: [
                                    Colors.black,
                                    const Color(0x10000000),
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(0.0, 1.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fruits & Vegetables',
                                    style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
                                  ),
                                  Text(
                                    'Fresher and better',
                                    style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300,color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ), /* add child content here */
                      ),
                    ),
                  ),

                  Row(

                    children: [
                      GestureDetector(
                        onTap: (){
                          catagory="Tandoor";
                          Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),);

                        },
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            height: 170,
                            width: ((screenWidth(context)/2))-15,



                            decoration: BoxDecoration(

                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/imgs/naan.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child:  Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(

                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  gradient: new LinearGradient(
                                      colors: [
                                        Colors.black,
                                        const Color(0x10000000),
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(0.0, 1.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tandoor',
                                        style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
                                      ),
                                      Text(
                                        'Fresh Naan',
                                        style: TextStyle( fontSize: 16, fontWeight: FontWeight.w200,color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ), /* add child content here */
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          catagory="Dairy";
                          Navigator.push( context, MaterialPageRoute( builder: (BuildContext context) => ShopsScreen(),),);

                        },
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            height: 170,
                            width: ((screenWidth(context)/2))-15,


                            decoration: BoxDecoration(

                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              image: DecorationImage(
                                image: AssetImage("assets/imgs/dairy.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child:  Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(

                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  gradient: new LinearGradient(
                                      colors: [
                                        Colors.black,
                                        const Color(0x10000000),
                                      ],
                                      begin: const FractionalOffset(0.0, 0.0),
                                      end: const FractionalOffset(0.0, 1.0),
                                      stops: [0.0, 1.0],
                                      tileMode: TileMode.clamp),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Dairy',
                                        style: TextStyle( fontSize: 22, fontWeight: FontWeight.w500,color: Colors.white),
                                      ),
                                      Text(
                                        'Fresh Dairy Products',
                                        style: TextStyle( fontSize: 16, fontWeight: FontWeight.w200,color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ), /* add child content here */
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),



    );
     Widget OrdersScreen  =Center(
      child: Container(
        child:  Text(
          'Index 1: OrdersScreen',
          style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
     Widget ProfileScreen  =Center(
      child: Container(
        child:  Text(
          'Index 1: ProfileScreen',
          style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );


    return Scaffold(
      appBar: AppBar(
        title: const Text('Doorstep'),
        automaticallyImplyLeading: false,
      ),
      body:


      _selectedIndex==0? HomeScreen:
      _selectedIndex==1?OrdersScreen:ProfileScreen,

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airport_shuttle),
            title: Text('Orders'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}

