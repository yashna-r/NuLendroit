/*
* author YR
* NuLendroit application
*
* Data Model for User
*
*/

class User{

  final String uid;
  User({ this.uid });

}

class UserData {

  final String uid;
  final String username;
  final String role;
  final List preferences;
  final String userImgURL;

  UserData({ this.uid, this.username, this.role, this.preferences, this.userImgURL});

}
