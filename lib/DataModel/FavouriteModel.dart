/*
* author YR
* NuLendroit application
*
* Data Model for Favourite Event
*
*/

class Favourite{
  final String favouriteID;

  Favourite({this.favouriteID});
}

class FavouriteData{
  String favouriteId;
  String userId;
  String eventId;
  bool likeState;

  FavouriteData({
    this.favouriteId,
    this.userId,
    this.eventId,
    this.likeState,
  });
}