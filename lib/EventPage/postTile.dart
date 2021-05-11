import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:nulendroit/DataModel/PostModel.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/Shared/dialogBox.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class PostTile extends StatefulWidget {

  final Post post;
  PostTile({this.post,});

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {

  DialogBox _dialogBox = new DialogBox();
  final CollectionReference postCollection = Firestore.instance.collection('posts');
  String currentUser;
//  bool userState = false;

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    currentUser = user.uid;

    Post post = widget.post;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),

        child: SizedBox(
            height: post.postImgURL != null ? null : 150,

            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[

                  Row(
                    children: <Widget>[

                      Expanded(
                        flex: 8,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            /*--------------Username--------------*/
                            SizedBox(
                              height: 30.0,
                              child: Text('${post.createdBy}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),

                            /*--------------Date and time--------------*/
                            SizedBox(
                              height: 20.0,
                              child: Text('Posted on ${post.date} at ${post.time}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Conditional.single(
                        conditionBuilder: (BuildContext context) => post.userId == currentUser,
                        widgetBuilder: (BuildContext context) =>
                        /*--------------Delete button--------------*/
                        Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(
                                Icons.clear,
                                size: 35.0,
                                color: Colors.grey,
                              ),

                              onPressed: () async{
                                await postCollection.document(post.postId).delete();
                                _dialogBox.information(context, 'Deleted', 'Your post was successfully removed');
                              },
                            )

                        ),

                        fallbackBuilder: (BuildContext context) => Container()
                      ),

                    ],
                  ),

                  /*--------------Image--------------*/
                  post.postImgURL != null ?
                  SizedBox(
                    height: 300.0,
                    width: double.infinity,
                    child: Container(
                        color: Colors.grey[200],
                        child: SizedBox(
                          //height: 200.0,
                          //width:240.0,
                          child: /*FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: post.postImgURL,
                            ),*/CachedNetworkImage(
                            imageUrl: post.postImgURL,
                            placeholder: (context, url) =>
                            //LinearProgressIndicator(),
                            Loading(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        )
                    ),
                  )
                      : Container(
                      height: 60.0,
                      color: Colors.grey[200],
                      child:Center(
                        child: Icon(Icons.error),
                      )
                  ),


                  /*--------------Description--------------*/
                  SizedBox(
                    //flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 5.0),
                        child: Text('${post.description}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                      )
                  ),

                ]
            )

        ),

      ),
    );
  }

}
