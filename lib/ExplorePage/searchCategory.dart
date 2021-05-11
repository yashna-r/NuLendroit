import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/FavouriteModel.dart';
import 'package:nulendroit/Services/databaseService.dart';
import 'package:provider/provider.dart';

import 'eventList.dart';

class SearchCategory extends StatefulWidget {
  @override
  _SearchCategoryState createState() => _SearchCategoryState();
}

class _SearchCategoryState extends State<SearchCategory> {

  String _searchKey;


  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<FavouriteData>>.value(
      value: DatabaseService().favourites,

      child: StreamProvider<List<EventData>>.value(
        value: DatabaseService().events,

        child:Scaffold(

          appBar: AppBar(
            title: Text('Search by category'),
//            leading: Icon(Icons.location_searching),

          ),

          body: Container(
            child: Column(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  child: DropDownFormField(
                    titleText: 'Category',
                    hintText: 'Please choose one',
                    value: _searchKey,
                    onChanged: (value) {
                      setState(() {
                        _searchKey = value;
                      });
                      return _searchKey;
                    },
                    dataSource: [
                      {
                        "display": "Adventure",
                        "value": "Adventure",
                      },
                      {
                        "display": "Art",
                        "value": "Art",
                      },
                      {
                        "display": "Business",
                        "value": "Business",
                      },
                      {
                        "display": "Education",
                        "value": "Education",
                      },
                      {
                        "display": "Entertainment",
                        "value": "Entertainment",
                      },
                      {
                        "display": "Exhibitions",
                        "value": "Exhibitions",
                      },
                      {
                        "display": "Food & Drinks",
                        "value": "Food & Drinks",
                      },
                      {
                        "display": "Health",
                        "value": "Health",
                      },
                      {
                        "display": "Music & Dance",
                        "value": "Music & Dance",
                      },
                      {
                        "display": "Non-profit",
                        "value": "Non-profit",
                      },
                      {
                        "display": "Sports & Fitness",
                        "value": "Sports & Fitness",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
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
