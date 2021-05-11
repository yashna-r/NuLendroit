import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/ExplorePage/eventTile.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';


class MyEventsList extends StatefulWidget {
  @override
  _MyEventsListState createState() => _MyEventsListState();
}

class _MyEventsListState extends State<MyEventsList> {

  String currentUser;

  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);

    final events = Provider.of<List<EventData>>(context) ?? [];
    List<EventData> myEvents;

    User user = Provider.of<User>(context);
    setState(() {
      currentUser = user.uid;
    });

    setState(() {
      myEvents = events.where((event) => event.createdBy == currentUser).toList();
    });

    if (myEvents != null) {

      return ListView.builder(
          itemCount: myEvents.length,
          itemBuilder: (context, index) {
            return EventTile(event: myEvents[index]);
          });

    }else {
      return Loading();
    }
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }
}

