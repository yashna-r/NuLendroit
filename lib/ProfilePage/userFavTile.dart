import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/FavouriteModel.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/ExplorePage/eventInfo.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class UserFavTile extends StatefulWidget {

  final FavouriteData favourites;
  UserFavTile({this.favourites});

  @override
  _UserFavTileState createState() => _UserFavTileState();
}

class _UserFavTileState extends State<UserFavTile> {

  String favouriteId;
  String currentUser;
  bool likeState;

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    setState(() {
      currentUser = user.uid;
    });

    favouriteId = widget.favourites.favouriteId;


    final events = Provider.of<List<EventData>>(context) ?? [];
    EventData favEvent;
    setState(() {
      favEvent =
          events.firstWhere((f) => f.eventId == widget.favourites.eventId,
              orElse: () => null);
    });

    //print("URL: " +favEvent.imgURL);


    if(favEvent != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0),

        child: SizedBox(
          //margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              /*--------------Image--------------*/
//              favEvent.imgURL != null ?
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EventInfoPage(event: favEvent,)));
                    },
                    child: SizedBox(
                      height: 300.0,
                      width: double.infinity,
                      child: Container(
                        color: Colors.grey[200],
                        child: CachedNetworkImage(
                          imageUrl: favEvent.imgURL,
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
                    ),
                  )
//              ):Container(
//                color: Colors.pink[800],
              ),

              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      /*--------------Title--------------*/
                      Expanded(
                        flex: 4,
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Text('${favEvent.eventTitle}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Padding(padding: EdgeInsets.only(bottom: 5.0)),

                            /*--------------Location--------------*/
                            Text(
                              '${favEvent.location}',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black54,
                              ),
                            ),

                            Padding(padding: EdgeInsets.only(bottom: 30.0)),

                            /*--------------Date--------------*/
                            Text(
                              '${favEvent.date}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black87,
                              ),
                            ),

                          ],
                        ),

                      ),


                      Expanded(
                        flex: 1,

                        child: Row(

                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[

                            IconButton(
                              icon: likeState == false ? Icon(
                                  Icons.favorite_border) : Icon(
                                Icons.favorite, color: Colors.red,),
                              iconSize: 40.0,
                              onPressed: () {
                                favouriteState();
                                //rebuildAllChildren(context);
                              },
                            ),


                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    }else{
      return Container();
    }
  }


  void favouriteState() async {

    final CollectionReference favouriteCollection = Firestore.instance.collection('favourites');
    //String favouriteID;

    if (true) {
      setState(() {
        likeState = false;
      });

      favouriteCollection.document(favouriteId).delete();
    }
  }
}

