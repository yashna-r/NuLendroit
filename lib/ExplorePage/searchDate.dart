import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/FavouriteModel.dart';
import 'package:nulendroit/Services/databaseService.dart';
import 'package:nulendroit/Shared/debouncer.dart';
import 'package:provider/provider.dart';

import 'eventList.dart';

class SearchDate extends StatefulWidget {
  @override
  _SearchDateState createState() => _SearchDateState();
}

class _SearchDateState extends State<SearchDate> {

  String _searchKey;
  final dateFormat = DateFormat("EEEE, dd MMM yyyy");
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<FavouriteData>>.value(
      value: DatabaseService().favourites,

      child: StreamProvider<List<EventData>>.value(
        value: DatabaseService().events,

        child:Scaffold(

          appBar: AppBar(
            title: Text('Search by date'),
//            leading: Icon(Icons.location_searching),

          ),

          body: Container(
            child: Column(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  child: DateTimeField(
                    format: dateFormat,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100)
                      );
                    },
                    onChanged: (value) {
                      _searchKey= '';
                      _debouncer.run(() {
                        setState(() {
                          String date = dateFormat.format(value);
                          _searchKey = date;
                        });
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      hintText: 'On which day?',
                      border: UnderlineInputBorder(),//InputBorder.none,
                      prefixIcon: Icon(Icons.date_range, size: 25.0,),
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
