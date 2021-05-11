import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/ProfilePage/editProfile.dart';
import 'package:nulendroit/ProfilePage/createPost.dart';
import 'package:nulendroit/ProfilePage/eventTab.dart';
import 'package:nulendroit/ProfilePage/postTab.dart';
import 'package:nulendroit/Services/databaseService.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {

  final editFormKey = new GlobalKey<FormState>();
  File sampleImage;
  String currentUser;
  String currentUserID;
  ScrollController _scrollViewController;
  TabController _tabController;
  UserData userData;

  @override
  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    currentUserID = user.uid;

    return StreamBuilder<UserData>(
        stream: DatabaseService(userId: currentUserID).userData,
        builder: (context, snapshot) {

          if(snapshot.hasData){
            userData = snapshot.data;
            currentUser = userData.username;

            return new Scaffold(
              body: new NestedScrollView(
                controller: _scrollViewController,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) { //<-- headerSliverBuilder
                  return <Widget>[
                    new SliverAppBar(
                      expandedHeight: 240.0,
                      pinned: true, //<-- pinned to true
                      floating: true, //<-- floating to true
                      forceElevated: innerBoxIsScrolled, //<-- forceElevated to innerBoxIsScrolled

                      actions: <Widget>[
                        IconButton(
                          icon: new Icon(Icons.edit),
                          onPressed: _editProfilePanel,
                        ),

                      ],

                      flexibleSpace: FlexibleSpaceBar(
                        background: SafeArea(
                          child: Container(
                            color: Colors.purple[100],

                            child: Column(
                              children: <Widget>[

                                /*---------------User image---------------*/
                                Padding(
                                  padding: EdgeInsets.only(top: 15.0, bottom: 5.0 ), //symmetric(vertical: 40.0),
                                  child: Center(
                                      child:Container(
                                        width: 140.0,
                                        height: 140.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(80.0),
                                          border: Border.all(
                                            color:Colors.white,
                                            width:5.0,
                                          ),
                                        ),

                                        child:
                                        userData.userImgURL == null ?
                                        CircleAvatar(
                                          backgroundImage: AssetImage('assets/images/user.png'),
                                        ):
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(userData.userImgURL, scale: 1.0),
                                        ),
                                      )
                                  ),
                                ),


                                /*---------------Username---------------*/
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                    child: Center(
                                      child: Text(
                                        currentUser,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),

                      bottom: new TabBar(
                        tabs: <Tab>[
                          Tab(icon: Icon(Icons.photo),),
                          Tab(icon: Icon(Icons.favorite),),
                        ],
                        controller: _tabController,
                      ),

                    ),
                  ];
                },
                body: new TabBarView(
                  children: <Widget>[
                    PostTab(),
                    EventTab(),
                  ],
                  controller: _tabController,
                ),
              ),

            );
          }else{
            return Loading();
          }
        }
    );
  }

/*---------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------METHODS----------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------*/

  /*------------------Edit profile panel------------------*/
  void _editProfilePanel() {
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) {

      return Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        child: EditProfile(userData: userData,),
      );
    });
  }

  /*------------------Navigate to create post page------------------*/
  void createPost(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostPage()));
  }

}

