import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/FavouriteModel.dart';
import 'package:nulendroit/ProfilePage/userFavList.dart';
import 'package:nulendroit/Services/databaseService.dart';
import 'package:provider/provider.dart';

class EventTab extends StatefulWidget {
  @override
  _EventTabState createState() => _EventTabState();
}

class _EventTabState extends State<EventTab> {

  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);

    return StreamProvider<List<EventData>>.value(
      value: DatabaseService().events,

      child: StreamProvider<List<FavouriteData>>.value(
        value: DatabaseService().favourites,

        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          child: UserFavList(),

        ),
      ),
    );

  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }
}