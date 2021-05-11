import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nulendroit/Shared/dialogBox.dart';
import 'package:provider/provider.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/MainPages/mainPage.dart';
import 'package:nulendroit/Services/databaseService.dart';

class CreatePostPage extends StatefulWidget {

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {

  DialogBox dialogBox = new DialogBox();
  File sampleImage;
  String currentUserId;
  String currentUser;
  String _description;
  String url;
  String postID;
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    currentUserId = user.uid;


    return StreamBuilder<UserData>(
      stream: DatabaseService(userId: user.uid).userData,
      builder: (context, snapshot) {

        UserData userData = snapshot.data;
        currentUser = userData.username;

        return Scaffold(
          appBar: new AppBar(

            title: new Text("Create post"),
            centerTitle: true,
          ),

          body: new Center(
            child: sampleImage == null? Text("Upload photo", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),): enableUpload(),
            // IconButton(icon: Icon(Icons.add_a_photo, size: 70.0, color: Colors.grey,), onPressed: getImage,)
          ),



          floatingActionButton: new FloatingActionButton(
            onPressed: getImage,
            tooltip: 'Add image',
            child: new Icon(Icons.add_a_photo),
          )
          ,
        );
      }
    );
  }

  Widget enableUpload(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: new Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Image.file(sampleImage, height: 330.0, width: 600.0,),

                SizedBox(height: 15.0),

                TextFormField(
                  maxLines: null,
                  decoration: new InputDecoration(
                      hintText: "Write a caption...",
                    border: UnderlineInputBorder(),
                  ),


                  validator: (value){
                    return value.isEmpty ? 'Description is required' : null;
                  },

                  onSaved: (value){
                    _description = value;
                    return _description;
                  },
                ),

                SizedBox(height: 15.0),

                SizedBox(
                  height: 50.0,
                  width: 150.0,
                  child: RaisedButton(
                      //elevation: 10.0,
                      child: Text("Add new post",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      textColor: Colors.white,
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27.0),
                      ),
                      onPressed: uploadPost,
                  ),
                ),

              ],
            )
        ),
      ),
    );

  }

  Future getImage() async {

    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }


  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()){
      form.save();
      return true;
    }
    else return false;
  }

  Future<void> saveToDatabase(String url) async {

    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('EEEE, d MMM yyyy');
    var formatTime =  new DateFormat('hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    CollectionReference postCollection = Firestore.instance.collection('posts');

    await postCollection.add({
      "image": url,
      "description": _description,
      "date": date,
      "time": time,
      "createdBy": currentUser,
      "userId": currentUserId,
    }).then((value){
      postID = value.documentID;
    });

    await postCollection.document(postID).setData({
      "postId": postID,
    }, merge: true);

  }

  void uploadPost() async{

    try{
      if(validateAndSave()){

        final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");
        var timeKey = new DateTime.now();
        final StorageUploadTask uploadTask= postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

        var imageURL = await (await uploadTask.onComplete).ref.getDownloadURL();
        url = imageURL.toString();
        print("Image URL = " + url);
        saveToDatabase(url);

        moveToMainPage();
        dialogBox.information(context, 'Successful post', 'Your post has been succesfully created.');

      }
    }catch(e){
      print(e.toString());
      dialogBox.information(context, 'Error', e.toString());
    }
  }

  void moveToMainPage() {

    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
  }


}
