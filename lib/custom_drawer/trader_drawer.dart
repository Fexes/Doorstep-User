import 'dart:async';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:naqelapp/models/driver/Trucks.dart';
import 'package:naqelapp/utilts/DataStream.dart';
import 'package:naqelapp/models/driver/DriverProfile.dart';
import 'package:naqelapp/styles/app_theme.dart';
import 'package:naqelapp/screens/auth/sign-in.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TraderHomeDrawer extends StatefulWidget {
  const TraderHomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _TraderHomeDrawerState createState() => _TraderHomeDrawerState();
}

class _TraderHomeDrawerState extends State<TraderHomeDrawer> {
  List<DrawerList> drawerList;

  bool isDriverProfilecomplete=false;

  @override
  void initState() {
    setdDrawerListArray();


    //   istruckprofilecomplete = Trucks.isComplete();
     //  isDriverProfilecomplete = DriverProfile.isComplete();

    super.initState();
  }


  void setdDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.JOBS,
        labelName: 'Jobs',
        icon: Icon(Icons.work),
      ),
      DrawerList(

        index: DrawerIndex.PROFILE,
        labelName: 'Profile',
        icon: Icon(Icons.account_circle),
      ),
      DrawerList(
        index: DrawerIndex.PAYMENTS,
        labelName: 'Payments',
        icon: Icon(Icons.attach_money),
      ),


    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child:!isDriverProfilecomplete? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        AnimatedBuilder(
                          animation: widget.iconAnimationController,
                          builder: (BuildContext context, Widget child) {
                            return ScaleTransition(
                              scale: AlwaysStoppedAnimation<double>(
                                  1.0 - (widget.iconAnimationController.value) * 0.2),
                              child: RotationTransition(
                                turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                    begin: 0.0, end: 24.0)
                                    .animate(CurvedAnimation(
                                    parent: widget.iconAnimationController,
                                    curve: Curves.fastOutSlowIn))
                                    .value /
                                    360),
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: AppTheme.grey.withOpacity(0.6),
                                          offset: const Offset(2.0, 4.0),
                                          blurRadius: 8),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(60.0)),
                                    child: DataStream.traderProfile.PhotoURL==null ? Icon(Icons.account_circle,color: Colors.grey,size: 0,) :  Image.network(DataStream.traderProfile.PhotoURL,fit: BoxFit.cover)
                                    ,

                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 20,),
                        Column(children: <Widget>[
                          Icon(Icons.error,color: Colors.amber[500],size: 50,),
                          Container(
                            width: 130,
                            child: Text(
                              "Incomplete Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.amber[900],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),

                        ],),

                      ],
                    ):
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: widget.iconAnimationController,
                          builder: (BuildContext context, Widget child) {
                            return ScaleTransition(
                              scale: AlwaysStoppedAnimation<double>(
                                  1.0 - (widget.iconAnimationController.value) * 0.2),
                              child: RotationTransition(
                                turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                    begin: 0.0, end: 24.0)
                                    .animate(CurvedAnimation(
                                    parent: widget.iconAnimationController,
                                    curve: Curves.fastOutSlowIn))
                                    .value /
                                    360),
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: AppTheme.grey.withOpacity(0.6),
                                          offset: const Offset(2.0, 4.0),
                                          blurRadius: 8),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(60.0)),
                                    child: DataStream.traderProfile.PhotoURL==null ? Icon(Icons.account_circle,color: Colors.grey,size: 0,) :  Image.network(DataStream.traderProfile.PhotoURL,fit: BoxFit.cover)
                                    ,

                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 10,),
                        Column(

                          children: <Widget>[
                          !isDriverProfilecomplete?Icon(Icons.error,color: Colors.amber[500],size: 50,):SizedBox(width: 0,),


                        ],),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 18, left: 4),
                    child: Text(
                      DataStream.traderProfile.Username,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.grey,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 4),
                    child: Text(
                      DataStream.traderProfile.Email,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 4),
                    child:DataStream.traderProfile.Active==0? Row(
                      children: <Widget>[
                        Icon(Icons.warning,color: Colors.red,size: 20,),
                        SizedBox(width: 5),
                        Text(
                          "Account Not Verified",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],

                    ): Row(
                      children: <Widget>[
                        Icon(Icons.verified_user,color: Colors.green,size: 20,),
                        SizedBox(width: 5),
                        Text(
                          "Account Verified",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                            fontSize: 14,
                          ),
                        ),
                      ],

                    )
                  ),




                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () {

                  SignOut();

                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                     decoration: BoxDecoration(
                       color: widget.screenIndex == listData.index
                           ? Colors.blue
                           : Colors.transparent,
                       borderRadius: new BorderRadius.only(
                         topLeft: Radius.circular(0),
                         topRight: Radius.circular(16),
                         bottomLeft: Radius.circular(0),
                         bottomRight: Radius.circular(16),
                       ),
                     ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.blue
                                  : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? Colors.blue
                              : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
  ProgressDialog pr;
  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }

  Future<void> SignOut() async {

    pr = new ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: true);
    pr.style(
        message: 'Loging Out',
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



    DefaultCacheManager manager = new DefaultCacheManager();
    manager.emptyCache();

    onDoneLoading();

  }

  onDoneLoading() async {
    pr.hide();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
  }

}

enum DrawerIndex {
  JOBS,
  PROFILE,
  PAYMENTS,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
