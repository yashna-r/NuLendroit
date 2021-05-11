import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/HomePage/recoTile.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class RecommendationList extends StatefulWidget {

  final UserData userData;
  RecommendationList({this.userData});

  @override
  _RecommendationListState createState() => _RecommendationListState();
}

class _RecommendationListState extends State<RecommendationList> {

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    String currentUser = user.uid;

    UserData userData = widget.userData;

    final events = Provider.of<List<EventData>>(context) ?? [];
    List<EventData> searchResults;

    String userPref;
    var _pref = userData.preferences;
    var concatenate = StringBuffer();

   if (_pref !=null) {
     _pref.forEach((item) {
       concatenate.write(item);
     });
     userPref = concatenate.toString();
   }else {
     userPref = '';
   }


   print("User Preferences: $userPref");

    if (currentUser == userData.uid) {
      setState(() {
        searchResults = events.where((event) =>
            userPref.contains(event.category))
            .toList();
      });
    }

    print(searchResults);

    if (searchResults != null) {

      return ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return RecommendationTile(event: searchResults[index]);
          });
    }else {

    return Loading() ;
    }
  }
}


