import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/PostModel.dart';
import 'package:nulendroit/EventPage/postList.dart';
import 'package:nulendroit/Services/databaseService.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {

  @override
  Widget build(BuildContext context) {

    return StreamProvider<List<Post>>.value(
        value: DatabaseService().posts,

        child: Scaffold(
          resizeToAvoidBottomInset: false,

          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: PostList(),
          ),

        )
    );

  }
}
