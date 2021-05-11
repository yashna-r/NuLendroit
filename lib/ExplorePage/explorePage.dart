import 'package:flutter/material.dart';
import 'package:nulendroit/ExplorePage/searchCategory.dart';
import 'package:nulendroit/ExplorePage/searchDate.dart';
import 'package:nulendroit/ExplorePage/searchLocation.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: true,

        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: <Widget>[

              Text('Search for events by:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),

              SizedBox(height: 30.0,),

              /*------------------Location button------------------*/
              SizedBox(
                height: 60.0,
//                  width: 200.0,
                child: RaisedButton(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 12.0),
                    color: Colors.teal[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius
                            .circular(30.0)
                    ),

                    onPressed: navigateToLocation,
                    child: Text("Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    )
                ),
              ),


              /*------------------Category button------------------*/
              SizedBox(
                height: 60.0,
//                  width: 200.0,
                child: RaisedButton(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 12.0),
                    color: Colors.teal[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius
                            .circular(30.0)
                    ),

                    onPressed: navigateToCategory,
                    child: Text("Category",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    )
                ),
              ),

              /*------------------Date button------------------*/
              SizedBox(
                height: 60.0,
//                  width: 200.0,
                child: RaisedButton(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 12.0),
                    color: Colors.teal[400],
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius
                            .circular(30.0)
                    ),

                    onPressed: navigateToDate,
                    child: Text("Date",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    )
                ),
              ),

            ],
          ),
        )

    );
  }

  void navigateToLocation() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => SearchLocation(), fullscreenDialog: true));
  }

  void navigateToCategory() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => SearchCategory(), fullscreenDialog: true));
  }

  void navigateToDate() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => SearchDate(), fullscreenDialog: true));
  }
}
