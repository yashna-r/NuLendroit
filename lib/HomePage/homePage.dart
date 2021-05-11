import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/FavouriteModel.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/HomePage/recoList.dart';
import 'package:nulendroit/Services/databaseService.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState(){
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(userId: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            UserData userData = snapshot.data;

            return StreamProvider<List<FavouriteData>>.value(
              value: DatabaseService().favourites,
              child: StreamProvider<List<EventData>>.value(
                value: DatabaseService().events,

                child: Scaffold(
                    resizeToAvoidBottomInset: true,

                    body: Container(
                      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                              height: 30.0,
                              width: double.infinity,
                              child: Text('Events for you...',
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                          ),


                          Expanded(
                              child: RecommendationList(userData: userData,)
                          )
                        ],
                      ),
                    )

                ),
              ),
            );
          }else{
            return Loading();
          }

        }
    );


  }


}

//return Scaffold(
//        body: Container(
//          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
//            alignment: Alignment.topCenter,
//            child: TextFormField(
//              decoration: InputDecoration(
//                hintText: 'Enter address',
//                prefixIcon: Icon(Icons.location_searching)
//              ),
//              onTap: () async {
//                // show input autocomplete with selected mode
//                // then get the Prediction selected
//                Prediction p = await PlacesAutocomplete.show(
//                    context: context, apiKey: kGoogleApiKey, mode: Mode.overlay, language: 'en', components: [
//                      Component(Component.country, "uk")
//                ]);
//                //displayPrediction(p);
//              },
//              //child: Text('Find address'),
//
//            )
//        )
//    );




//  Future<Null> displayPrediction(Prediction p) async {
//
//    if (p != null) {
//      PlacesDetailsResponse detail =
//      await _places.getDetailsByPlaceId(p.placeId);
//
//      var placeId = p.placeId;
//      double lat = detail.result.geometry.location.lat;
//      double lng = detail.result.geometry.location.lng;
//
//      var address = await Geocoder.local.findAddressesFromQuery(p.description);
//
//      print(placeId);
//      print(address);
//      print(lat);
//      print(lng);
//    }
//  }