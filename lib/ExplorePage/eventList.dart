import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/ExplorePage/eventTile.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class EventList extends StatefulWidget {

  final String query;
  EventList({this.query});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {

  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);

    String query = widget.query;

    final events = Provider.of<List<EventData>>(context) ?? [];
    List<EventData> searchResults = events;

    if(query != null) {
      setState(() {
        searchResults = events.where((event) =>
        event.location.toLowerCase().contains(query.toLowerCase()) ||
            event.date.toLowerCase().contains(query.toLowerCase()) ||
            event.category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

    if (searchResults != null) {

        return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return EventTile(event: searchResults[index]);
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
