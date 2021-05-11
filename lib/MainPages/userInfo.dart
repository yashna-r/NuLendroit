import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/MainPages/help.dart';
import 'package:provider/provider.dart';


class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  File userImage;
  final infoFormKey = new GlobalKey<FormState>();
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final StorageReference userStorage = FirebaseStorage.instance.ref().child("User images");

  List _preferences;
  String username, preferences, imgURL;
  String userId;

  @override
  void initState() {
    super.initState();
    _preferences = [];
  }

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);
    userId= user.uid;
    final bottom = MediaQuery
        .of(context)
        .viewInsets
        .bottom;


    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,

      appBar: AppBar(
        title: Text('User Information'),
        automaticallyImplyLeading: false,
      ),

      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom, left: 15.0, right: 15.0, top: 20.0),

          child: Form(
            key: infoFormKey,
            child: Column(

              children: <Widget>[

                /*------------------Username------------------*/
                new TextFormField(
                    onSaved: (value) {
                      username = value;
                      return username;
                    },
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter username',
                      border: new OutlineInputBorder(),
                    )
                ),

                SizedBox(height: 15.0),

                /*------------------Category preferences------------------*/
                MultiSelectFormField(
                  autovalidate: false,
                  titleText: 'Interested in',
                  validator: (value) {
                    if (value == null || value.length == 0) {
                      return 'Please select one or more categories';
                    }
                    else return null;
                  },
                  dataSource: [
                    {
                      "display": "Adventure",
                      "value": "Adventure",
                    },
                    {
                      "display": "Art",
                      "value": "Art",
                    },
                    {
                      "display": "Business",
                      "value": "Business",
                    },
                    {
                      "display": "Education",
                      "value": "Education",
                    },
                    {
                      "display": "Entertainment",
                      "value": "Entertainment",
                    },
                    {
                      "display": "Exhibitions",
                      "value": "Exhibitions",
                    },
                    {
                      "display": "Food & Drinks",
                      "value": "Food & Drinks",
                    },
                    {
                      "display": "Music & Dance",
                      "value": "Music & Dance",
                    },
                    {
                      "display": "Non-profit",
                      "value": "Non-profit",
                    },
                    {
                      "display": "Sports & Fitness",
                      "value": "Sports & Fitness",
                    },
                  ],
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintText: 'Please choose one or more',
                  value: _preferences,
                  onSaved: (value) {
                    if (value == null) return;
                    setState(() {
                      _preferences = value;
                    });
                  },
                ),

                SizedBox(height: 15.0),

                /*------------------Image------------------*/

                Container(
                  height: 350.0,
                  //color: Colors.purple[200],
                  padding: EdgeInsets.symmetric(horizontal:20.0, vertical: 5.0),
                  child: Column(
                      children: <Widget>[
                        SizedBox(
                            height: 30.0,
                            width: double.infinity,
                            child:Text('Upload photo:',
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 16.5,
                              ),
                            )
                        ),

                        SizedBox(
                            child: Container(
                              child: userImage == null
                                  ? imageButton()
                                  : imageUpload(),
                            )
                        ),

                      ]
                  ),
                ),

                /*------------------Buttons------------------*/
                SizedBox(
                  height: 100.0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        /*------------------Continue Button------------------*/
                        SizedBox(
                          height: 50.0,
                          width: 150.0,
                          child: RaisedButton(
                              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                              color: Colors.teal[400],
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius
                                      .circular(25.0)
                              ),
                              onPressed: createUserRecord,
                              child: Text("Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              )
                          ),
                        )

                      ]
                  ),
                )


              ],
            ),
          ),
        ),
      ),


    );
  }


/*---------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------DESIGN----------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------*/

  /*------------------Image uploaded------------------*/
  Widget imageUpload() {
    return Container(
        height: 300.0,
        child:Column(
          children: <Widget>[

            SizedBox(
              height: 200.0,
              child: Image.file(userImage,),
            ),

            SizedBox(height: 15.0,),

            /*------------------Cancel Button------------------*/
            SizedBox(
              height: 50.0,
              width: double.infinity,
              child: RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
                  color: Colors.purple[100],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)
                  ),

                  onPressed: getImage,
                  child: Icon(Icons.add_a_photo,
                    color: Colors.white,
                    size: 30.0,
                  )
              ),
            )
          ],
        )

    );
  }

  /*------------------Image button------------------*/
  Widget imageButton() {
    return SizedBox(
      height: 300.0,
      width: double.infinity,
      child: RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          color: Colors.purple[100],
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0)
          ),

          onPressed: getImage,
          child: Icon(Icons.add_a_photo,
            color: Colors.white,
            size: 50.0,
          )
      ),
    );
  }


/*---------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------METHODS----------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------*/
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      userImage = tempImage;
    });
  }

  bool validateAndSave() {
    final form = infoFormKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    else
      return false;
  }

  Future<void> createUserRecord() async {
    if (validateAndSave()) {
      var timeKey = new DateTime.now();

      if (userImage != null) {
        final StorageUploadTask uploadTask = userStorage.child(
            timeKey.toString() + ".jpg").putFile(userImage);

        var url = await (await uploadTask.onComplete).ref.getDownloadURL();
        imgURL = url.toString();
        print("Image URL = " + imgURL);
      } else {
        imgURL = '';
      }

      await userCollection.document(userId).setData({
        'username': username,
        'preferences': _preferences,
        'userImage': imgURL,
      }, merge: true);

      moveToMainPage();
    }
  }

  void moveToMainPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HelpPage()));
  }
}

