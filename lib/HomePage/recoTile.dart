import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:nulendroit/DataModel/EventModel.dart';
import 'package:nulendroit/DataModel/FavouriteModel.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/ExplorePage/eventInfo.dart';
import 'package:nulendroit/Services/authService.dart';
import 'package:nulendroit/Shared/dialogBox.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class RecommendationTile extends StatefulWidget {

  final EventData event;
  RecommendationTile({this.event});

  @override
  _RecommendationTileState createState() => _RecommendationTileState();
}

class _RecommendationTileState extends State<RecommendationTile> {

  DialogBox dialogBox = new DialogBox();
  String currentUser;
  bool likeState = false;
  String favID;

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    setState(() {
      currentUser = user.uid;
    });


    favID = currentUser+widget.event.eventId;

    final favourites = Provider.of<List<FavouriteData>>(context) ?? [];

    FavouriteData favEvent;
    favEvent = favourites.firstWhere((fav) => fav.userId == currentUser && fav.eventId == widget.event.eventId, orElse: () => null);

    if(favEvent != null){
      favID = favEvent.favouriteId;

      if(favEvent.likeState == true){
        likeState = true;

      }else{
        likeState = false;

      }
    }

    if(widget.event.createdBy != currentUser){
      return InkWell(
        onTap: navigateToEventInfo,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),

          child: SizedBox(
            //margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                /*--------------Image--------------*/
                //event.imgURL != null ?
                Expanded(
                    flex: 1,

                    child: SizedBox(
                      height: 300.0,
                      width: double.infinity,
                      child: Container(
                        color: Colors.grey[200],
                        child:  CachedNetworkImage(
                          imageUrl: widget.event.imgURL,
                          placeholder: (context, url) =>
                              Loading(),
                          errorWidget: (context, url, error) =>
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/no-image.png'),
                                    fit: BoxFit.cover,),
                                ),//Icon(Icons.error),
                              ),
                        ),
                      ),
                    )
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

                              Text('${widget.event.eventTitle}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Padding(padding: EdgeInsets.only(bottom: 5.0)),

                              /*--------------Location--------------*/
                              Text(
                                '${widget.event.location}',
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
                                '${widget.event.date}',
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

                          child:
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[

                              Conditional.single(
                                conditionBuilder: (BuildContext context) => likeState == false,
                                widgetBuilder: (BuildContext context) =>
                                    IconButton(
                                      icon: Icon(Icons.favorite_border),
                                      iconSize: 40.0,
                                      onPressed: favState,
                                    ),

                                fallbackBuilder: (BuildContext context) =>
                                    IconButton(
                                      icon: Icon(Icons.favorite, color: Colors.red,),
                                      iconSize: 40.0,
                                      onPressed: favState,
                                    ),
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
        ),
      );
    }else{
      return Container();
    }
  }

  //Function for adding event to favourite list
  void favState() async{

    final CollectionReference favouriteCollection = Firestore.instance.collection('favourites');

    if(likeState == false) {

      setState(() {
        likeState = true;
      });

      await favouriteCollection.document(favID).setData({
        'favouriteId': favID,
        'userId': currentUser,
        'eventId': widget.event.eventId,
        'likeState': likeState,
      }, merge: true);

      dialogBox.information(
          context, 'Added', 'Event added to your favourites');
      rebuildAllChildren(context);
    }else {

      setState(() {
        likeState = false;
      });

      await favouriteCollection.document(favID).setData({
        'favouriteId': favID,
        'userId': currentUser,
        'eventId': widget.event.eventId,
        'likeState': likeState,
      }, merge: true);

      dialogBox.information(
          context, 'Removed', 'Event removed from your favourites');
      rebuildAllChildren(context);
    }

  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  void navigateToEventInfo(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EventInfoPage(event: widget.event,), fullscreenDialog: true));

  }
}
