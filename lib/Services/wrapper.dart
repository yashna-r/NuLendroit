import 'package:flutter/material.dart';
import 'package:nulendroit/DataModel/UserModel.dart';
import 'package:nulendroit/MainPages/mainPage.dart';
import 'package:nulendroit/MainPages/welcome.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null){
      return WelcomePage();
    } else {
      return MainPage();
    }
  }
}
