import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/FavouriteModel.dart';
import 'package:nulendroit/ExplorePage/eventList.dart';
import 'package:nulendroit/MyEventsPage/myEventsList.dart';
import 'package:nulendroit/Services/databaseService.dart';
import 'package:provider/provider.dart';

class MyEventsPage extends StatefulWidget {
  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<FavouriteData>>.value(
      value: DatabaseService().favourites,

      child: StreamProvider<List<EventData>>.value(
        value: DatabaseService().events,

        child:Scaffold(

          body: Container(
            child: Column(
              children: <Widget>[

                Expanded(
                  child:  MyEventsList(),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
