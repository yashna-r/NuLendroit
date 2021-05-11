/*
* author YR
* NuLendroit application
*
* This page builds the bottom navigation bar and drawer
* used in the main page of the application
*
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nulendroit/MainPages/createEvent.dart';
import 'package:nulendroit/MainPages/help.dart';
import 'package:nulendroit/MainPages/welcome.dart';
import 'package:nulendroit/HomePage/homePage.dart';
import 'package:nulendroit/ExplorePage/explorePage.dart';
import 'package:nulendroit/EventPage/eventPage.dart';
import 'package:nulendroit/MyEventsPage/myEventsPage.dart';
import 'package:nulendroit/NotificationPage/notificationPage.dart';
//import 'package:nulendroit/NotificationPage/notificationPage.dart';
import 'package:nulendroit/ProfilePage/profilePage.dart';
import 'package:nulendroit/Services/authService.dart';

class MainPage extends StatefulWidget {

//  int selectedIndex;
//  MainPage({this.selectedIndex});

  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> {

  final AuthService _auth = AuthService();

  //List of Page Widgets for bottom navigation bar
  int _currentIndex = 0 ;
  final List<Widget> _children =[
    HomePage(),
    ExplorePage(),
    EventPage(),
    MyEventsPage(),
    ProfilePage(),

  ];

  //List of titles for appBar
  final List<String> _title =[
    'NuLendroit',
    'Explore',
    'Recent Events',
    'My Events',
    'Profile',

  ];

  void onTappedBar(int index) {

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

//    _currentIndex = widget.selectedIndex;

    final TextStyle display1 = Theme.of(context).textTheme.display1;

    return WillPopScope(
      onWillPop: () async {
         return new Future(() => false);
      },

      child: Scaffold(

        appBar: new AppBar(
          title: Text(_title[_currentIndex]),

        ),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[

              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
                child: Text(
                  'NuLendroit',
                  style: GoogleFonts.bahianita(
                    textStyle: display1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 46.0,
                    letterSpacing: 0.5,
                  ),

                ),
              ),

              //Create event
              ListTile(
                leading: Icon(Icons.playlist_add),
                title: Text('Create event',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEvent()));
                },
              ),

              //Help information
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage()));
                },
              ),

              //Logout
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                onTap: () async {
                  await _auth.signOut();
//                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomePage(), fullscreenDialog: true));
                },
              ),

            ],
          ),
        ),

        body: _children[_currentIndex],

        // declares icons and titles for each item in navigation bar
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTappedBar,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white24,

          items:[
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text("Home"),
              backgroundColor: Colors.purple,
            ),

            BottomNavigationBarItem(
              icon: new Icon(Icons.explore),
              title: new Text("Explore"),
              backgroundColor: Colors.purple,
            ),

            BottomNavigationBarItem(
              icon: new Icon(Icons.public),
              title: new Text("Recent Events"),
              backgroundColor: Colors.purple,
            ),

            BottomNavigationBarItem(
              icon: new Icon(Icons.event),
              title: new Text("My Events"),
              backgroundColor: Colors.purple,
            ),

            BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              title: new Text("Profile"),
              backgroundColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

}

