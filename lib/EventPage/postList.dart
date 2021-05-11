import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/PostModel.dart';
import 'package:nulendroit/EventPage/postTile.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<Post>>(context) ?? [];

    if (posts != null) {
      return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostTile(post: posts[index]);
          });
    }
    else{
      return Loading();
    }
  }
}