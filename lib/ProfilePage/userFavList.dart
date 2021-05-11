import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/FavouriteModel.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/ProfilePage/userFavTile.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class UserFavList extends StatefulWidget {
  @override
  _UserFavListState createState() => _UserFavListState();
}

class _UserFavListState extends State<UserFavList> {

  @override
  Widget build(BuildContext context) {

    String currentUser;

    User user = Provider.of<User>(context);
    setState(() {
       currentUser = user.uid;
    });

    final favourites = Provider.of<List<FavouriteData>>(context) ?? [];


    List<FavouriteData> faveList;
    setState(() {
      faveList = favourites.where((fav) =>  fav.likeState == true && fav.favouriteId.contains(currentUser)).toList();
    });


    if(faveList !=null){

    return ListView.builder(
        itemCount: faveList.length,
        itemBuilder: (context, index) {
          return UserFavTile(favourites: faveList[index]);
        });
  }else{
      return Loading();
    }
}
}
