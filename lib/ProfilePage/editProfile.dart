import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/Services/databaseService.dart';
import 'package:nulendroit/Shared/dialogBox.dart';
import 'package:nulendroit/Shared/loading.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {

  UserData userData;
  EditProfile({this.userData});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final editFormKey = GlobalKey<FormState>();
  DialogBox _dialogBox = new DialogBox();
  
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final StorageReference userStorage = FirebaseStorage.instance.ref().child("User images");

  UserData _userData;

  File userImage;
  String currentUser;
  String _username;
  List _preferences;
  String _userImgURL;

  @override
  Widget build(BuildContext context) {

    _userData = widget.userData;

    User user = Provider.of<User>(context);
    currentUser = user.uid;

//    return StreamBuilder<UserData>(
//
//        stream: DatabaseService(userId: user.uid).userData,
//        builder: (context, snapshot) {

//          if(snapshot.hasData){
    if (_userData != null){
//            UserData userData = snapshot.data;
      return Form(
        key: editFormKey,
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              /*------------------Box title------------------*/
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: Container(
                  color: Colors.purple,
                  child: Center(
                    child: Text(
                      'Update your information',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 5.0),

              /*------------------User type------------------*/
              SizedBox(
                  height: 60.0,
                  width: double.infinity,
                  child: TextFormField(
                    initialValue: _userData.role,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'User type',
                      border: UnderlineInputBorder(),
                    ),
                  )
              ),

              SizedBox(height: 5.0),

              /*------------------Username------------------*/
              SizedBox(
                height: 60.0,
                child: TextFormField(
                  initialValue: _userData.username ?? '',
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) {
                    setState(() {
                      _username = val;
                    });
                  } ,

                ),
              ),

              SizedBox(height: 15.0,),

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
                hintText: 'Please choose one or more option(s)',
                value: _preferences,
                onSaved: (value) {
//                  if (value == null) return;
                  setState(() {
                    _preferences = value;
                  });
                },
              ),

              SizedBox(height: 15.0),

              /*------------------User image------------------*/
              Container(
                height: 350.0,
                padding: EdgeInsets.symmetric(horizontal:15.0,),// vertical: 5.0),
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

              /*-------------Buttons-------------*/
              SizedBox(
                height: 50.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[

                      /*------------------Cancel Button------------------*/
                      SizedBox(
                        height: 50.0,
                        width: 100.0,
                        child: RaisedButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 12.0),
                            color: Colors.teal[400],
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius
                                    .circular(25.0)
                            ),

                            onPressed: () {
                              Navigator.of(context).pop();
                              userImage = null;
                            },
                            child: Text("Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            )
                        ),
                      ),

                      /*------------------Save Button------------------*/
                      SizedBox(
                        height: 50.0,
                        width: 100.0,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
                          child: Text("Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                          color: Colors.teal[400],
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius
                                  .circular(25.0)
                          ),
                          onPressed: updateUserInfo,
                        ),
                      )

                    ]
                ),
              ),

            ],
          ),
        ),
      );
    } else {
      return Loading();

    }
//        }
//    );
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
              height: 240.0,
              width:240.0,
              child: Image.file(userImage, height: 240.0, width: 240.0,),
            ),

            SizedBox(height: 10.0,),

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
      height: 250.0,
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
            size: 40.0,
          )
      ),
    );
  }

/*---------------------------------------------------------------------------------------------------------------*/
/*----------------------------------------------------METHODS----------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------*/

  /*------------------Get image from gallery------------------*/
  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      userImage = tempImage;
    });
  }

  bool validateAndSave() {
    final form = editFormKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    else
      return false;
  }

  Future<void> updateUserInfo() async {
    if (validateAndSave()) {

      var timeKey = new DateTime.now();

      if (userImage != null) {
        final StorageUploadTask uploadTask = userStorage.child(
            timeKey.toString() + ".jpg").putFile(userImage);

        var url = await (await uploadTask.onComplete).ref.getDownloadURL();
        _userImgURL = url.toString();
        print("Image URL = " + _userImgURL);
      } else {
        _userImgURL = null;
      }

      await userCollection.document(currentUser).setData({
        'username': _username,
        'preferences': _preferences,
        'userImage': _userImgURL,
      }, merge: true);

      Navigator.pop(context);
      _dialogBox.information(context, 'Succesful', 'Your profile information has been saved.');
    }
  }
}
