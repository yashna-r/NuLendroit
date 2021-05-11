import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/PostModel.dart';
import 'package:nulendroit/ProfilePage/createPost.dart';
import 'package:nulendroit/ProfilePage/userPostList.dart';
import 'package:nulendroit/Services/databaseService.dart';
import 'package:provider/provider.dart';

class PostTab extends StatefulWidget {
  @override
  _PostTabState createState() => _PostTabState();
}

class _PostTabState extends State<PostTab> {
  @override
  Widget build(BuildContext context) {

    return StreamProvider<List<Post>>.value(
        value: DatabaseService().posts,

        child: Scaffold(
          resizeToAvoidBottomInset: false,

          body: Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: Column(
                children:<Widget>[

                  SizedBox(
                    height: 50.0,
                    width: 400.0,
                    child: RaisedButton(

                      child: Text("Create post"),
                      textColor: Colors.white,
                      color: Colors.teal[400],
                      onPressed: createPost,

                    ),
                  ),

                  Expanded(
                      child: UserPostList()
                  ),

                ]
            ),

          ),
        )
    );

  }

  /*------------------Navigate to create post page------------------*/
  void createPost(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostPage()));
  }
}
