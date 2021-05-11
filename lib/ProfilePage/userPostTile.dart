import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/PostModel.dart';
import 'package:nulendroit/Shared/dialogBox.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class UserPostTile extends StatefulWidget {

  final Post post;
  UserPostTile({this.post,});

  @override
  _UserPostTileState createState() => _UserPostTileState();
}

class _UserPostTileState extends State<UserPostTile> {

  DialogBox _dialogBox = new DialogBox();
  final CollectionReference postCollection = Firestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {

    Post post = widget.post;


    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),

        child: SizedBox(
            height: post.postImgURL != null ? null : 150,

            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,

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
                                //maxLines: 2,
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

                      /*--------------Delete button--------------*/
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 30.0,
                              color: Colors.grey,
                            ),
                            onPressed: () async{
                              _dialogBox.information(context, 'Deleted', 'Your post was successfully removed');
                              await postCollection.document(widget.post.postId).delete();

                            },
                          )

                      )
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
                            placeholder: (context, url) => Loading(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        )
                    ),
                  )
                      : Container(
                      height: 60.0,
                      color: Colors.grey[200],
                      child: Center(
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
                    ),
                  ),

                ]
            )

        ),

      ),
    );
  }
}
