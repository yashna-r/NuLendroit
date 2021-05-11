import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nulendroit/MainPages/mainPage.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text('Help'),
          leading: Icon(Icons.help_outline, size: 30.0,),
        ),


        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30.0,horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Center(
                  child: Text("How to use NuLendroit?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(height: 20.0,),

                ListTile(
                  title: Text('On the home page, you will find events recommended for you'),
                  leading: Icon(Icons.home),
                ),

                SizedBox(height: 20.0,),

                ListTile(
                    title: Text('To navigate through the pages, use the bottom navigation bar'),
                  leading: Icon(Icons.navigation),
                ),

                SizedBox(height: 20.0,),

                ListTile(
                  title: Text("To search for events, go to the Explore page and choose Search criteria. Then enter the keyword."),
                  leading: Icon(Icons.explore),
                ),

                SizedBox(height: 20.0,),

                ListTile(
                  title: Text("To view posts for recent events, go to the Recent Events page"),
                  leading: Icon(Icons.public),
                ),

                SizedBox(height: 20.0,),

                ListTile(
                  title: Text("To view events you created, go to My Events page"),
                  leading: Icon(Icons.event),
                ),

                SizedBox(height: 20.0,),

                ListTile(
                  title: Text('Tap on the menu icon at the top-left corner of the main pages to create an event, view help, or logout.'),
                  leading: Icon(Icons.menu),
                ),

                SizedBox(height: 20.0,),

                ListTile(
                  title: Text('To save or unsave an event, tap on the favourite button on the event tile'),
                  leading: Icon(Icons.favorite_border),
                ),

                SizedBox(height: 20.0,),

                ListTile(
                  title: Text('To edit an event, open the event info page by tapping on the event tile and tap on the edit button'),
                  leading: Icon(Icons.edit),
                ),

                SizedBox(height: 20.0,),

                ListTile(
                  title: Text("To delete an event, tap on the delete button on the Event tile"),
                  leading: Icon(Icons.delete),
                ),

                SizedBox(height: 20.0,),

                ListTile(
                  title: Text("To create a post, go on the post tab on the profile page and tap on the 'Create Post' button"),
                  leading: Icon(Icons.image),
                ),

                SizedBox(height: 20.0,),

                ListTile(
                  title: Text("To delete a post, tap on the delete button on the Post tile"),
                  leading: Icon(Icons.clear),
                ),

                SizedBox(height: 20.0,),

                ListTile(
                  title: Text('To edit your personal info, tap on the edit button on the profile page'),
                  leading: Icon(Icons.edit),
                ),

                SizedBox(height: 30.0,),

                RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                  color: Colors.teal[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25.0)
                  ),

                  child: Text('Got it'),
                  onPressed: moveToMainPage,


                )

              ],

            ),
          ),
        )
    );
  }

  void moveToMainPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }
}
