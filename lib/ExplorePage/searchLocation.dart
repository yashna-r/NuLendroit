import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/FavouriteModel.dart';
import 'package:nulendroit/Services/databaseService.dart';
import 'package:nulendroit/Shared/debouncer.dart';
import 'package:provider/provider.dart';

import 'eventList.dart';

class SearchLocation extends StatefulWidget {
  @override
  _SearchLocationState createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {

  String _searchKey;
  final _debouncer = Debouncer(milliseconds: 500);


  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<FavouriteData>>.value(
      value: DatabaseService().favourites,

      child: StreamProvider<List<EventData>>.value(
        value: DatabaseService().events,

        child:Scaffold(

          appBar: AppBar(
            title: Text('Search by location'),
//            leading: Icon(Icons.location_searching),

          ),

          body: Container(
            child: Column(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  child: TextFormField(
                    onChanged: (value) {
                      _debouncer.run(() {
                        setState(() {
                          _searchKey = value;
                        });
                      });
                    },
                    decoration: InputDecoration(
                      //contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      hintText: 'Location',
                      border: UnderlineInputBorder(),
                      prefixIcon: Icon(Icons.location_searching, size: 30.0,),

                    ),
                  ),
                ),

                Expanded(
                  child:  _searchKey != null ? EventList(query: _searchKey) : EventList(),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
