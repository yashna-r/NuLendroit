import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/PostModel.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/ProfilePage/userPostTile.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class UserPostList extends StatefulWidget {
  @override
  _UserPostListState createState() => _UserPostListState();
}

class _UserPostListState extends State<UserPostList> {

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    String currentUser = user.uid;

    //print(currentUser);

    final posts = Provider.of<List<Post>>(context) ?? [];
    List userPosts = (posts.where((post) => post.userId == currentUser)).toList();

    print(userPosts);



    if (userPosts != null) {
      return ListView.builder(
          itemCount: userPosts.length,
          itemBuilder: (context, index) {
            return UserPostTile(post: userPosts[index]);
          });
    }
    else{
    return Loading();
    }
  }
}
