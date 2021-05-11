import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/ExplorePage/editEvent.dart';
import 'package:nulendroit/MainPages/mainPage.dart';
import 'package:nulendroit/Shared/mapLocation.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class EventInfoPage extends StatefulWidget {

  final EventData event;
  EventInfoPage({this.event});

  @override
  _EventInfoPageState createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {

  final CollectionReference eventCollection = Firestore.instance.collection('events');
  String currentUser;

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    currentUser = user.uid;

    EventData event = widget.event;
    final bottom = MediaQuery
        .of(context)
        .viewInsets
        .bottom;

    if(event != null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,

        appBar: AppBar(
          title: new Text('Event info'),

          actions: <Widget>[
            /*--------------Delete button--------------*/
            Conditional.single(
              conditionBuilder: (BuildContext context) => event.createdBy == currentUser ,
              widgetBuilder: (BuildContext context) =>  IconButton(
                icon: Icon(Icons.delete),
                iconSize: 35.0,
                onPressed: () async {
                  await eventCollection.document(
                      widget.event.eventId).delete();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => MainPage()));


                },
              ),

              fallbackBuilder: (BuildContext context) => Container(), context: null,

            ),
          ],
        ),

        body: SingleChildScrollView(
            reverse: true,
            child: Padding(

                padding: EdgeInsets.only(bottom: bottom),

                child: Container(
                  child: new Column(

                      children: <Widget>[

                        /*------------------Image------------------*/
                        SizedBox(
                          height: 200.0,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: event.imgURL,
                            placeholder: (context, url) =>
                                Loading(),
                            errorWidget: (context, url, error) =>
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/no-image.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ), //Icon(Icons.error),
                                ),
                          ),
                        ),

                        SizedBox(height: 5.0,),

                        /*------------------Title + Category------------------*/
                        ListTile(
                          title: Text(event.eventTitle,
                            style: TextStyle(
                              color: Colors.purple,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(event.category, //eventData.location,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),

                        /*------------------Description------------------*/
                        ListTile(
                          title: Text('Date',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.purple[300],
                            ),
                          ),
                          subtitle: Text(event.date, //eventData.location,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        SizedBox(height: 20.0,),

                        /*------------------Time------------------*/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: <Widget>[
                                  Text('Starts at',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.purple[300],
                                    ),
                                  ),


                                  Text(event.startTime,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: Column(
                                children: <Widget>[
                                  Text('Ends at',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.purple[300],
                                    ),
                                  ),
                                  Text(event.endTime,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],

                        ),

                        SizedBox(height: 20.0,),

                        /*------------------Location------------------*/
                        ListTile(
                          leading: Icon(
                            Icons.location_on,
                            size: 30.0,
                            color: Colors.purple,
                          ),
                          title: Text('Location',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.purple[300],
                            ),
                          ),
                          subtitle: Text(event.location, //eventData.location,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => MapLocation(location: event.location, latitude: event.latitude, longitude: event.longitude,))
                            );
                          },
                        ),

                        /*------------------Organiser------------------*/
                        ListTile(
                          title: Text('Organised by',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.purple[300],
                            ),
                          ),
                          subtitle: Text(event.organiser, //eventData.location,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        /*------------------Description------------------*/
                        ListTile(
                          title: Text('About',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.purple[300],
                            ),
                          ),
                          subtitle: Text(
                            event.description, //eventData.location,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ),

                      ]
                  ),
                )
            )
        ),

        floatingActionButton: Conditional.single(
          conditionBuilder: (BuildContext context) =>
          event.createdBy == currentUser,
          widgetBuilder: (BuildContext context) =>
              FloatingActionButton(
                onPressed:moveToEditEvent,
                child: Icon(Icons.edit),
                backgroundColor: Colors.teal[500],
              ),

          fallbackBuilder: (BuildContext context) => Container(), context: null,
        ),
      );
    }else{
      return Container(
        child: Text('Event not available'),
      );
    }


  }

  void moveToEditEvent() {
    Navigator.push(
    context, MaterialPageRoute(builder: (context) => EditEventInfo(event: widget.event,)));
    }
}
